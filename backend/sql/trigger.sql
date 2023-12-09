DELIMITER //
-- ===================================== DUY ANH ====================================

-- TRIGGER: Sau khi thêm hoá đơn phạt, kiểm tra nếu số lần cảnh cáo >= 3
-- thì chuyển trạng thái bạn đọc tương ứng thành 'Khoá'

CREATE TRIGGER after_fine_invoice_insert
AFTER INSERT ON fine_invoice
FOR EACH ROW
BEGIN
    DECLARE _uid INT;
    DECLARE _warningCount INT;
    
    -- Tìm uid từ bảng borrow_record, reserve_record, hoặc on_site_record
    SET _uid = NULL;
    IF NEW.borrow_rid IS NOT NULL THEN
        SELECT uid INTO _uid FROM borrow_record WHERE rid = NEW.borrow_rid;
    ELSEIF NEW.reserve_rid IS NOT NULL THEN
        SELECT uid INTO _uid FROM reserve_record WHERE rid = NEW.reserve_rid;
    ELSEIF NEW.on_site_rid IS NOT NULL THEN
        SELECT uid INTO _uid FROM on_site_record WHERE rid = NEW.on_site_rid;
    END IF;

    -- Kiểm tra và cập nhật warning_time của người dùng
    IF _uid IS NOT NULL AND new.reason = 'Làm mất sách' THEN
        SELECT warning_time INTO _warningCount FROM luser WHERE uid = _uid;

        -- Chỉ tăng warning_time nếu nó nhỏ hơn 3
        IF _warningCount < 3 THEN
            UPDATE luser
            SET warning_time = warning_time + 1
            WHERE uid = _uid;
        -- Cập nhật ustatus thành 'Khóa' nếu warning_time đã đạt 3
        ELSEIF _warningCount >= 3 THEN
            UPDATE luser
            SET ustatus = 'Hạn chế'
            WHERE uid = _uid;
        END IF;
    END IF;
END //

-- TRIGGER: Sau khi xóa hóa đơn phạt, nếu bạn đọc bị hạn chế/khóa do hóa đơn phạt đó thì chuyển về 'Bình thường'
-- và trừ warning_time
CREATE TRIGGER after_delete_fine
AFTER DELETE ON fine_invoice
FOR EACH ROW
BEGIN
	DECLARE _uid INT;
	DECLARE _warning_time INT;
    DECLARE _status ENUM('Khóa', 'Hạn chế', 'Bình thường');

    SELECT uid, warning_time, ustatus INTO _uid, _warning_time, _status
    FROM luser 
    JOIN borrow_record ON luser.uid = borrow_record.uid
    JOIN fine_invoice ON fine_invoice.borrow_id = borrow_record.rid
    WHERE fine_invoice.fid = old.fid;
    
    IF _status = 'Hạn chế' AND old.reason = 'Làm mất sách' THEN
		UPDATE luser
        SET ustatus = 'Bình thường'
        WHERE uid = _uid;
	ELSEIF _status = 'Khóa' AND old.fstatus = 'Chưa thanh toán' THEN
		UPDATE luser
        SET ustatus = 'Bình thường', warning_time = warning_time - 1
        WHERE uid = _uid;
	ELSEIF old.reason = 'Làm mất sách' THEN
		UPDATE luser
        SET warning_time = warning_time - 1
        WHERE uid = _uid;
    END IF;
END //


-- TRIGGER: Sau khi thêm phiếu mượn về nhà, chuyển trạng thái bản in thành 'Đã mượn'
-- và cập nhật trạng thái phiếu đặt trước liên kết với nó thành 'Hoàn tất'

CREATE TRIGGER after_insert_borrow_record
AFTER INSERT ON borrow_record
FOR EACH ROW
BEGIN
    -- Cập nhật trạng thái của bản in trong bảng printing
    IF new.bstatus = 'Đang tiến hành' THEN
		UPDATE printing
		SET dstatus = 'Đã mượn'
		WHERE did = NEW.did AND pid = NEW.pid;
    END IF;

    -- Cập nhật trạng thái của phiếu đặt trước liên quan trong bảng reserve_record
    UPDATE reserve_record
    SET rstatus = 'Hoàn tất',
		borrow_rid = NEW.rid
    WHERE did = NEW.did AND pid = NEW.pid AND borrow_rid IS NULL AND rstatus = 'Thành công';
END //

-- ===================================== THẢO ====================================

CREATE TRIGGER after_insert_printing
AFTER INSERT ON printing
FOR EACH ROW
BEGIN
    UPDATE printing_import
    SET amount = amount + 1, cost = cost + new.cost
    WHERE printing_import.iid = new.iid;
END //

CREATE TRIGGER before_insert_reserve_record
BEFORE INSERT ON reserve_record
FOR EACH ROW
BEGIN
    SET NEW.deposit = (SELECT cover_cost FROM document WHERE document.did = NEW.did);
    IF new.rstatus = 'Thành công' THEN
		UPDATE printing 
		SET dstatus = 'Đặt trước'
		WHERE printing.did = NEW.did AND printing.pid = NEW.pid;
    END IF;
END //

CREATE TRIGGER before_insert_borrow_record
BEFORE INSERT ON borrow_record
FOR EACH ROW
BEGIN
    SET NEW.deposit = (SELECT cover_cost FROM document WHERE document.did = NEW.did);
    SET NEW.return_fund = NEW.deposit - 7000 * new.extend_time;
	SET NEW.expected_return_date = DATE_ADD(NEW.start_date, INTERVAL (30 + 7*NEW.extend_time) DAY);
END //

DELIMITER ;