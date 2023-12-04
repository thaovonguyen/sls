DELIMITER //

CREATE PROCEDURE authorization(IN in_username VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
    DECLARE out_sid INT;
    DECLARE out_uid INT;
    DECLARE user_type enum('staff', 'client');
    DECLARE user_id INT;
    DECLARE authentication_result VARCHAR(255);
    
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


-- Các Lê

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

-- CREATE PROCEDURE insert_borrow(
--     IN sid INT,
--     IN uid INT,
--     IN did INT,
--     IN pid INT
-- )
-- BEGIN
--     IF sid IS NULL OR uid IS NULL OR did IS NULL OR pid IS NULL THEN
-- 		SET insert_result = 'Insert failed';
-- 	ELSE
-- 		--
--     END IF;
-- END //

DELIMITER ;