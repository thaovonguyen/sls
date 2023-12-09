DELIMITER //
-- FUNCTION: Số tiền phạt trong một tháng bất kỳ của thư viện (không tính các hóa đơn chưa thanh toán)
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

-- FUNCTION: Số sách hiện đang ở một chi nhánh
CREATE FUNCTION printing_count(_bid INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE result INT;
    DECLARE branch_valid BOOLEAN;
    
    SET branch_valid = EXISTS(SELECT * FROM branch WHERE branch.bid = _bid);
    
    IF branch_valid = FALSE THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chi nhánh không tồn tại';
	END IF;

    -- Check if the import exists
    SELECT COUNT(*) INTO result
    FROM printing
    JOIN printing_import ON printing.iid = printing_import.iid
    WHERE printing_import.bid = _bid;

	RETURN result;
END //

DELIMITER ;
