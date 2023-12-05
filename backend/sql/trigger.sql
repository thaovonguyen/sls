DELIMITER $$

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
END $$

DELIMITER ;

