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
        SELECT COALESCE(SUM(fine), 0) INTO total
        FROM fine_invoice
        WHERE YEAR(fdate) = in_year AND MONTH(fdate) = in_month AND (fstatus = 'Đã thanh toán' OR fstatus = 'Đã gạch nợ');
        RETURN total;
    END IF;
END //

CREATE FUNCTION import_cost(id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE key_exists INT;
    DECLARE result INT;

    -- Check if the import exists
    SELECT COUNT(*) INTO key_exists
    FROM printing_import
    WHERE iid = id;

    IF key_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đợt nhập không tồn tại';
    ELSE
        -- Calculate the sum of costs
        SELECT COALESCE(SUM(cost), 0) INTO result
        FROM printing
        INNER JOIN printing_import ON printing_import.iid = printing.iid
        WHERE printing_import.iid = id;

        RETURN result;
    END IF;
END //

DELIMITER ;
