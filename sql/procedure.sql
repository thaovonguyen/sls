DELIMITER //

CREATE PROCEDURE authorization(IN in_username VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
    DECLARE out_sid INT;
    DECLARE out_uid INT;
    DECLARE user_type enum('staff', 'client');
    DECLARE user_id INT;
    DECLARE authentication_result VARCHAR(255);
    
    -- Retrieve user information based on the provided username
    SELECT sid, uid INTO out_sid, out_uid
    FROM login_info
    WHERE login_info.username = in_username AND login_info.password = in_password;
    
    -- Check if the provided password matches the stored hashed password
    IF out_sid IS NOT NULL OR out_uid IS NOT NULL THEN
        -- Authentication successful
        SET authentication_result = 'Authentication successful';
        IF out_sid IS NOT NULL THEN 
			SET user_type = 'staff';
            SET user_id = out_sid;
		ELSE
			SET user_type = 'client';
            SET user_id = out_uid;
        END IF;
    ELSE
        -- Authentication failed
        SET authentication_result = 'Authentication failed';
        SET user_id = NULL;
        SET user_type = NULL;
    END IF;
    
    -- Return the results
    SELECT authentication_result AS result, user_id, user_type;
END //

CREATE PROCEDURE insert_borrow(
    IN sid INT,
    IN uid INT,
    IN did INT,
    IN pid INT
)
BEGIN
    IF sid IS NULL OR uid IS NULL OR did IS NULL OR pid IS NULL THEN
		SET insert_result = 'Insert failed';
	ELSE
		--
    END IF;
END //

DELIMITER ;