DELIMITER //

CREATE EVENT expired_record
ON SCHEDULE
	AT CURRENT_TIMESTAMP
--     EVERY 1 DAY
--     STARTS TIMESTAMP(CURDATE() + INTERVAL 6 HOUR)
DO
BEGIN
	DECLARE _currentDate DATE; 
    DECLARE rid_value INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT rid FROM borrow_record WHERE bstatus = 'Đang tiến hành' AND DATEDIFF(CURDATE(), expected_return_date) > 15;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET _currentDate = CURDATE();
    
    -- Các phiếu mượn quá hạn trả hơn 15 ngày: cập nhật sách về trạng thái Thất lạc
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO rid_value;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL UpdateBorrowRecordStatus_Overdue(rid_value);
    END LOOP;

    CLOSE cur;
    
    -- Các phiếu mượn quá hạn trả trong vòng 15 ngày: cập nhật phiếu sang trạng thái quá hạn
	UPDATE borrow_record
    SET bstatus = 'Quá hạn'
    WHERE bstatus = 'Đang tiến hành' AND DATEDIFF(_currentDate, expected_return_date) > 0;
    
    -- Các phiếu phạt quá hạn trả 15 ngày: bạn đọc bị khóa tài khoản
	UPDATE luser
	SET status = 'Khóa'
	WHERE uid IN (
		SELECT uid
		FROM borrow_record
        JOIN fine_invoice ON fine_invoice.borrow_rid = borrow_record.rid
		WHERE fine_invoice.fstatus = 'Chưa thanh toán' AND DATEDIFF(_currentDate, fine_invoice.fdate) > 15
	);
END //

DELIMITER ;
