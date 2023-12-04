DELIMITER //

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