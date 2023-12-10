DELIMITER //
-- ============================= DUY ANH =============================
-- PROCEDURE: THÊM PHIẾU MƯỢN VỀ NHÀ

-- Note: sau khi insert sẽ gọi trigger after_insert_borrow_record
-- để chuyển trạng thái bản in sang 'Đã mượn' và cập nhật trạng thái phiếu đặt trước liên kết -> 'HOÀN TẤT'
CREATE PROCEDURE InsertBorrowRecord(
    IN _uid INT,
    IN _did INT,
    IN _pid INT,
    IN _sid INT
)
BEGIN
    DECLARE _userStatus ENUM('Hạn chế', 'Bình thường', 'Khoá');
    DECLARE _printStatus ENUM('Có sẵn', 'Đã mượn', 'Đặt trước', 'Chỉ đọc', 'Thất lạc');
    DECLARE _currentBorrowCount INT;
    DECLARE _reserveRecordExists INT DEFAULT 0;
    DECLARE _isReservedByUser INT DEFAULT 0;
    DECLARE _printing_branch INT;
    DECLARE _staff_branch INT;
    DECLARE _end_date DATE;
    
    -- Kiểm tra trạng thái của bạn đọc
    SELECT ustatus INTO _userStatus FROM luser WHERE uid = _uid;
    IF _userStatus != 'Bình thường' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tài khoản bạn đọc đã bị hạn chế hoặc bị khoá, không thể tạo phiếu mượn.';
    END IF;
    
    -- Kiểm tra nhân viên thủ thư có quyền xử lý bản in đó không
    SELECT bid INTO _printing_branch
    FROM printing_import 
    JOIN printing ON printing_import.iid = printing.iid
    WHERE did = _did AND pid = _pid;
    
    SELECT bid, end_date INTO _staff_branch, _end_date
    FROM staff WHERE sid = _sid;
    
    IF _printing_branch != _staff_branch OR _end_date < CURDATE() THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn không có quyền cho mượn quyển sách này.';
	END IF;
    
    -- Kiểm tra trạng thái của bản in và nếu nó đã được đặt trước bởi người dùng này
    SELECT dstatus, EXISTS(SELECT 1 FROM reserve_record 
		WHERE did = _did AND pid = _pid AND uid = _uid AND rstatus = 'Thành công') 
		INTO _printStatus, _isReservedByUser FROM printing WHERE did = _did AND pid = _pid;
    IF _printStatus = 'Đặt trước' AND _isReservedByUser = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bản in đã được đặt trước bởi người dùng khác.';
	-- Kiểm tra nếu bản in có sẵn
    ELSEIF _printStatus != 'Đặt trước' AND _printStatus != 'Có sẵn' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bản in không có sẵn để mượn.';
    END IF;

    -- Kiểm tra số lượng phiếu mượn về nhà hiện tại của bạn đọc
    SELECT COUNT(*) INTO _currentBorrowCount FROM borrow_record WHERE uid = _uid AND bstatus = 'Đang tiến hành';
    IF _currentBorrowCount >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn đọc đã đạt giới hạn số lượng phiếu mượn về nhà.';
    END IF;
    
    -- Thêm phiếu mượn về nhà mới
    INSERT INTO borrow_record (start_date, expected_return_date, return_date, extend_time, 
								bstatus, sid, uid, did, pid)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), NULL, 0,
			'Đang tiến hành', _sid, _uid, _did, _pid);
END //

-- PROCEDURE: Gia hạn sách

CREATE PROCEDURE ExtendBorrowTime(IN _rid INT)
BEGIN
    DECLARE _currentExtendTimes INT;
    DECLARE _currentReturnFund INT;
    DECLARE _currentExpectedReturnDate DATE;
    DECLARE _currentBStatus ENUM('Hoàn tất', 'Đang tiến hành', 'Quá hạn', 'Trả sau hạn');

    -- Lấy thông tin hiện tại của phiếu mượn
    SELECT extend_time, return_fund, expected_return_date, bstatus 
		INTO _currentExtendTimes, _currentReturnFund, _currentExpectedReturnDate, _currentBStatus
    FROM borrow_record
    WHERE rid = _rid;

	-- Kiểm tra trạng thái của phiếu mượn 
	IF _currentBStatus != 'Đang tiến hành' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chỉ có thể gia hạn cho phiếu mượn đang ở trạng thái "Đang tiến hành".';
    END IF;
    
    -- Kiểm tra xem có thể gia hạn không
    IF _currentExtendTimes < 2 THEN
        -- Tăng số lần gia hạn lên 1 và cập nhật ngày trả dự kiến
        UPDATE borrow_record
        SET extend_time = _currentExtendTimes + 1,
            expected_return_date = DATE_ADD(_currentExpectedReturnDate, INTERVAL 7 DAY)
        WHERE rid = _rid;

        -- Kiểm tra và cập nhật return_fund
        IF _currentReturnFund >= 7000 THEN
            UPDATE borrow_record
            SET return_fund = _currentReturnFund - 7000
            WHERE rid = _rid;
        ELSE
            UPDATE borrow_record
            SET return_fund = 0
            WHERE rid = _rid;
        END IF;
        SELECT NULL as result
    ELSE
        -- Trả về lỗi không thể gia hạn
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã đạt giới hạn gia hạn mượn sách.'
        
    END IF;
    
END //

-- PROCEDURE: THAY ĐỔI TRẠNG THÁI PHIẾU MƯỢN: ĐANG TIẾN HÀNH -> HOÀN TẤT

CREATE PROCEDURE UpdateBorrowRecordStatus_Completed(
    IN _rid INT,
    IN _damagePercentage INT
)
BEGIN
    DECLARE _expectedReturnDate DATE;
    DECLARE _did INT;
    DECLARE _pid INT;
    DECLARE _coverCost INT;		-- Giá bìa document
    DECLARE _currentDate DATE; 	-- Ngày hiện tại
    DECLARE _daysLate INT; 		-- Số ngày trễ hạn
    DECLARE _fineAmount INT DEFAULT 0; 	-- Tiền phạt
    DECLARE _fineReason ENUM('Làm mất sách', 'Hủy đặt trước', 'Trễ hạn trả sách', 'Làm hư sách', 'Quá hạn và làm hỏng');
    DECLARE _returnFund INT;
    
	SELECT br.expected_return_date, br.did, br.pid, br.return_fund, doc.cover_cost 
    INTO _expectedReturnDate, _did, _pid, _returnFund, _coverCost 
    FROM borrow_record br
    JOIN document doc ON br.did = doc.did
    WHERE br.rid = _rid;
	
    SET _currentDate = CURDATE();
	SET _daysLate = DATEDIFF(_currentDate, _expectedReturnDate);
    
    -- Tạo phiếu phạt 
	IF _daysLate > 0 OR _damagePercentage > 0 THEN
		-- Quá hạn và làm hỏng
		IF _damagePercentage > 0 AND _daysLate > 0 THEN
			SET _fineReason = 'Quá hạn và làm hỏng';
			SET _fineAmount = 5000 * _daysLate + _coverCost * _damagePercentage/100;
		-- Trễ hạn trả sách
		ELSEIF _daysLate > 0 THEN
			SET _fineReason = 'Trễ hạn trả sách';
            SET _fineAmount = 5000 * _daysLate;
		-- Làm hư sách
		ELSEIF _damagePercentage > 0 THEN
			SET _fineReason = 'Làm hư sách';
			SET _fineAmount = _coverCost * _damagePercentage/100;
		END IF;	

        -- Kiểm tra tiền hoàn trả có lớn hơn tiền phạt không
        IF _returnFund >= _fineAmount THEN
            SET _returnFund = _returnFund - _fineAmount;
        ELSE
            SET _returnFund = 0;
        END IF;
        
        -- Tạo hoá đơn phạt
		CALL InsertFineInvoice(_fineAmount, _fineReason, 'Đã gạch nợ', NULL, _rid, NULL);
    END IF;

    -- Cập nhật trạng thái phiếu mượn và bản in
    UPDATE borrow_record
    SET return_date = _currentDate, bstatus = 'Hoàn tất', return_fund = _returnFund
    WHERE rid = _rid;

    UPDATE printing
    SET dstatus = 'Có sẵn'
    WHERE did = _did AND pid = _pid;
END //

-- PROCEDURE: THAY ĐỔI TRẠNG THÁI PHIẾU MƯỢN: QUÁ HẠN -> TRẢ SAU HẠN

CREATE PROCEDURE UpdateBorrowRecordStatus_ReturnOverdue(
	IN _rid INT
)
BEGIN
	DECLARE _did INT;
    DECLARE _pid INT;

    -- Lấy thông tin did và pid từ bản ghi phiếu mượn
    SELECT did, pid INTO _did, _pid FROM borrow_record WHERE rid = _rid;

    -- Cập nhật trạng thái của phiếu mượn về nhà
    UPDATE borrow_record
    SET bstatus = 'Trả sau hạn', return_date = CURDATE()
    WHERE rid = _rid AND bstatus = 'Quá hạn';

    -- Cập nhật trạng thái của bản in liên quan
    UPDATE printing
    SET dstatus = 'Có sẵn'
    WHERE did = _did AND pid = _pid;
END //

-- PROCEDURE: THAY ĐỔI TRẠNG THÁI PHIẾU MƯỢN: QUÁ 15 NGÀY TỪ HẠN TRẢ -> SÁCH THẤT LẠC
CREATE PROCEDURE UpdateBorrowRecordStatus_Overdue(
    IN _rid INT
)
BEGIN
    DECLARE _expectedReturnDate DATE;
    DECLARE _did INT;
    DECLARE _pid INT;
    DECLARE _deposit INT;		-- Giá bìa document
    DECLARE _currentDate DATE; 	-- Ngày hiện tại
    DECLARE _daysLate INT; 		-- Số ngày trễ hạn
    DECLARE _fineAmount INT DEFAULT 0; 	-- Tiền phạt
    
	SELECT expected_return_date, did, pid, deposit
    INTO _expectedReturnDate, _did, _pid, _deposit
    FROM borrow_record
    WHERE rid = _rid;
	
    SET _currentDate = CURDATE();
	SET _daysLate = DATEDIFF(_currentDate, _expectedReturnDate);
    
    -- Tạo phiếu phạt 
	IF _daysLate > 15 THEN
		CALL InsertFineInvoice(_deposit, 'Làm mất sách', 'Đã gạch nợ', NULL, _rid, NULL);
    END IF;

    -- Cập nhật trạng thái phiếu mượn và bản in
    UPDATE borrow_record
    SET return_fund = 0
    WHERE rid = _rid;

    UPDATE printing
    SET dstatus = 'Thất lạc'
    WHERE did = _did AND pid = _pid;
END //

-- PROCEDURE: TRẢ SÁCH MƯỢN VỀ NHÀ
CREATE PROCEDURE borrowBookReturn (
    IN _rid INT,
    IN _damagePercentage INT
)
BEGIN
	DECLARE _expectedReturnDate DATE;
    DECLARE _currentDate DATE; 	-- Ngày hiện tại
    DECLARE _daysLate INT; 		-- Số ngày trễ hạn
    
	SELECT br.expected_return_date
    INTO _expectedReturnDate
    FROM borrow_record br
    WHERE br.rid = _rid;
	
    SET _currentDate = CURDATE();
	SET _daysLate = DATEDIFF(_currentDate, _expectedReturnDate);
    
    IF _daysLate > 15 THEN
		call UpdateBorrowRecordStatus_ReturnOverdue(_rid);
	ELSE 
		call UpdateBorrowRecordStatus_Completed(_rid, _damagePercentage);
	END IF;
END //

-- PROCEDURE: XOÁ PHIẾU MƯỢN VỀ NHÀ

CREATE PROCEDURE DeleteBorrowRecord(
	IN _rid INT
)
BEGIN
    DECLARE _did INT;
    DECLARE _pid INT;
    DECLARE _bstatus ENUM('Đang tiến hành', 'Hoàn tất', 'Quá hạn', 'Trả sau hạn');
    
    DECLARE _reserve_id INT;
    DECLARE _reserve_date DATE;
    
    -- Kiểm tra phiếu đặt trước liên quan (nếu có) và khôi phục trạng thái
    SELECT rid INTO _reserve_id
    FROM reserve_record WHERE reserve_record.borrow_rid = _rid;
    
    IF _reserve_id IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cần xóa phiếu đặt trước trước khi xóa phiếu mượn này.';
    END IF;

    -- Lấy thông tin did và pid từ bản ghi phiếu mượn
    SELECT did, pid, bstatus INTO _did, _pid, _bstatus FROM borrow_record WHERE rid = _rid;

    -- Xóa hóa đơn phạt liên quan (nếu có)
    DELETE FROM fine_invoice WHERE borrow_rid = _rid;

    -- Cập nhật trạng thái của bản in
    IF _bstatus = 'Đang tiến hành' OR _bstatus = 'Quá hạn' THEN
		UPDATE printing
		SET dstatus = 'Có sẵn'
		WHERE did = _did AND pid = _pid;
    END IF;

    -- Xóa bản ghi phiếu mượn
    DELETE FROM borrow_record WHERE rid = _rid;
END //


-- PROCEDURE: THÊM HOÁ ĐƠN PHẠT

CREATE PROCEDURE InsertFineInvoice(
    IN _fine INT,
    IN _reason enum('Làm mất sách', 'Hủy đặt trước', 'Trễ hạn trả sách', 'Làm hư sách', 'Quá hạn và làm hỏng'),
    IN _fstatus enum('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ'),
    IN _on_site_rid INT,
    IN _borrow_rid INT,
    IN _reserve_rid INT
)
BEGIN
	DECLARE _fdate DATE;
    SET _fdate = CURDATE();
    
	INSERT INTO fine_invoice (fdate, fine, reason, fstatus, on_site_rid, borrow_rid, reserve_rid)
	VALUES (_fdate, _fine, _reason, _fstatus, _on_site_rid, _borrow_rid, _reserve_rid);
END //

-- PROCEDURE: UPDATE HOÁ ĐƠN PHẠT

CREATE PROCEDURE UpdateFineInvoiceStatus_Paid(
	IN _fid INT
)
BEGIN
    DECLARE _borrowRid INT;
    DECLARE _uid INT;
    DECLARE _fdate DATE;
    DECLARE _currentDate DATE;
    DECLARE _daysLate INT;

    SET _currentDate = CURDATE();

    -- Lấy thông tin từ hóa đơn phạt
    SELECT borrow_rid, fdate INTO _borrowRid, _fdate FROM fine_invoice WHERE fid = _fid;

    -- Tính số ngày trễ hạn
    SET _daysLate = DATEDIFF(_currentDate, _fdate);

    -- Cập nhật trạng thái hóa đơn phạt
    UPDATE fine_invoice
    SET fstatus = 'Đã thanh toán'
    WHERE fid = _fid;

    -- Nếu hóa đơn quá 15 ngày, mở khóa tài khoản
    IF _daysLate > 15 THEN
        -- Tìm uid từ bảng borrow_record
        SELECT uid INTO _uid FROM borrow_record WHERE rid = _borrowRid;

        -- Mở khóa tài khoản
        UPDATE luser
        SET ustatus = 'Bình thường'
        WHERE uid = _uid;
    END IF; 
END //

-- ========================== THẢO ==========================
CREATE PROCEDURE authorization(IN in_username VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
    DECLARE out_sid INT;
    DECLARE out_uid INT;
    DECLARE user_type enum('staff', 'client');
    DECLARE user_id INT;
    DECLARE authentication_result VARCHAR(255);
    DECLARE out_password varchar(255);
    -- Retrieve user information based on the provided username
    SELECT sid, uid, password INTO out_sid, out_uid, out_password
    FROM login_info
    WHERE login_info.username = in_username;
    
    -- Check if the provided password matches the stored hashed password
    
    IF out_password IS NULL THEN
		SET authentication_result = 'Username không tồn tại';
	ELSEIF out_password != in_password THEN
		SET authentication_result = 'Password không chính xác';
    ELSE
        -- Authentication successful
        SET authentication_result = 'Đăng nhập thành công';
        IF out_sid IS NOT NULL THEN 
			SET user_type = 'staff';
            SET user_id = out_sid;
		ELSE
			SET user_type = 'client';
            SET user_id = out_uid;
        END IF;
    END IF;
    
    -- Return the results
    SELECT authentication_result AS result, user_id, user_type;
END //

CREATE PROCEDURE doc_on_homepage ()
BEGIN
	SELECT * FROM document;
END //

-- Procedure Hiện thị sách trên Homepage

CREATE PROCEDURE search_by_name (IN in_name varchar(255))
BEGIN
	IF in_name IS NULL THEN 
        SELECT * FROM document;
    ELSE 
        SET in_name = CONCAT('%', in_name, '%');
        SELECT * FROM document WHERE document.dname LIKE in_name;
    END IF;
END //

CREATE PROCEDURE doc_display (IN input_id int)
BEGIN    
    -- Check if the row exists in con1
    IF EXISTS (SELECT 1 FROM book WHERE did = input_id) THEN
        SELECT document.*, book.btype, GROUP_CONCAT(book_author.author_name) AS author, 'Sách' AS type
		FROM document
		LEFT JOIN book ON document.did = book.did
		LEFT JOIN book_author ON book.did = book_author.did
		WHERE document.did = input_id
		GROUP BY document.did;
    -- Check if the row exists in con2
    ELSEIF EXISTS (SELECT 1 FROM magazine WHERE did = input_id) THEN
        SELECT document.*, magazine.volumn, magazine.highlight, 'Tạp chí' AS type
		FROM document
		LEFT JOIN magazine ON document.did = magazine.did
		WHERE document.did = input_id;
    -- Check if the row exists in con3
    ELSEIF EXISTS (SELECT 1 FROM report WHERE did = input_id) THEN
        SELECT document.*, report.nation, report.field, 'Báo cáo' AS type
		FROM document
		LEFT JOIN report ON document.did = report.did
		WHERE document.did = input_id;
	ELSE
		SELECT document.*, 'Khác' AS type
        FROM document WHERE document.did = input_id;
    END IF;
    -- Return the result
END //

-- Các Lê


CREATE PROCEDURE GetDocType(IN in_did INT)
BEGIN    
    IF EXISTS (SELECT 1 FROM book WHERE did = in_did) THEN
    SELECT 'Sách' AS type;
    ELSEIF EXISTS (SELECT 1 FROM magazine WHERE did = in_did) THEN
    SELECT 'Tạp chí' AS type;
    ELSEIF EXISTS (SELECT 1 FROM report WHERE did = in_did) THEN
    SELECT 'Báo cáo' AS type;
    ELSE 
    SELECT 'Không tồn tại tài liệu này' AS type;
    END IF;
END //


CREATE PROCEDURE GetUserInformation(IN in_user_type VARCHAR(10), IN in_uid INT)
BEGIN    
    IF in_user_type = 'staff' THEN
        -- Retrieve user information from the staff table
        SELECT *
        FROM staff
        WHERE sid = in_uid;
    ELSE 
        SELECT *
        FROM luser
        WHERE uid = in_uid;
    END IF;
END //

CREATE PROCEDURE GetBorrowRecord(IN in_uid INT)
BEGIN
    SELECT * 
    FROM borrow_record
    WHERE uid = in_uid;
END //

DELIMITER ;