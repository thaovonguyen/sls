DROP DATABASE IF EXISTS sls_database;

CREATE DATABASE sls_database;

USE sls_database;

CREATE TABLE branch (
	bid int(2) auto_increment primary key,
    bname varchar(255) not null UNIQUE,
    address1 varchar(255) not null,
    address2 varchar(100) not null,
    address3 varchar(100) not null,
    address4 varchar(100) not null,
    pos_url varchar(100) not null -- thêm not null
);

CREATE TABLE staff (
	sid int(5) auto_increment primary key,	-- thêm auto_increment
    fname varchar(255) not null,			
    lname varchar(255) not null,
    sex enum('Nam','Nữ') not null,
    cic varchar(12) not null,		
    bdate date,						 
    phone varchar(10) not null,
    email varchar(255) not null,
    start_date date,						-- thêm not null
    end_date date,							
    bid int(3) not null,					
    FOREIGN KEY (bid) REFERENCES branch(bid)
);

CREATE TABLE manage (
	sid int(5) primary key,
    start_date date,
    end_date date,
    bid int(3),
    FOREIGN KEY (bid) REFERENCES branch(bid),
    FOREIGN KEY (sid) REFERENCES staff(sid)
);

CREATE TABLE document (
	did int(7) auto_increment primary key, 	-- thêm auto_increment
    dname varchar(255) not null,			
    abstract varchar(255),
    publisher varchar(100),
    cover_cost int(5) not null
);

CREATE TABLE printing_import (
	iid int(5) primary key,					
    idate date,
    bid int(2) not null,
    FOREIGN KEY (bid) REFERENCES branch(bid)
);

CREATE TABLE printing (
	did int(7),
    pid int(2),
	dstatus enum('Có sẵn','Đã mượn','Đặt trước','Chỉ đọc', 'Thất lạc') not null,
    dsource varchar (255),
    cost int (5),
    dcondition varchar(255),
    iid int (5) not null,
    primary key (did, pid),
    FOREIGN KEY (iid) REFERENCES printing_import(iid),
    FOREIGN KEY (did) REFERENCES document(did)
);

CREATE TABLE import_manage (
	iid int(5),
    sid int(5),
    primary key (iid, sid),
    FOREIGN KEY (iid) REFERENCES printing_import(iid),
    FOREIGN KEY (sid) REFERENCES staff(sid)
);

CREATE TABLE book (
	did int(7) primary key,
    btype enum ('Văn học', 'Kinh tế', 'Kỹ năng mềm', 'Nuôi dạy trẻ', 'Thiếu nhi', 'Tự truyện', 'Sách tham khảo', 'Ngôn ngữ', 'Khác'),
    FOREIGN KEY (did) REFERENCES document(did)
);

CREATE TABLE book_author (
	did int(7),
    author_name varchar(100),
    primary key (did, author_name),
    FOREIGN KEY (did) REFERENCES book(did)
);

CREATE TABLE magazine (
	did int(7) primary key,
    volumn int(5) not null,
    highlight varchar(255),
    FOREIGN KEY (did) REFERENCES document(did)
);

CREATE TABLE luser(
	uid int(5) primary key,
    fname varchar(255) not null,
    lname varchar(255) not null,
    paper_type enum('Căn cước công dân', 'Thẻ học sinh') not null,
    paper_num varchar(15) not null,
    paper_path varchar(255) not null,
    home_address varchar(255) not null,
    bdate date,
    workplace varchar(255),
    phone varchar(10) not null,
    email varchar(255),
    ustatus enum('Hạn chế', 'Bình thường', 'Khóa') not null,
    warning_time int(1),
    register_date date not null,
    CHECK (warning_time <= 3 && warning_time >= 0)
);

CREATE TABLE login_info (
	username varchar(255) primary key,
    password varchar(255) not null,
    uid int(5),
    sid int(5),
    FOREIGN KEY (sid) REFERENCES staff(sid),
    FOREIGN KEY (uid) REFERENCES luser(uid)
);

CREATE TABLE borrow_record (
	rid int(9) primary key,
    start_date datetime not null,	-- CURDATE()
    return_date datetime,
    extend_time int(1),				-- default 0
    bstatus enum('Hoàn tất', 'Đang tiến hành', 'Quá hạn', 'Trả sau hạn') not null,
    sid int(5) not null, -- Mã NV
    uid int(5) not null, -- Mã Ban Đọc
    did int(7) not null, -- Mã TL
    pid int(2) not null, -- Mã Bản in
    CHECK (extend_time <= 2 && extend_time >= 0),
    FOREIGN KEY (sid) REFERENCES staff(sid),
    FOREIGN KEY (uid) REFERENCES luser(uid),
    FOREIGN KEY (did, pid) REFERENCES printing(did, pid)
);

CREATE TABLE reserve_record (
	rid int(9) primary key,
    rdate datetime not null,
    rstatus enum('Thành công', 'Hoàn tất', 'Đã hủy', 'Đã hoàn tiền', 'Quá hạn') not null,
    borrow_rid int(9),
    uid int(5) not null,
    did int(7) not null,
    pid int(2) not null,
    FOREIGN KEY (uid) REFERENCES luser(uid),
    FOREIGN KEY (did, pid) REFERENCES printing(did, pid),
    FOREIGN KEY (borrow_rid) REFERENCES borrow_record(rid)
);

CREATE TABLE on_site_record (
	rid int(9) primary key,
    start_date datetime not null,
    return_date datetime,
    rstatus enum('Hoàn tất', 'Đang tiến hành', 'Quá hạn', 'Trả sau hạn') not null,
    sid int(5) not null,
    uid int(5) not null,
    did int(7) not null,
    pid int(2) not null,
    FOREIGN KEY (sid) REFERENCES staff(sid),
    FOREIGN KEY (uid) REFERENCES luser(uid),
    FOREIGN KEY (did, pid) REFERENCES printing(did, pid)
);

CREATE TABLE fine_invoice (
	fid int(8) primary key, -- Mã HĐ
    fdate date not null,	-- Ngày phạt
    fine int(6) not null,	-- Tiền phạt
    reason enum('Làm mất sách', 'Hủy đặt trước', 'Trễ hạn trả sách', 'Làm hư sách', 'Quá hạn và làm hỏng') not null,
    fstatus enum('Chưa thanh toán', 'Đã thanh toán', 'Đã gạch nợ') not null,
    on_site_rid int(9),		-- Mã phiếu Đọc Tại Chỗ
    borrow_rid int(9),		-- Mã phiếu Mượn Về Nhà
    reserve_rid int(9),		-- Mã phiếu Đặt trước
    FOREIGN KEY (on_site_rid) REFERENCES on_site_record(rid),
    FOREIGN KEY (borrow_rid) REFERENCES borrow_record(rid),
    FOREIGN KEY (reserve_rid) REFERENCES reserve_record(rid)
);

CREATE TABLE report (
	did int(7) primary key,
    nation enum(
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'The Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo, Democratic Republic of the',
    'Congo, Republic of the',
    'Costa Rica',
    'Côte d’Ivoire',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor (Timor-Leste)',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'The Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Korea, North',
    'Korea, South',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia, Federated States of',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Sudan, South',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe'
),
    field varchar(100),
    FOREIGN KEY (did) REFERENCES document(did)
);