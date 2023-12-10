INSERT INTO branch VALUES
(1, 'Tạ Quang Bửu', '200 Tạ Quang Bửu', 'Linh Trung', 'Thủ Đức', 'Hồ Chí Minh', 'https://maps.app.goo.gl/7Zz9JhjzUhNQXYbV6'),
(2, 'Lý Thường Kiệt', '90 Lý Thường Kiệt', '7', '10', 'Hồ Chí Minh', 'https://maps.app.goo.gl/KV7vTN7XB7JACCRz6');

INSERT INTO staff VALUES
(1, 'An', 'Nguyễn Văn', 'Nam', '123456789012', '1990-05-01', '0987654321', 'vanan@gmail.com', '2022-01-15', '2023-06-01', 1),
(2, 'Bình', 'Trần Thị', 'Nữ', '987654321012', '1985-08-15', '0912345678', 'binhtran@gmail.com', '2021-12-10', null, 1),
(3, 'Cường', 'Lê Minh', 'Nam', '456789123012', '1995-03-20', '0901122334', 'minhcuong@gmail.com', '2023-02-28', null, 1),
(4, 'Ngọc', 'Đặng Thị', 'Nữ', '567890123012', '1988-06-28', '0966333222', 'ngocdang@gmail.com', '2023-04-15', null, 2),
(5, 'Quốc', 'Nguyễn Văn', 'Nam', '345678901012', '1998-02-10', '0944555666', 'quocnv@gmail.com', '2022-05-08', null, 2),
(6, 'Hòa', 'Trịnh Thị', 'Nữ', '678901234012', '1983-12-03', '0955666777', 'hoatrinh@gmail.com', '2021-09-12', '2023-06-09', 2),
(7, 'Yến', 'Bùi Thị', 'Nữ', '123789456012', '1991-07-22', '0988777666', 'yenbui@gmail.com', '2022-08-18', null, 2);

INSERT INTO luser VALUES
(1, 'Ngọc', 'Trần Thị', 'Căn cước công dân', '123456789012', '/path/to/9f33c80d0', '123 Đường ABC, Quận 1, TP.HCM', '1990-05-15', 'Công ty ABC', '0987654321', 'ngoc.tran@gmail.com', 'Bình thường', 0, '2023-01-10'), -- Xong
(2, 'Anh', 'Nguyễn Văn', 'Căn cước công dân', '234567890123', '/path/to/b42a7e1f5', '456 Đường XYZ, Quận 2, TP.HCM', '1985-02-20', 'Công ty XYZ', '0912345678', 'anh.nguyen@gmail.com', 'Bình thường', 0, '2022-12-05'),
(3, 'Linh', 'Lê Thị', 'Căn cước công dân', '345678901234', '/path/to/6d8b2c0a1', '789 Đường LMN, Quận 3, TP.HCM', '1995-10-10', 'Công ty LMN', '0865432109', 'linh.le@gmail.com', 'Bình thường', 0, '2023-02-20'),
(4, 'Bình', 'Phạm Minh', 'Căn cước công dân', '456789012345', '/path/to/f73e1d2b4', '101 Đường PQR, Quận 4, TP.HCM', '1988-12-25', 'Công ty PQR', '0978563412', 'binh.pham@gmail.com', 'Bình thường', 0, '2022-11-18'),
(5, 'Thắng', 'Võ Thị', 'Căn cước công dân', '567890123456', '/path/to/a4e0b8c3d', '202 Đường UVW, Quận 5, TP.HCM', '1992-08-05', 'Công ty UVW', '0923456789', 'thang.vo@gmail.com', 'Bình thường', 0, '2023-03-15'),
(6, 'Tú', 'Lâm Thị', 'Căn cước công dân', '678901234567', '/path/to/1e6f8d2b0', '303 Đường XYZ, Quận 6, TP.HCM', '1997-09-18', 'Công ty XYZ', '0888888888', 'tu.lam@gmail.com', 'Bình thường', 0, '2022-10-30'),
(7, 'Hiếu', 'Nguyễn Văn', 'Căn cước công dân', '789012345678', '/path/to/9c8b0a1e3', '404 Đường ABC, Quận 7, TP.HCM', '1986-03-14', 'Công ty ABC', '0955555555', 'hieu.nguyen@gmail.com', 'Bình thường', 0, '2023-04-05'),
(8, 'Hà', 'Lê Thị', 'Căn cước công dân', '890123456789', '/path/to/5f0b2a7e1', '505 Đường LMN, Quận 8, TP.HCM', '1993-07-22', 'Công ty LMN', '0911111111', 'ha.le@gmail.com', 'Bình thường', 0, '2022-09-12'),
(9, 'Đức', 'Trần Văn', 'Thẻ học sinh', '1234567', '/path/to/4c3d2b1a8', '606 Đường PQR, Quận 9, TP.HCM', '2005-11-02', 'Trường PQR', '0944444444', 'duc.tran@gmail.com', 'Khóa', 0, '2023-05-20'),
(10, 'Hòa', 'Đinh Thị', 'Căn cước công dân', '012345678901', '/path/to/0b8c3d2a1', '707 Đường UVW, Quận 10, TP.HCM', '1998-06-11', 'Công ty UVW', '0977777777', 'hoa.dinh@gmail.com', 'Bình thường', 0, '2022-08-28'),
(11, 'Quân', 'Trương Minh', 'Căn cước công dân', '123012345678', '/path/to/1e5f3c8b0', '808 Đường XYZ, Quận 11, TP.HCM', '1989-04-30', 'Công ty XYZ', '0900000000', 'quan.truong@gmail.com', 'Bình thường', 0, '2023-06-22');

INSERT INTO login_info VALUES
('ngoctran', '123', 1, null),
('anhnguyen', '123', 2, null),
('linhle', '123', 3, null),
('phambinh', '123', 4, null),
('vothang', '123', 5, null),
('tulam', '123', 6, null),
('nguyenhieu', '123', 7, null),
('hale', '123', 8, null),
('ductran', '123', 9, null),
('hoadinh', '123', 10, null),
('quantruong', '123', 11, null),
('binhtran', '123', null, 2),
('cuongle', '123', null, 3),
('ngocdang', '123', null, 4),
('quocnguyen', '123', null, 5),
('yenbui', '123', null, 7);

INSERT INTO printing_import (iid, idate, bid)
VALUES
(1, '2022-04-06', 1),
(2, '2022-09-10', 1),
(3, '2022-05-08', 2);

INSERT INTO document VALUES
(1, 'Sức Mạnh Của Ngôn Ngữ', 'Cuốn sách này khám phá sức mạnh của ngôn ngữ và ảnh hưởng của nó đối với cuộc sống hàng ngày của chúng ta.', 'NXB Trí Tuệ', 190000),
(2, 'Đại Cương Về Toán Học', 'Sách này cung cấp cái nhìn tổng quan về các khái niệm toán học cơ bản và ứng dụng của chúng trong thế giới hiện đại.', 'NXB Giáo Dục', 180000),
(3, 'Cuộc Cách Mạng Công Nghiệp 4.0', 'Đàm phán về ảnh hưởng và triển vọng của cuộc cách mạng công nghiệp thứ tư đối với xã hội và kinh tế.', 'NXB Công Nghệ', 195000),
(4, 'Nghệ Thuật Sống Tốt', 'Hướng dẫn thực hành nghệ thuật sống tích cực và hạnh phúc mỗi ngày.', 'NXB Văn Hóa', 200000),
(5, 'Cuộc Phiêu Lưu Của Người Hùng', 'Câu chuyện về sự gan dạ và những cuộc phiêu lưu không ngừng của một người hùng.', 'NXB Trí Tuệ', 200000),
(6, 'Khoa Học Dữ Liệu', 'Hướng dẫn cơ bản về khoa học dữ liệu và ứng dụng của nó trong thế giới kinh doanh và nghiên cứu.', 'NXB Công Nghệ', 500000),
(7, 'Sử Ta - Lược Sử Việt Nam', 'Tổng quan về lịch sử Việt Nam từ những thời kỳ đầu tiên đến hiện đại.', 'NXB Giáo Dục', 175000),
(8, 'Điều Trị Bệnh Hiệu Quả', 'Cung cấp thông tin chi tiết về các phương pháp điều trị bệnh hiệu quả và bảo vệ sức khỏe.', 'NXB Lao Động Xã Hội', 198000),
(9, 'Tạp Chí Công Nghệ', 'Các xu hướng công nghệ mới, đánh giá sản phẩm và sự kiện nổi bật trong lĩnh vực công nghệ.', 'NXB Công Nghệ', 50000),
(10, 'Báo Cáo Khoa Học', 'Báo cáo về nghiên cứu và phát triển trong lĩnh vực khoa học và công nghệ.', 'Viện Khoa Học', 17000);

INSERT INTO book VALUES
(1, 'Kỹ năng mềm'),
(2, 'Sách tham khảo'),
(3, 'Kinh tế'),
(4, 'Kỹ năng mềm'),
(5, 'Văn học'),
(6, 'Sách tham khảo'),
(7, 'Văn học'),
(8, 'Khác');

INSERT INTO book_author VALUES
(1, 'Nguyễn Văn A'),
(2, 'Phạm Thị B'),
(2, 'Phan Thế U'),
(3, 'Nông Văn E'),
(4, 'Phạm Văn F'),
(5, 'Nguyễn Thị H'),
(6, 'Tạ Văn I'),
(6, 'Đinh Công M'),
(6, 'Võ Văn N'),
(7, 'Lìu Thị K'),
(7, 'Đỗ Bảo O'),
(8, 'Nguyễn Văn L');

INSERT INTO magazine VALUES
(9, 1, 'Công nghệ AI');

INSERT INTO report VALUES
(10, 'Vietnam', 'Khoa học tự nhiên');

INSERT INTO import_manage VALUES
(1, 2),
(2, 1),
(3, 6),
(3, 5);

INSERT INTO manage VALUES
(1, '2022-06-01', '2023-01-01', 1),
(3, '2023-01-02', null, 1),
(5, '2022-06-01', null, 2);

INSERT INTO printing VALUES
(1, 1, 'Có sẵn', 'Mua', 150000, 'nguyên vẹn', 1),
(1, 2, 'Có sẵn', 'Trường ABC', 0, 'nguyên vẹn', 3),
(2, 1, 'Có sẵn', 'Mua', 150000, 'nguyên vẹn', 1),
(2, 2, 'Có sẵn', 'Công ty XYZ', 0, 'nguyên vẹn', 3),
(2, 3, 'Có sẵn', null, 0, 'nguyên vẹn', 2),
(3, 1, 'Có sẵn', null, 0, 'nguyên vẹn', 1),
(3, 2, 'Có sẵn', 'Trường QRS', 0, 'nguyên vẹn', 3),
(3, 3, 'Có sẵn', 'Mua', 140000, 'nguyên vẹn', 2),
(4, 1, 'Có sẵn', 'Công ty TUV', 0, 'nguyên vẹn', 1),
(4, 2, 'Có sẵn', 'Mua', 180000, 'nguyên vẹn', 3),
(5, 1, 'Có sẵn', 'Mua', 185000, 'nguyên vẹn', 2),
(6, 1, 'Chỉ đọc', 'Công ty TUV', 0, 'nguyên vẹn', 2),
(6, 2, 'Chỉ đọc', 'Mua', 470000, 'nguyên vẹn', 3),
(6, 3, 'Thất lạc', null, 0, 'nguyên vẹn', 2), -- Xong
(7, 1, 'Có sẵn', '', 0, 'nguyên vẹn', 3),
(7, 2, 'Có sẵn', 'Mua', 170000, 'bị rách', 1), -- Xong
(7, 3, 'Có sẵn', 'Công ty KLM', 0, 'nguyên vẹn', 3),
(7, 4, 'Có sẵn', 'Trường WXY', 0, 'nguyên vẹn', 1),
(8, 1, 'Có sẵn', 'Trường ABC', 0, 'nguyên vẹn', 3),
(8, 2, 'Có sẵn', null, 0, 'nguyên vẹn', 2),
(8, 3, 'Có sẵn', 'Công ty XYZ', 0, 'bị rách', 3), -- Xong
(8, 4, 'Có sẵn', 'Mua', 180000, 'mất bìa', 1), -- Xong
(9, 1, 'Có sẵn', 'Mua', 50000, 'nguyên vẹn', 1),
(9, 2, 'Thất lạc', null, 0, 'bị rách', 3),  -- Xong
(9, 3, 'Có sẵn', 'Mua', 48000, 'nguyên vẹn', 2),
(9, 4, 'Có sẵn', 'Trường UVW', 0, 'nguyên vẹn', 3), -- Xong
(10, 1, 'Có sẵn', 'Công ty TUV', 0, 'mất bìa', 2), -- Xong
(10, 2, 'Có sẵn', 'Mua', 17000, 'nguyên vẹn', 3);

INSERT INTO borrow_record (rid, start_date, return_date, extend_time, bstatus, sid, uid, did, pid)
VALUES
(1, '2023-11-24', null, 0, 'Quá hạn', 5, 4, 9, 4),
(2, '2023-03-23', '2023-04-05', 0, 'Hoàn tất', 1, 8, 10, 1),
(3, '2023-01-23', '2023-02-25', 1, 'Hoàn tất', 1, 1, 8, 3),
(4, '2023-04-09', '2023-05-18', 2, 'Hoàn tất', 3, 7, 7, 2),
(5, '2023-09-12', '2023-11-01', 0, 'Trả sau hạn', 1, 11, 7, 2),
(6, '2023-05-05', '2023-06-10', 1, 'Hoàn tất', 2, 2, 8, 3),
(7, '2023-07-15', null, 0, 'Quá hạn', 4, 2, 5, 1),
(8, '2023-12-8', null, 0, 'Đang tiến hành', 2, 1, 3, 2);

INSERT INTO reserve_record (rid, rdate, rstatus, borrow_rid, uid, did, pid)
VALUES
(1, '2023-11-23', 'Hoàn tất', 1, 4, 9, 4);

INSERT INTO on_site_record VALUES
(1, '2023-08-28 12:30:00', '2023-08-28 15:02:00', 'Hoàn tất', 6, 10, 9, 2),
(2, '2023-09-20 09:30:00', null, 'Quá hạn', 6, 11, 9, 2),
(3, '2023-10-20 09:50:00', '2023-10-20 11:20:00', 'Hoàn tất', 1, 5, 8, 4),
(4, '2023-06-19 08:20:00', null, 'Quá hạn', 2, 11, 6, 3);

INSERT INTO fine_invoice VALUES
(1, '2023-04-05', 5000, 'Làm hư sách', 'Đã gạch nợ', null, 2, null),
(2, '2023-08-28', 10000, 'Làm hư sách', 'Đã thanh toán', 1, null, null),
(3, '2023-09-20', 50000, 'Làm mất sách', 'Đã thanh toán', 2, null, null),
(4, '2023-10-20', 20000, 'Làm hư sách', 'Đã thanh toán', 3, null, null),
(5, '2023-05-18', 20000, 'Làm hư sách', 'Đã gạch nợ', null, 4, null),
(6, '2023-07-20', 195000, 'Làm mất sách', 'Đã thanh toán', 4, null, null),
(7, '2023-07-20', 175000, 'Làm mất sách', 'Đã gạch nợ', null, 5, null);