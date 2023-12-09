-- Test case 1: Tạo phiếu mượn, gia hạn phiếu mượn và trả sách đúng hạn (sách có hư hỏng)

call sls_database.InsertBorrowRecord(2, 2, 1, 2);

call sls_database.ExtendBorrowTime(8);

call sls_database.borrowBookReturn(8, 5);

SELECT * FROM sls_database.borrow_record;

SELECT * FROM sls_database.fine_invoice;

-- Test case 2: Từ phiếu đặt trước, tạo phiếu mượn

INSERT INTO reserve_record (rdate, rstatus, uid, did, pid)
VALUES ('2023-12-10', 'Thành công', 2, 2, 3);

call sls_database.InsertBorrowRecord(2, 2, 3, 7); -- Mượn sai chi nhánh

call sls_database.InsertBorrowRecord(5, 2, 3, 3); -- Người khác mượn bản 2,3

call sls_database.InsertBorrowRecord(2, 2, 3, 3); -- Mượn thành công

SELECT * FROM sls_database.reserve_record;

SELECT * FROM sls_database.printing;

SELECT * FROM sls_database.borrow_record;

-- Test case 3: Từ phiếu mượn đã quá hạn, khởi động event, chuyển sang trả sau hạn, tài khoản bị Hạn chế
INSERT INTO borrow_record (start_date, bstatus, sid, uid, did, pid)
VALUES ('2023-9-2', 'Đang tiến hành', 2, 11, 2, 3);

-- Chạy event -> borrow_record về quá hạn
call sls_database.borrowBookReturn(10, 0);

SELECT * FROM sls_database.borrow_record;

SELECT * FROM sls_database.printing;

SELECT * FROM sls_database.fine_invoice;

SELECT * FROM sls_database.luser;

-- Test case 4: Tạo và xóa phiếu mượn vừa tạo
call sls_database.InsertBorrowRecord(2, 2, 1, 2);

call sls_database.DeleteBorrowRecord(11);

SELECT * FROM sls_database.borrow_record;

SELECT * FROM sls_database.printing;

-- Test case 5: Tài khoản bị khóa/hạn chế thì không thể mượn sách
call sls_database.InsertBorrowRecord(9, 1, 2, 3);

call sls_database.InsertBorrowRecord(11, 1, 2, 3);

SELECT * FROM sls_database.luser;

-- Test case 6: Các sách thất lạc/đã mượn thì không được mượn
call sls_database.InsertBorrowRecord(5, 6, 3, 2); -- Bản in thất lạc

call sls_database.InsertBorrowRecord(5, 3, 1, 2); -- Mượn thành công bản 3,1

call sls_database.InsertBorrowRecord(6, 3, 1, 2); -- Bản 3,1 đã được mượn

SELECT * FROM sls_database.printing;

-- Test case 7: Các function
select sls_database.fine_report(7, 2023);

select sls_database.printing_count(3);

SELECT * FROM sls_database.fine_invoice;

