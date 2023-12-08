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
    IF _uid IS NOT NULL THEN
        SELECT warning_time INTO _warningCount FROM luser WHERE uid = _uid;

        -- Chỉ tăng warning_time nếu nó nhỏ hơn 3
        IF _warningCount < 3 THEN
            UPDATE luser
            SET warning_time = warning_time + 1
            WHERE uid = _uid;
        END IF;

        -- Cập nhật ustatus thành 'Khóa' nếu warning_time đã đạt 3
        IF _warningCount >= 3 THEN
            UPDATE luser
            SET ustatus = 'Khóa'
            WHERE uid = _uid;
        END IF;
    END IF;
END //

-- TRIGGER: Sau khi thêm phiếu mượn về nhà, chuyển trạng thái bản in thành 'Đã mượn'
-- và cập nhật trạng thái phiếu đặt trước liên kết với nó thành 'Hoàn tất'

CREATE TRIGGER after_insert_borrow_record
AFTER INSERT ON borrow_record
FOR EACH ROW
BEGIN
    -- Cập nhật trạng thái của bản in trong bảng printing
    UPDATE printing
    SET dstatus = 'Đã mượn'
    WHERE did = NEW.did AND pid = NEW.pid;

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
END //

CREATE TRIGGER before_insert_borrow_record
BEFORE INSERT ON borrow_record
FOR EACH ROW
BEGIN
    SET NEW.deposit = (SELECT cover_cost FROM document WHERE document.did = NEW.did);
    SET NEW.return_fund = NEW.deposit - 7000 * new.extend_time;
END //

DELIMITER ;
