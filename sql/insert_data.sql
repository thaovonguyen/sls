INSERT INTO branch VALUES
(01, 'Ta Quang Buu', '200 Ta Quang Buu', 'Linh Trung', 'Thủ Đức', 'Hồ Chí Minh', 'https://maps.app.goo.gl/7Zz9JhjzUhNQXYbV6'),
(02, 'Lý Thường Kiệt', '90 Lý Thường Kiệt', '7', '10', 'Hồ Chí Minh', 'https://maps.app.goo.gl/KV7vTN7XB7JACCRz6');

INSERT INTO staff VALUES
(01001, 'An', 'Nguyễn Văn', 'Nam', '123456789012', '1990-05-01', '0987654321', 'vanan@gmail.com', '2022-01-15', '2023-06-01', 001),
(01002, 'Bình', 'Trần Thị', 'Nữ', '987654321012', '1985-08-15', '0912345678', 'binhtran@gmail.com', '2021-12-10', null, 001),
(01003, 'Cường', 'Lê Minh', 'Nam', '456789123012', '1995-03-20', '0901122334', 'minhcuong@gmail.com', '2023-02-28', null, 001),
(02001, 'Ngọc', 'Đặng Thị', 'Nữ', '567890123012', '1988-06-28', '0966333222', 'ngocdang@gmail.com', '2023-04-15', null, 002),
(02002, 'Quốc', 'Nguyễn Văn', 'Nam', '345678901012', '1998-02-10', '0944555666', 'quocnv@gmail.com', '2022-05-08', null, 002),
(02003, 'Hòa', 'Trịnh Thị', 'Nữ', '678901234012', '1983-12-03', '0955666777', 'hoatrinh@gmail.com', '2021-09-12', '2023-06-09', 002),
(02004, 'Yến', 'Bùi Thị', 'Nữ', '123789456012', '1991-07-22', '0988777666', 'yenbui@gmail.com', '2022-08-18', null, 002);

INSERT INTO luser VALUES
(00001, 'Ngọc', 'Trần Thị', 'Căn cước công dân', '123456789012', '/path/to/9f33c80d0', '123 Đường ABC, Quận 1, TP.HCM', '1990-05-15', 'Công ty ABC', '0987654321', 'ngoc.tran@gmail.com', 'Bình thường', 1, '2023-01-10'), -- Xong
(00002, 'Anh', 'Nguyễn Văn', 'Căn cước công dân', '234567890123', '/path/to/b42a7e1f5', '456 Đường XYZ, Quận 2, TP.HCM', '1985-02-20', 'Công ty XYZ', '0912345678', 'anh.nguyen@gmail.com', 'Bình thường', 0, '2022-12-05'),
(00003, 'Linh', 'Lê Thị', 'Căn cước công dân', '345678901234', '/path/to/6d8b2c0a1', '789 Đường LMN, Quận 3, TP.HCM', '1995-10-10', 'Công ty LMN', '0865432109', 'linh.le@gmail.com', 'Bình thường', 0, '2023-02-20'),
(00004, 'Bình', 'Phạm Minh', 'Căn cước công dân', '456789012345', '/path/to/f73e1d2b4', '101 Đường PQR, Quận 4, TP.HCM', '1988-12-25', 'Công ty PQR', '0978563412', 'binh.pham@gmail.com', 'Bình thường', 0, '2022-11-18'),
(00005, 'Thắng', 'Võ Thị', 'Căn cước công dân', '567890123456', '/path/to/a4e0b8c3d', '202 Đường UVW, Quận 5, TP.HCM', '1992-08-05', 'Công ty UVW', '0923456789', 'thang.vo@gmail.com', 'Bình thường', 0, '2023-03-15'),
(00006, 'Tú', 'Lâm Thị', 'Căn cước công dân', '678901234567', '/path/to/1e6f8d2b0', '303 Đường XYZ, Quận 6, TP.HCM', '1997-09-18', 'Công ty XYZ', '0888888888', 'tu.lam@gmail.com', 'Bình thường', 0, '2022-10-30'),
(00007, 'Hiếu', 'Nguyễn Văn', 'Căn cước công dân', '789012345678', '/path/to/9c8b0a1e3', '404 Đường ABC, Quận 7, TP.HCM', '1986-03-14', 'Công ty ABC', '0955555555', 'hieu.nguyen@gmail.com', 'Bình thường', 0, '2023-04-05'),
(00008, 'Hà', 'Lê Thị', 'Căn cước công dân', '890123456789', '/path/to/5f0b2a7e1', '505 Đường LMN, Quận 8, TP.HCM', '1993-07-22', 'Công ty LMN', '0911111111', 'ha.le@gmail.com', 'Bình thường', 0, '2022-09-12'),
(00009, 'Đức', 'Trần Văn', 'Thẻ học sinh', '1234567', '/path/to/4c3d2b1a8', '606 Đường PQR, Quận 9, TP.HCM', '2005-11-02', 'Trường PQR', '0944444444', 'duc.tran@gmail.com', 'Khóa', 0, '2023-05-20'),
(00010, 'Hòa', 'Đinh Thị', 'Căn cước công dân', '012345678901', '/path/to/0b8c3d2a1', '707 Đường UVW, Quận 10, TP.HCM', '1998-06-11', 'Công ty UVW', '0977777777', 'hoa.dinh@gmail.com', 'Bình thường', 0, '2022-08-28'),
(00011, 'Quân', 'Trương Minh', 'Căn cước công dân', '123012345678', '/path/to/1e5f3c8b0', '808 Đường XYZ, Quận 11, TP.HCM', '1989-04-30', 'Công ty XYZ', '0900000000', 'quan.truong@gmail.com', 'Bình thường', 2, '2023-06-22');

INSERT INTO printing_import VALUES
(01001, '2022-04-06', 001),
(01002, '2022-09-10', 001),
(02001, '2022-05-08', 002);

INSERT INTO document VALUES
('SN00001', 'Sức Mạnh Của Ngôn Ngữ', 'Cuốn sách này khám phá sức mạnh của ngôn ngữ và ảnh hưởng của nó đối với cuộc sống hàng ngày của chúng ta.', 'NXB Trí Tuệ', 190000),
('SP00002', 'Đại Cương Về Toán Học', 'Sách này cung cấp cái nhìn tổng quan về các khái niệm toán học cơ bản và ứng dụng của chúng trong thế giới hiện đại.', 'NXB Giáo Dục', 180000),
('SN00005', 'Cuộc Cách Mạng Công Nghiệp 4.0', 'Đàm phán về ảnh hưởng và triển vọng của cuộc cách mạng công nghiệp thứ tư đối với xã hội và kinh tế.', 'NXB Công Nghệ', 195000),
('SP00006', 'Nghệ Thuật Sống Tốt', 'Hướng dẫn thực hành nghệ thuật sống tích cực và hạnh phúc mỗi ngày.', 'NXB Văn Hóa', 200000),
('SN00008', 'Cuộc Phiêu Lưu Của Người Hùng', 'Câu chuyện về sự gan dạ và những cuộc phiêu lưu không ngừng của một người hùng.', 'NXB Trí Tuệ', 200000),
('ST00009', 'Khoa Học Dữ Liệu', 'Hướng dẫn cơ bản về khoa học dữ liệu và ứng dụng của nó trong thế giới kinh doanh và nghiên cứu.', 'NXB Công Nghệ', 500000),
('SL00010', 'Sử Ta - Lược Sử Việt Nam', 'Tổng quan về lịch sử Việt Nam từ những thời kỳ đầu tiên đến hiện đại.', 'NXB Giáo Dục', 175000),
('SN00011', 'Điều Trị Bệnh Hiệu Quả', 'Cung cấp thông tin chi tiết về các phương pháp điều trị bệnh hiệu quả và bảo vệ sức khỏe.', 'NXB Lao Động Xã Hội', 198000),
('TC00001', 'Tạp Chí Công Nghệ', 'Các xu hướng công nghệ mới, đánh giá sản phẩm và sự kiện nổi bật trong lĩnh vực công nghệ.', 'NXB Công Nghệ', 50000),
('BC00001', 'Báo Cáo Khoa Học', 'Báo cáo về nghiên cứu và phát triển trong lĩnh vực khoa học và công nghệ.', 'Viện Khoa Học', 17000);

INSERT INTO book VALUES
('SN00001', 'Kỹ năng mềm'),
('SP00002', 'Sách tham khảo'),
('SN00005', 'Kinh tế'),
('SP00006', 'Kỹ năng mềm'),
('SN00008', 'Văn học'),
('ST00009', 'Sách tham khảo'),
('SL00010', 'Văn học'),
('SN00011', 'Khác');

INSERT INTO book_author VALUES
('SN00001', 'Nguyễn Văn A'),
('SP00002', 'Phạm Thị B'),
('SP00002', 'Phan Thế U'),
('SN00005', 'Nông Văn E'),
('SP00006', 'Phạm Văn F'),
('SN00008', 'Nguyễn Thị H'),
('ST00009', 'Tạ Văn I'),
('ST00009', 'Đinh Công M'),
('ST00009', 'Võ Văn N'),
('SL00010', 'Lìu Thị K'),
('SL00010', 'Đỗ Bảo O'),
('SN00011', 'Nguyễn Văn L');

INSERT INTO magazine VALUES
('TC00001', 1, 'Công nghệ AI');

INSERT INTO report VALUES
('BC00001', 'Vietnam', 'Khoa học tự nhiên');

INSERT INTO import_manage VALUES
(01001, 01002),
(01002, 01005),
(02001, 02003),
(02001, 02002);

INSERT INTO manage VALUES
(01001, '2022-06-01', '2023-01-01', 01),
(01004, '2023-01-02', null, 01),
(02002, '2022-06-01', null, 02);

INSERT INTO printing VALUES
('SN00001', 01, 'Có sẵn', 'Mua', 150000, 'nguyên vẹn', 01001),
('SN00001', 02, 'Có sẵn', 'Trường ABC', 0, 'nguyên vẹn', 02001),
('SP00002', 01, 'Có sẵn', 'Mua', 150000, 'nguyên vẹn', 01001),
('SP00002', 02, 'Có sẵn', 'Công ty XYZ', 0, 'nguyên vẹn', 02001),
('SP00002', 03, 'Có sẵn', null, 0, 'nguyên vẹn', 01002),
('SN00005', 01, 'Có sẵn', null, 0, 'nguyên vẹn', 01001),
('SN00005', 02, 'Có sẵn', 'Trường QRS', 0, 'nguyên vẹn', 02001),
('SN00005', 03, 'Có sẵn', 'Mua', 140000, 'nguyên vẹn', 01002),
('SN00006', 01, 'Có sẵn', 'Công ty TUV', 0, 'nguyên vẹn', 01001),
('SN00006', 02, 'Có sẵn', 'Mua', 180000, 'nguyên vẹn', 02001),
('SN00008', 01, 'Có sẵn', 'Mua', 185000, 'nguyên vẹn', 01002),
('SN00009', 01, 'Chỉ đọc', 'Công ty TUV', 0, 'nguyên vẹn', 01002),
('SN00009', 02, 'Chỉ đọc', 'Mua', 470000, 'nguyên vẹn', 02001),
('SN00009', 03, 'Thất lạc', null, 0, 'nguyên vẹn', 01002), -- Xong
('SL00010', 01, 'Có sẵn', '', 0, 'nguyên vẹn', 02001),
('SL00010', 02, 'Có sẵn', 'Mua', 170000, 'bị rách', 01001), -- Xong
('SL00010', 03, 'Có sẵn', 'Công ty KLM', 0, 'nguyên vẹn', 02001),
('SL00010', 04, 'Có sẵn', 'Trường WXY', 0, 'nguyên vẹn', 01001),
('SN00011', 01, 'Có sẵn', 'Trường ABC', 0, 'nguyên vẹn', 02001),
('SN00011', 02, 'Có sẵn', null, 0, 'nguyên vẹn', 01002),
('SN00011', 03, 'Có sẵn', 'Công ty XYZ', 0, 'bị rách', 02001), -- Xong
('SN00011', 04, 'Có sẵn', 'Mua', 180000, 'mất bìa', 01001), -- Xong
('TC00001', 01, 'Có sẵn', 'Mua', 50000, 'nguyên vẹn', 01001),
('TC00001', 02, 'Thất lạc', null, 0, 'bị rách', 02001),  -- Xong
('TC00001', 03, 'Có sẵn', 'Mua', 48000, 'nguyên vẹn', 01002),
('TC00001', 04, 'Có sẵn', 'Trường UVW', 0, 'nguyên vẹn', 02001), -- Xong
('BC00001', 01, 'Có sẵn', 'Công ty TUV', 0, 'mất bìa', 01002), -- Xong
('BC00001', 02, 'Có sẵn', 'Mua', 17000, 'nguyên vẹn', 02001);

INSERT INTO reserve_record VALUES
('R00004001', '2023-11-23', 'Hoàn tất', 'B00004001', 00004, 'TC00001', 04);

INSERT INTO borrow_record VALUES
('B00004001', '2023-11-24', null, null, 'Quá hạn', 2002, 00004, 'TC00001', 04),
('B00008001', '2023-03-23', '2023-04-05', null, 'Hoàn tất', 1001, 00008, 'BC00001', 01),
('B00001001', '2023-01-23', '2023-02-25', 1, 'Hoàn tất', 1001, 00001, 'SN00011', 03),
('B00007001', '2023-04-09', '2023-05-18', 2, 'Hoàn tất', 1003, 00007, 'SL00010', 02),
('B00011001', '2023-09-12', '2023-11-01', null, 'Trả sau hạn', 1001, 00011, 'SL00010', 02);

INSERT INTO on_site_record VALUES
('O00010001', '2023-08-28 12:30:00', '2023-08-28 15:02:00', 'Hoàn tất', 02003, 00010, 'TC00001', 02),
('O00001001', '2023-09-20 09:30:00', null, 'Quá hạn', 02003, 00001, 'TC00001', 02),
('O00005001', '2023-10-20 09:50:00', '2023-10-20 11:20:00', 'Hoàn tất', 01001, 00005, 'SN00011', 04),
('O00011001', '2023-06-19 08:20:00', null, 'Quá hạn', 1002, 00011, 'SN00009', 03);

INSERT INTO fine_invoice VALUES
(00008001, '2023-04-05', 5000, 'Làm hư sách', 'Đã gạch nợ', null, 'B00008001', null),
(00010001, '2023-08-28', 10000, 'Làm hư sách', 'Đã thanh toán', 'O00010001', null, null),
(00001001, '2023-09-20', 50000, 'Làm mất sách', 'Đã thanh toán', 'O00001001', null, null),
(00005001, '2023-10-20', 20000, 'Làm hư sách', 'Đã thanh toán', 'O00005001', null, null),
(00007001, '2023-05-18', 20000, 'Làm hư sách', 'Đã gạch nợ', null, 'B00007001', null),
(00011001, '2023-07-20', 195000, 'Làm mất sách', 'Đã thanh toán', 'O00011001', null, null),
(00011002, '2023-07-20', 175000, 'Làm mất sách', 'Đã gạch nợ', null, 'B00011001', null);