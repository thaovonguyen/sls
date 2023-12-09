DELIMITER //

CREATE EVENT expired_record
ON SCHEDULE
	AT CURRENT_TIMESTAMP
--     EVERY 1 DAY
--     STARTS TIMESTAMP(CURDATE() + INTERVAL 6 HOUR)
DO
BEGIN
	UPDATE borrow_record
    SET bstatus = 'Quá hạn'
    WHERE bstatus = 'Đang tiến hành' AND DATE_ADD(start_date, INTERVAL 30 + extend_time * 7 DAY) < CURDATE();
    
    UPDATE reserve_record
    SET rstatus = 'Quá hạn'
    WHERE rstatus = 'Đang tiến hành' AND DATE_ADD(rdate, INTERVAL 3 DAY) < CURDATE();
    
    UPDATE on_site_record
    SET rstatus = 'Quá hạn'
    WHERE rstatus = 'Đang tiến hành' AND start_date < CURDATE();
    
    
END //

DELIMITER ;
