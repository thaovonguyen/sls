-- Test case 1: Tạo phiếu mượn, gia hạn phiếu mượn và trả sách đúng hạn (sách có hư hỏng)

call sls_database.InsertBorrowRecord(2, 2, 1, 2);

call sls_database.ExtendBorrowTime(8);

call sls_database.borrowBookReturn(8, 5);

SELECT * FROM sls_database.borrow_record;

SELECT * FROM sls_database.fine_invoice;

-- Test case 2: Từ phiếu đặt trước, tạo phiếu mượn

INSERT INTO reserve_record (rdate, rstatus, uid, did, pid)
VALUES ('2023-12-10', 'Thành công', 2, 2, 3);

-- Mượn sai chi nhánh
call sls_database.InsertBorrowRecord(2, 2, 3, 7);
-- Mượn đúng chi nhánh
call sls_database.InsertBorrowRecord(2, 2, 3, 3);

SELECT * FROM sls_database.reserve_record;

SELECT * FROM sls_database.printing;

SELECT * FROM sls_database.borrow_record;

-- Test case 3: Từ phiếu mượn đã quá hạn, khởi động event, chuyển sang trả sau hạn



-- Test case 4: Tạo và xóa phiếu mượn vừa tạo
call sls_database.InsertBorrowRecord(2, 2, 1, 2);

call sls_database.DeleteBorrowRecord(8);

SELECT * FROM sls_database.borrow_record;

SELECT * FROM sls_database.printing;
