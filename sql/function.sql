DELIMITER //

CREATE FUNCTION fine_report(in_month INT, in_year INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE current_month INT;
    DECLARE current_year INT;
    DECLARE total INT;

    SET current_month = MONTH(NOW());
    SET current_year = YEAR(NOW());

    -- Kiểm tra tháng và năm nhập vào có lớn hơn hiện tại không
    IF (in_year > current_year) OR (in_year = current_year AND in_month >= current_month) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chưa có dữ liệu cho thời gian này';
    ELSE
        -- Nếu điều kiện đúng, thực hiện truy vấn tính tổng
        SELECT SUM(fine) INTO total
        FROM fine_invoice
        WHERE YEAR(fdate) = in_year AND MONTH(fdate) = in_month AND (fstatus = 'Đã thanh toán' OR fstatus = 'Đã gạch nợ');
        IF total IS NULL THEN
			SET total = 0;
		END IF;
        RETURN total;
    END IF;
END //



DELIMITER ;
