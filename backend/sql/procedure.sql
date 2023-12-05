DELIMITER $$

DROP PROCEDURE IF EXISTS InsertFineInvoice;
CREATE PROCEDURE InsertFineInvoice (
    IN _fid INT, -- Mã HĐ
    IN _fdate DATE, -- Ngày phạt
    IN _fine INT, -- Tiền phạt
    IN _reason ENUM('Làm mất sách', 'Hủy đặt trước', 'Trễ hạn trả sách', 'Làm hư sách', 'Quá hạn và làm hỏng'),
    IN _fstatus ENUM('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ'),
    IN _borrow_rid INT,
    IN _reserve_rid INT,
    IN _onsite_rid INT
)
BEGIN
    DECLARE _today DATE;
    DECLARE _linkCount INT;
    SET _today = CURDATE();
    SET _linkCount = 0;

    -- Tính số liên kết với các loại phiếu
    IF _borrow_rid IS NOT NULL THEN SET _linkCount = _linkCount + 1; END IF;
    IF _reserve_rid IS NOT NULL THEN SET _linkCount = _linkCount + 1; END IF;
    IF _onsite_rid IS NOT NULL THEN SET _linkCount = _linkCount + 1; END IF;

    -- Kiểm tra các ràng buộc
    IF _fdate > _today THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thời gian phạt không được vượt quá ngày hiện tại.';

    ELSEIF _linkCount != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hóa đơn phạt phải liên kết với MỘT VÀ CHỈ MỘT loại phiếu.';

    ELSEIF _fine < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền phạt không được âm.';

	ELSEIF _reason NOT IN ('Làm mất sách', 'Hủy đặt trước', 'Trễ hạn trả sách', 'Làm hư sách', 'Quá hạn và làm hỏng') THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lý do phạt không hợp lệ. Chỉ được phép nhập các lý do: Làm mất sách, Hủy đặt trước, Trễ hạn trả sách, Làm hư sách, Quá hạn và làm hỏng';
        
	ELSEIF _fstatus NOT IN ('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ') THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Trạng thái không hợp lệ. Chỉ được phép nhập các trạng thái: Chưa thanh toán, Đã thanh toán, Đã gạch nợ';
        
    ELSEIF (_borrow_rid IS NOT NULL AND NOT EXISTS (SELECT * FROM borrow_record WHERE rid = _borrow_rid)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID Phiếu Mượn Về Nhà không tồn tại.';
        
	ELSEIF (_reserve_rid IS NOT NULL AND NOT EXISTS (SELECT * FROM reserve_record WHERE rid = _reserve_rid)) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID Phiếu Đặt Trước không tồn tại.';
        
	ELSEIF(_onsite_rid IS NOT NULL AND NOT EXISTS (SELECT * FROM on_site_record WHERE rid = _onsite_rid)) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID Phiếu Đọc Tại Chỗ không tồn tại.';        
	
    ELSEIF (_reason = 'Trễ hạn trả sách' AND (_borrow_rid IS NULL OR (SELECT bstatus FROM borrow_record WHERE rid = _borrow_rid) NOT IN ('Quá hạn', 'Trả sau hạn')))
        OR (_reason = 'Hủy đặt trước' AND (_reserve_rid IS NULL OR (SELECT rstatus FROM reserve_record WHERE rid = _reserve_rid) != 'Đã hủy'))
        OR (_reason = 'Làm mất sách' AND (_onsite_rid IS NULL OR (SELECT rstatus FROM on_site_record WHERE rid = _onsite_rid) NOT IN ('Quá hạn', 'Trả sau hạn'))) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lý do phạt không phù hợp với trạng thái của phiếu liên kết.';
    
    ELSE
        -- Thêm dữ liệu vào bảng fine_invoice
        INSERT INTO fine_invoice (fid, fdate, fine, reason, fstatus, on_site_rid, borrow_rid, reserve_rid)
        VALUES (_fid, _fdate, _fine, _reason, _fstatus, _onsite_rid, _borrow_rid, _reserve_rid);
    END IF;
END $$



CREATE PROCEDURE UpdateFineInvoice (
    IN _fid INT, -- Mã HĐ
    IN _fine INT, -- Tiền phạt
    IN _fstatus ENUM('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ')
)
BEGIN
    DECLARE _originalStatus ENUM('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ');

    -- Lấy trạng thái hiện tại của hóa đơn
    SELECT fstatus INTO _originalStatus FROM fine_invoice WHERE fid = _fid;
    
    -- Kiểm tra để không cho phép cập nhật nếu hóa đơn đã thanh toán hoặc đã gạch nợ
    IF _originalStatus IN ('Đã thanh toán', 'Đã gạch nợ') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể cập nhật hóa đơn phạt đã thanh toán hoặc đã gạch nợ.';
    ELSE
        -- Cập nhật hóa đơn phạt:
        UPDATE fine_invoice
        SET fine = _fine, fstatus = _fstatus
        WHERE fid = _fid;
    END IF;
END $$



CREATE PROCEDURE DeleteFineInvoice (
    IN _fid INT
)
BEGIN
    DECLARE _originalStatus ENUM('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ');

    -- Lấy trạng thái hiện tại của hóa đơn
    SELECT fstatus INTO _originalStatus FROM fine_invoice WHERE fid = _fid;

    -- Kiểm tra để không cho phép xóa nếu hóa đơn đã thanh toán hoặc đã gạch nợ
    IF _originalStatus IN ('Đã thanh toán', 'Đã gạch nợ') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa hóa đơn phạt đã thanh toán hoặc đã gạch nợ.';
    ELSE
        -- Xóa hóa đơn phạt
        DELETE FROM fine_invoice WHERE fid = _fid;
    END IF;
END $$


















CREATE PROCEDURE InsertBorrowRecord(
    IN _uid INT,
    IN _did INT,
    IN _pid INT,
    IN _start_date DATETIME,
    IN _return_date DATETIME,
    IN _deposit INT
)
BEGIN
    DECLARE _currentBorrows INT;
    DECLARE _userStatus ENUM('Bình thường', 'Bị khóa', 'Khóa tạm thời');
    DECLARE _printStatus ENUM('Có sẵn', 'Đã mượn', 'Đặt trước', 'Chỉ đọc', 'Thất lạc');
    DECLARE _reserveStatus ENUM('Thành công', 'Hoàn tất', 'Đã hủy', 'Đã hoàn tiền', 'Quá hạn');
    DECLARE _reserveID INT;
    DECLARE _overdueDays INT;
	
    -- Kiểm tra bạn đọc tồn tại
    IF NOT EXISTS (SELECT * FROM luser WHERE uid = _uid) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Người dùng không tồn tại.';
	END IF;
    
    -- Kiểm tra trạng thái của bạn đọc
    SELECT ustatus INTO _userStatus FROM luser WHERE uid = _uid;
    IF _userStatus IN ('Bị khóa', 'Khóa tạm thời') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn đọc không thể tạo phiếu mượn do trạng thái bị khóa.';
    END IF;
	
    -- Kiểm tra tài liệu tồn tại
	IF NOT EXISTS (SELECT * FROM document WHERE did = _did) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Tài liệu không tồn tại.';
	END IF;
	
    -- Kiểm tra bản in tồn tại
    IF NOT EXISTS (SELECT * FROM printing WHERE pid = _pid) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Bản in không tồn tại.';
	END IF;
    
    -- Kiểm tra ngày trả lớn hơn ngày mượn
    IF _start_date > _return_date THEN
		SIGNAL SQLSTATE '45000'
        SQL MESSAGE_TEXT = 'Ngày trả không được vượt quá bắt đầu mượn.'
    
    -- Kiểm tra số phiếu mượn hiện tại của người dùng
    SELECT COUNT(*) INTO _currentBorrows FROM borrow_record 
    WHERE uid = _uid AND bstatus = 'Đang tiến hành';
    IF _currentBorrows >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn đọc đã đạt giới hạn mượn tối đa 5 phiếu.';
    END IF;

    -- Kiểm tra trạng thái của Bản in
    SELECT dstatus INTO _printStatus FROM printing 
    WHERE did = _did AND pid = _pid;
    IF _printStatus = 'Đặt trước' THEN
        -- Tìm Phiếu đặt trước liên quan
        SELECT rid, rstatus INTO _reserveID, _reserveStatus FROM reserve_record 
        WHERE did = _did AND uid = _uid ORDER BY rdate DESC LIMIT 1;
        IF _reserveStatus != 'Thành công' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không có Phiếu đặt trước hợp lệ ở trạng thái "Thành công" cho bản in này.';
        END IF;
    ELSEIF _printStatus != 'Có sẵn' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bản in không khả dụng hoặc đã được mượn.';
    END IF;
	
    -- Tính số ngày quá hạn (nếu có)
--     SET _overdueDays = DATEDIFF(CURDATE(), _return_date);
--     IF _overdueDays > 15 THEN
--         -- Xử lý trường hợp quá hạn, tạo hóa đơn phạt (làm mất sách)
--         INSERT INTO fine_invoice (uid, did, fine, reason, fstatus)
--         VALUES (_uid, _did, _deposit, 'Làm mất sách', 'Đã gạch nợ');
--     ELSEIF _overdueDays > 0 THEN
--         -- Xử lý trường hợp trả sách trễ hạn
--         INSERT INTO fine_invoice (uid, did, fine, reason, fstatus)
--         VALUES (_uid, _did, LEAST(5000 * _overdueDays, _deposit), 'Trễ hạn trả sách', 'Đã gạch nợ');
--     END IF;

    -- Chèn phiếu mượn về nhà
    INSERT INTO borrow_record (uid, did, pid, start_date, return_date, bstatus)
    VALUES (_uid, _did, _pid, _start_date, _return_date, IF(_overdueDays > 0, 'Trả sau hạn', 'Đang tiến hành'));
END $$



CREATE PROCEDURE UpdateBorrowRecord(
    IN _rid INT,
    IN _returnDate DATETIME,
    IN _extendTime INT
)
BEGIN
    DECLARE _originalReturnDate DATETIME;
    DECLARE _overdueDays INT;
    DECLARE _uid INT;
    DECLARE _deposit INT;
    DECLARE _newStatus ENUM('Hoàn tất', 'Đang tiến hành', 'Quá hạn', 'Trả sau hạn');
    DECLARE _currentDate DATE;

    -- Lấy thông tin ban đầu của phiếu mượn
    SELECT return_date, uid INTO _originalReturnDate, _uid FROM borrow_record WHERE rid = _rid;
    SET _currentDate = CURDATE();

    -- Tính số ngày quá hạn
    SET _overdueDays = DATEDIFF(_returnDate, _originalReturnDate);
    IF _overdueDays <= 0 THEN
        SET _newStatus = 'Hoàn tất';
    ELSEIF _overdueDays BETWEEN 1 AND 15 THEN
        SET _newStatus = 'Trả sau hạn';
        -- Xử lý trường hợp trả sách trễ hạn
        INSERT INTO fine_invoice (fdate, fine, reason, fstatus, borrow_rid)
        VALUES (_currentDate, 5000 * _overdueDays, 'Trễ hạn trả sách', 'Chưa thanh toán', _rid);
    ELSE
        SET _newStatus = 'Quá hạn';
        -- Xử lý trường hợp quá hạn
        SELECT deposit INTO _deposit FROM luser WHERE uid = _uid;
        INSERT INTO fine_invoice (fdate, fine, reason, fstatus, borrow_rid)
        VALUES (_currentDate, _deposit, 'Làm mất sách', 'Chưa thanh toán', _rid);
    END IF;

    -- Cập nhật phiếu mượn
    UPDATE borrow_record
    SET return_date = _returnDate, extend_time = _extendTime, bstatus = _newStatus
    WHERE rid = _rid;
END $$



CREATE PROCEDURE DeleteBorrowRecord(IN _rid INT)
BEGIN
    DECLARE _canDelete BOOLEAN DEFAULT TRUE;

    -- Kiểm tra xem có hóa đơn phạt nào đang ở trạng thái 'Chưa thanh toán'  đang liên kết với phiếu mượn không
    SET _canDelete = NOT EXISTS (
        SELECT * 
        FROM fine_invoice 
        WHERE rid = _rid AND fstatus = 'Chưa thanh toán'
    );

    IF _canDelete THEN
        -- Nếu không có hóa đơn phạt liên kết thì xóa phiếu mượn
        DELETE FROM borrow_record WHERE rid = _rid;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa phiếu mượn này do tồn tại liên kết với hóa đơn phạt chưa thanh toán.';
    END IF;
END $$













CREATE PROCEDURE InsertReserveRecord(
    IN _uid INT,
    IN _did INT,
    IN _pid INT,
    IN _rdate DATETIME
)
BEGIN
    DECLARE _userStatus ENUM('Bình thường', 'Bị khóa', 'Khóa tạm thời');
    DECLARE _printStatus ENUM('Có sẵn', 'Đã mượn', 'Đặt trước', 'Chỉ đọc', 'Thất lạc');
    DECLARE _currentReserveRecordCount INT;

	-- Kiểm tra bạn đọc tồn tại
    IF NOT EXISTS (SELECT * FROM luser WHERE uid = _uid) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Bạn đọc không tồn tại.';
	END IF;
	
    -- Kiểm tra trạng thái của bạn đọc
    SELECT ustatus INTO _userStatus FROM luser WHERE uid = _uid;
    IF _userStatus IN ('Bị khóa', 'Khóa tạm thời') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể tạo phiếu đặt trước do trạng thái của bạn đọc.';
    END IF;
    
    -- Kiểm tra tài liệu tồn tại
	IF NOT EXISTS (SELECT * FROM document WHERE did = _did) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Tài liệu không tồn tại.';
	END IF;

    -- Kiểm tra trạng thái của bản in
    SELECT dstatus INTO _printStatus FROM printing WHERE did = _did AND pid = _pid;
    IF _printStatus != 'Có sẵn' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bản in không có sẵn để đặt trước.';
    END IF;

    -- Kiểm tra số lượng phiếu đặt trước hiện tại của bạn đọc
    SELECT COUNT(*) INTO _currentReserveRecordCount FROM reserve_record WHERE uid = _uid AND rstatus = 'Thành công';
    IF _currentReservationCount >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn đọc đã đạt giới hạn số lượng đặt trước.';
    END IF;

    -- Thêm phiếu đặt trước mới
    INSERT INTO reserve_record (uid, did, pid, rdate, rstatus)
    VALUES (_uid, _did, _pid, _rdate, 'Thành công');
END $$



CREATE PROCEDURE UpdateReserveRecord(
    IN _rid INT,
    IN _newStatus ENUM('Thành công', 'Hoàn tất', 'Đã hủy', 'Đã hoàn tiền', 'Quá hạn'),
    IN _borrowRid INT
)
BEGIN
    DECLARE _currentDate DATE;
    DECLARE _rdate DATETIME;
    DECLARE _uid INT;

    SET _currentDate = CURDATE();
    SELECT rdate, uid INTO _rdate, _uid FROM reserve_record WHERE rid = _rid;

    -- Kiểm tra và xử lý trạng thái mới
    IF _newStatus = 'Đã hủy' OR _newStatus = 'Đã hoàn tiền' THEN
        -- Tạo hóa đơn phạt cho việc hủy đặt trước
        INSERT INTO fine_invoice (fdate, fine, reason, fstatus, reserve_rid)
        VALUES (_currentDate, 5 /* 5% tiền cọc */, 'Hủy đặt trước', 'Đã gạch nợ', _rid);
    IF _newStatus = 'Hoàn tất' AND _borrowRid IS NOT NULL THEN
        -- Cập nhật liên kết với phiếu mượn về nhà
        UPDATE reserve_record
        SET borrow_rid = _borrowRid
        WHERE rid = _rid;
    ELSEIF _newStatus = 'Quá hạn' AND DATEDIFF(_currentDate, _rdate) > 3 THEN
        -- Cập nhật trạng thái quá hạn
        UPDATE reserve_record
        SET rstatus = 'Quá hạn'
        WHERE rid = _rid;
    END IF;

    -- Cập nhật trạng thái phiếu đặt trước
    UPDATE reserve_record
    SET rstatus = _newStatus
    WHERE rid = _rid;
END $$



-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------


DELIMITER ;