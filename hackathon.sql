CREATE DATABASE hackathon;
USE hackathon;

CREATE TABLE Users (
	user_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);
CREATE TABLE Categories (
	category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Books (
	book_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE,
    category_id VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL, -- giá đền bù nếu mất
    stock INT NOT NULL, -- số lượng tồn kho
    CONSTRAINT FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Borrows (
	borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(5) NOT NULL,
    book_id VARCHAR(5) NOT NULL,
    `status` VARCHAR(20) NOT NULL CHECK(`status` = 'Borrowing' OR `status` = 'Returned' OR `status` = 'Lost'),
    borrow_date DATE NOT NULL,
    CONSTRAINT FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Users VALUES
('U01', 'Nguyễn Văn An', 'a@m.com', '0912345678'),
('U02', 'Trần Thị Bích', 'b@m.com', '0923456789'),
('U03', 'Lê Hoàng Minh', 'mi@m.com', '0934567890'),
('U04', 'Phạm Thu Hà', 'h@m.com', '0945678901'),
('U05', 'Võ Quốc Huy', 'hu@gmail.com', '0956789012');
INSERT INTO Categories VALUES
('C01', 'IT'),
('C02', 'Literature'),
('C03', 'Science'),
('C04', 'History');
INSERT INTO Books VALUES
('B01', 'Clean Code', 'C01', 250000, 10),
('B02', 'Design Pattern', 'C01', 300000, 5),
('B03', 'Tat Den', 'C02', 50000, 20),
('B04', 'Universe', 'C03', 150000, 8),
('B05', 'Sapiens', 'C04', 200000, 15);
INSERT INTO Borrows VALUES
(NULL, 'U01', 'B01', 'Borrowing', '2025-10-01'),
(NULL, 'U02', 'B03', 'Returned', '2025-10-02'),
(NULL, 'U01', 'B02', 'Returned', '2025-10-03'),
(NULL, 'U04', 'B05', 'Lost', '2025-10-04'),
(NULL, 'U05', 'B01', 'Borrowing', '2025-10-05');

UPDATE Books
SET stock = stock + 10, price = price * 1.05
WHERE title = 'Sapiens';
UPDATE Users
SET phone = '0999999999'
WHERE user_id = 'U03';
DELETE FROM Borrows
WHERE `status` = 'Returned' AND DATE < '2025-10-03';

SELECT book_id, title, price
FROM Books
WHERE price BETWEEN 100000 AND 250000 AND stock > 0;
SELECT full_name, email
FROM Users
WHERE full_name LIKE 'Nguyen%';
SELECT borrow_id, user_id, borrow_date
FROM Borrows
ORDER BY borrow_date DESC;
SELECT *
FROM Books
ORDER BY price DESC
LIMIT 3;
SELECT title, stock
FROM Books
LIMIT 2 OFFSET 2;

SELECT borrow_id, full_name, title, borrow_date
FROM Borrows br, Users u, Books bk
WHERE u.user_id = br.user_id AND bk.book_id = br.book_id AND `status` = 'Borrowing';
SELECT category_name, title
FROM Categories c
LEFT JOIN Books bk
ON c.category_id = bk.category_id;
SELECT `status`, COUNT(borrow_id) AS 'Total_Borrows'
FROM Borrows
GROUP BY `status`; 
SELECT full_name, COUNT(borrow_id) AS 'Total_Books_Borrown'
FROM Users u
INNER JOIN Borrows br
ON u.user_id = br.user_id
GROUP BY u.full_name
HAVING COUNT(borrow_id) >= 2;
SELECT book_id, title, price
FROM Books
WHERE price < (
	SELECT AVG(price)
    FROM Books
);
