-- CALL InsertFineInvoice(
--     20,                  -- fid
--     '2020-09-09',       -- fdate
--     10000,              -- fine
--     'Làm hư sách',      -- reason
--     'Đã thanh toán',    -- fstatus
--     5,               	-- borrow
--     NULL,               -- reserve
--     NULL               	-- onsite
-- );

-- INSERT INTO luser (uid, fname, lname, paper_type, paper_num, paper_path, home_address, bdate, workplace, phone, email, ustatus, warning_time, register_date)
-- VALUES 
-- (100, 'Alice', 'Smith', 'Căn cước công dân', '123456789', '/path/to/document', '123 Main St', '1990-01-01', 'ABC Company', '0123456789', 'alice@example.com', 'Bình thường', 3, '2020-01-01'),
-- (101, 'Bob', 'Jones', 'Căn cước công dân', '987654321', '/path/to/document', '456 Main St', '1992-02-02', 'XYZ Company', '9876543210', 'bob@example.com', 'Bình thường', 2, '2020-02-02');

-- INSERT INTO borrow_record (rid, start_date, return_date, extend_time, bstatus, sid, uid, did, pid)
-- VALUES 
-- (100, '2023-01-01 08:00:00', NULL, 0, 'Đang tiến hành', 1, 100, 1, 1),
-- (101, '2023-01-02 08:00:00', NULL, 0, 'Đang tiến hành', 2, 101, 2, 2);

-- INSERT INTO fine_invoice (fid, fdate, fine, reason, fstatus, borrow_rid)
-- VALUES (117, CURDATE(), 500, 'Làm hư sách', 'Chưa thanh toán', 100);


-- select * from fine_invoice;
-- select * from luser;
-- select * from borrow_record;
-- select * from staff;
-- select * from document;
-- select * from printing;


-- CALL GetFineDetailsForUser(100);

select * from luser;
select * from staff;

select * from printing;
select * from document;

select * from borrow_record;

CALL InsertBorrowRecord(1, 1, 1, 1);

CALL ExtendBorrowTime(2, 20);