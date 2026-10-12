SELECT VERSION();

CREATE DATABASE EcommerceSalesDB;

USE EcommerceSalesDB;

SELECT DATABASE();

-- Creating the table customers
 
CREATE TABLE Customers 
(
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    City VARCHAR(50),
    State VARCHAR(50),
    SignupDate DATE
);

DESCRIBE Customers;

-- Creating the table Products

CREATE TABLE Products 
(
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    Price DECIMAL(10,2)
);

DESCRIBE Products;

-- Creating the table Orders

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE,
    OrderStatus VARCHAR(20),
    PaymentMethod VARCHAR(30),
    
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

DESCRIBE Orders;

-- Creating the OrderDetails table

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0,
    
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),
        
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

DESCRIBE OrderDetails;

SHOW TABLES;

-- Get the details with respect to all the table which is created

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'EcommerceSalesDB'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  
WITH RECURSIVE CustomerNumbers AS (
    SELECT 1 AS CustomerID

    UNION ALL

    SELECT CustomerID + 1
    FROM CustomerNumbers
    WHERE CustomerID < 1000
)
SELECT *
FROM CustomerNumbers;

-- Creating to CityReference table to be later used in adding the value in Customers Table

CREATE TABLE CityReference (
    CityID INT AUTO_INCREMENT PRIMARY KEY,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL
);

INSERT INTO CityReference (City, State)
VALUES
('Mumbai', 'Maharashtra'),
('Pune', 'Maharashtra'),
('Nagpur', 'Maharashtra'),
('Bengaluru', 'Karnataka'),
('Mysuru', 'Karnataka'),
('Chennai', 'Tamil Nadu'),
('Coimbatore', 'Tamil Nadu'),
('Hyderabad', 'Telangana'),
('Delhi', 'Delhi'),
('Jaipur', 'Rajasthan'),
('Ahmedabad', 'Gujarat'),
('Surat', 'Gujarat'),
('Kolkata', 'West Bengal'),
('Lucknow', 'Uttar Pradesh'),
('Kanpur', 'Uttar Pradesh'),
('Noida', 'Uttar Pradesh'),
('Chandigarh', 'Chandigarh'),
('Bhopal', 'Madhya Pradesh'),
('Indore', 'Madhya Pradesh'),
('Kochi', 'Kerala');

SELECT *
FROM CityReference;

-- Creating to NameReference table to be later used in adding Firstname in Customers Table

CREATE TABLE NameReference (
    NameID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL
);

INSERT INTO NameReference (FirstName, Gender)
VALUES
('Aarav', 'Male'),
('Vivaan', 'Male'),
('Aditya', 'Male'),
('Arjun', 'Male'),
('Rohan', 'Male'),
('Rahul', 'Male'),
('Karan', 'Male'),
('Vikram', 'Male'),
('Nikhil', 'Male'),
('Ankit', 'Male'),
('Varun', 'Male'),
('Siddharth', 'Male'),
('Yash', 'Male'),
('Akash', 'Male'),
('Manish', 'Male'),
('Raj', 'Male'),
('Mohit', 'Male'),
('Abhishek', 'Male'),
('Harsh', 'Male'),
('Dev', 'Male'),

('Ananya', 'Female'),
('Priya', 'Female'),
('Aditi', 'Female'),
('Isha', 'Female'),
('Neha', 'Female'),
('Sneha', 'Female'),
('Pooja', 'Female'),
('Kavya', 'Female'),
('Riya', 'Female'),
('Simran', 'Female'),
('Nisha', 'Female'),
('Meera', 'Female'),
('Shreya', 'Female'),
('Diya', 'Female'),
('Tanya', 'Female'),
('Ritika', 'Female'),
('Anjali', 'Female'),
('Swati', 'Female'),
('Preeti', 'Female'),
('Sakshi', 'Female');

SELECT *
FROM NameReference;

-- Creating to SurnameReference table to be later used in adding Lastname in Customers Table

CREATE TABLE SurnameReference (
    SurnameID INT AUTO_INCREMENT PRIMARY KEY,
    Surname VARCHAR(50) NOT NULL
);

INSERT INTO SurnameReference (Surname)
VALUES
('Sharma'),
('Verma'),
('Singh'),
('Patel'),
('Mehta'),
('Gupta'),
('Shah'),
('Nair'),
('Iyer'),
('Reddy'),
('Rao'),
('Khan'),
('Malhotra'),
('Kapoor'),
('Joshi'),
('Mishra'),
('Chauhan'),
('Saxena'),
('Bansal'),
('Agarwal'),
('Das'),
('Banerjee'),
('Mukherjee'),
('Chatterjee'),
('Menon'),
('Pillai'),
('Kulkarni'),
('Deshmukh'),
('Jain'),
('Sethi');

SELECT *
FROM SurnameReference;

-- Using the Recursive CTE to have unique value for each CustomerID till 1000

WITH RECURSIVE CustomerNumbers AS (
    SELECT 1 AS CustomerID

    UNION ALL

    SELECT CustomerID + 1
    FROM CustomerNumbers
    WHERE CustomerID < 1000
)

-- Updating the table Customers using the above reference tables

SELECT
    CustomerID,

    CONCAT(
        n.FirstName,
        ' ',
        s.Surname
    ) AS CustomerName,

    n.Gender,

    c.City,

    c.State,

    DATE_ADD(
        '2022-01-01',
        INTERVAL FLOOR(RAND() * 1461) DAY
    ) AS SignupDate

FROM CustomerNumbers cn

JOIN NameReference n
    ON n.NameID = FLOOR(1 + RAND() * 40)

JOIN SurnameReference s
    ON s.SurnameID = FLOOR(1 + RAND() * 30)

JOIN CityReference c
    ON c.CityID = FLOOR(1 + RAND() * 20)

LIMIT 20;

WITH RECURSIVE CustomerNumbers AS (
    SELECT 1 AS CustomerID

    UNION ALL

    SELECT CustomerID + 1
    FROM CustomerNumbers
    WHERE CustomerID < 1000
)

-- Trying other methoda because the above method failed once, perfoming the same operation

SELECT
    cn.CustomerID,

    CONCAT(
        n.FirstName,
        ' ',
        s.Surname
    ) AS CustomerName,

    n.Gender,

    c.City,

    c.State,

    DATE_ADD(
        '2022-01-01',
        INTERVAL MOD(cn.CustomerID * 47, 1461) DAY
    ) AS SignupDate

FROM CustomerNumbers cn

JOIN NameReference n
    ON n.NameID = MOD(cn.CustomerID * 17 - 1, 40) + 1

JOIN SurnameReference s
    ON s.SurnameID = MOD(cn.CustomerID * 13 - 1, 30) + 1

JOIN CityReference c
    ON c.CityID = MOD(cn.CustomerID * 7 - 1, 20) + 1

LIMIT 20;

INSERT INTO Customers
    (CustomerName, Gender, City, State, SignupDate)

WITH RECURSIVE CustomerNumbers AS (
    SELECT 1 AS CustomerNumber

    UNION ALL

    SELECT CustomerNumber + 1
    FROM CustomerNumbers
    WHERE CustomerNumber < 1000
)

SELECT
    CONCAT(
        n.FirstName,
        ' ',
        s.Surname
    ) AS CustomerName,

    n.Gender,

    c.City,

    c.State,

    DATE_ADD(
        '2022-01-01',
        INTERVAL FLOOR(RAND() * 1461) DAY
    ) AS SignupDate

FROM CustomerNumbers cn

JOIN NameReference n
    ON n.NameID = MOD(cn.CustomerNumber * 17 - 1, 40) + 1

JOIN SurnameReference s
    ON s.SurnameID = MOD(cn.CustomerNumber * 13 - 1, 30) + 1

JOIN CityReference c
    ON c.CityID = MOD(cn.CustomerNumber * 7 - 1, 20) + 1;
    
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

SELECT
    MIN(CustomerID) AS FirstCustomerID,
    MAX(CustomerID) AS LastCustomerID
FROM Customers;

-- Checking whether the Total rows are 1000 or not

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CustomerID) AS UniqueCustomerIDs
FROM Customers;

SELECT *
FROM Customers
ORDER BY CustomerID;

-- Creating ProductReference table to be later used in adding values in Product table

CREATE TABLE ProductReference (
    ProductRefID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    SubCategory VARCHAR(50) NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL
);

INSERT INTO ProductReference
    (ProductName, Category, SubCategory, BasePrice)
VALUES

-- Electronics
('Wireless Bluetooth Earbuds', 'Electronics', 'Audio', 2499.00),
('Noise Cancelling Headphones', 'Electronics', 'Audio', 5999.00),
('Portable Bluetooth Speaker', 'Electronics', 'Audio', 2999.00),
('Smartphone 128GB', 'Electronics', 'Mobiles', 18999.00),
('Smartphone 256GB', 'Electronics', 'Mobiles', 24999.00),
('USB-C Fast Charger', 'Electronics', 'Mobile Accessories', 899.00),
('Power Bank 20000mAh', 'Electronics', 'Mobile Accessories', 1599.00),
('Wireless Charging Pad', 'Electronics', 'Mobile Accessories', 1299.00),
('Gaming Mouse', 'Electronics', 'Computer Accessories', 1599.00),
('Mechanical Gaming Keyboard', 'Electronics', 'Computer Accessories', 3999.00),
('Laptop Backpack', 'Electronics', 'Computer Accessories', 1899.00),
('1080p Web Camera', 'Electronics', 'Computer Accessories', 2499.00),
('Smart LED Television 43 Inch', 'Electronics', 'Television', 32999.00),
('Smart Watch', 'Electronics', 'Wearables', 4999.00),
('Fitness Smart Band', 'Electronics', 'Wearables', 2499.00),

-- Fashion
('Cotton Casual Shirt', 'Fashion', 'Mens Clothing', 1299.00),
('Slim Fit Formal Shirt', 'Fashion', 'Mens Clothing', 1599.00),
('Mens Denim Jeans', 'Fashion', 'Mens Clothing', 1999.00),
('Mens Polo T-Shirt', 'Fashion', 'Mens Clothing', 999.00),
('Mens Casual Trousers', 'Fashion', 'Mens Clothing', 1499.00),
('Womens Cotton Kurti', 'Fashion', 'Womens Clothing', 1199.00),
('Womens Printed Dress', 'Fashion', 'Womens Clothing', 1799.00),
('Womens Denim Jeans', 'Fashion', 'Womens Clothing', 1999.00),
('Womens Casual Top', 'Fashion', 'Womens Clothing', 899.00),
('Womens Ethnic Saree', 'Fashion', 'Womens Clothing', 2499.00),
('Mens Running Shoes', 'Fashion', 'Footwear', 2499.00),
('Womens Running Shoes', 'Fashion', 'Footwear', 2799.00),
('Casual Sneakers', 'Fashion', 'Footwear', 2299.00),
('Leather Wallet', 'Fashion', 'Accessories', 899.00),
('Leather Handbag', 'Fashion', 'Accessories', 2499.00),

-- Beauty
('Face Moisturizer', 'Beauty', 'Skincare', 699.00),
('Vitamin C Face Serum', 'Beauty', 'Skincare', 899.00),
('Sunscreen SPF 50', 'Beauty', 'Skincare', 599.00),
('Face Cleanser', 'Beauty', 'Skincare', 449.00),
('Lip Balm', 'Beauty', 'Lip Care', 249.00),
('Matte Lipstick', 'Beauty', 'Makeup', 699.00),
('Foundation', 'Beauty', 'Makeup', 899.00),
('Mascara', 'Beauty', 'Makeup', 599.00),
('Perfume 100ml', 'Beauty', 'Fragrance', 1499.00),
('Body Lotion', 'Beauty', 'Body Care', 499.00),

-- Home & Kitchen
('Stainless Steel Cookware Set', 'Home & Kitchen', 'Cookware', 3499.00),
('Non Stick Frying Pan', 'Home & Kitchen', 'Cookware', 1299.00),
('Electric Kettle', 'Home & Kitchen', 'Appliances', 1599.00),
('Coffee Maker', 'Home & Kitchen', 'Appliances', 2999.00),
('Mixer Grinder', 'Home & Kitchen', 'Appliances', 3499.00),
('Air Fryer', 'Home & Kitchen', 'Appliances', 4999.00),
('Cotton Bedsheet Set', 'Home & Kitchen', 'Home Furnishing', 1499.00),
('Memory Foam Pillow', 'Home & Kitchen', 'Home Furnishing', 999.00),

-- Sports
('Yoga Mat', 'Sports', 'Fitness', 999.00),
('Adjustable Dumbbells', 'Sports', 'Fitness', 3499.00),
('Resistance Bands Set', 'Sports', 'Fitness', 699.00),
('Cricket Bat', 'Sports', 'Cricket', 2499.00),
('Football', 'Sports', 'Football', 899.00),
('Badminton Racket', 'Sports', 'Badminton', 1599.00),

-- Books
('The Psychology of Money', 'Books', 'Finance', 499.00),
('Atomic Habits', 'Books', 'Self Help', 599.00);

SELECT COUNT(*) AS ProductReferenceCount
FROM ProductReference;

-- Viewing all the data of the ProductReference table

SELECT *
FROM ProductReference
ORDER BY ProductRefID;

-- Finding the number of Products by Category

SELECT
    Category,
    COUNT(*) AS ProductCount
FROM ProductReference
GROUP BY Category
ORDER BY Category;

-- Finding the total number of Products

SELECT COUNT(*) AS CurrentProducts
FROM Products;

-- Now inserting the value into Products table using the Reference table above

INSERT INTO Products
    (ProductName, Category, SubCategory, Price)

SELECT
    CONCAT(
        pr.ProductName,
        CASE
            WHEN seq.ProductNumber % 3 = 1 THEN ' - Standard'
            WHEN seq.ProductNumber % 3 = 2 THEN ' - Premium'
            ELSE ' - Pro'
        END
    ) AS ProductName,

    pr.Category,

    pr.SubCategory,

    ROUND(
        pr.BasePrice *
        CASE
            WHEN seq.ProductNumber % 3 = 1 THEN 1.00
            WHEN seq.ProductNumber % 3 = 2 THEN 1.15
            ELSE 1.30
        END,
        2
    ) AS Price

FROM (
    SELECT 1 AS ProductNumber
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
    UNION ALL
    SELECT 4
    UNION ALL
    SELECT 5
    UNION ALL
    SELECT 6
    UNION ALL
    SELECT 7
    UNION ALL
    SELECT 8
    UNION ALL
    SELECT 9
    UNION ALL
    SELECT 10
    UNION ALL
    SELECT 11
    UNION ALL
    SELECT 12
    UNION ALL
    SELECT 13
    UNION ALL
    SELECT 14
    UNION ALL
    SELECT 15
    UNION ALL
    SELECT 16
    UNION ALL
    SELECT 17
    UNION ALL
    SELECT 18
    UNION ALL
    SELECT 19
    UNION ALL
    SELECT 20
    UNION ALL
    SELECT 21
    UNION ALL
    SELECT 22
    UNION ALL
    SELECT 23
    UNION ALL
    SELECT 24
    UNION ALL
    SELECT 25
    UNION ALL
    SELECT 26
    UNION ALL
    SELECT 27
    UNION ALL
    SELECT 28
    UNION ALL
    SELECT 29
    UNION ALL
    SELECT 30
    UNION ALL
    SELECT 31
    UNION ALL
    SELECT 32
    UNION ALL
    SELECT 33
    UNION ALL
    SELECT 34
    UNION ALL
    SELECT 35
    UNION ALL
    SELECT 36
    UNION ALL
    SELECT 37
    UNION ALL
    SELECT 38
    UNION ALL
    SELECT 39
    UNION ALL
    SELECT 40
    UNION ALL
    SELECT 41
    UNION ALL
    SELECT 42
    UNION ALL
    SELECT 43
    UNION ALL
    SELECT 44
    UNION ALL
    SELECT 45
    UNION ALL
    SELECT 46
    UNION ALL
    SELECT 47
    UNION ALL
    SELECT 48
    UNION ALL
    SELECT 49
    UNION ALL
    SELECT 50
    UNION ALL
    SELECT 51
    UNION ALL
    SELECT 52
    UNION ALL
    SELECT 53
    UNION ALL
    SELECT 54
    UNION ALL
    SELECT 55
    UNION ALL
    SELECT 56
    UNION ALL
    SELECT 57
    UNION ALL
    SELECT 58
    UNION ALL
    SELECT 59
    UNION ALL
    SELECT 60
    UNION ALL
    SELECT 61
    UNION ALL
    SELECT 62
    UNION ALL
    SELECT 63
    UNION ALL
    SELECT 64
    UNION ALL
    SELECT 65
    UNION ALL
    SELECT 66
    UNION ALL
    SELECT 67
    UNION ALL
    SELECT 68
    UNION ALL
    SELECT 69
    UNION ALL
    SELECT 70
    UNION ALL
    SELECT 71
    UNION ALL
    SELECT 72
    UNION ALL
    SELECT 73
    UNION ALL
    SELECT 74
    UNION ALL
    SELECT 75
    UNION ALL
    SELECT 76
    UNION ALL
    SELECT 77
    UNION ALL
    SELECT 78
    UNION ALL
    SELECT 79
    UNION ALL
    SELECT 80
    UNION ALL
    SELECT 81
    UNION ALL
    SELECT 82
    UNION ALL
    SELECT 83
    UNION ALL
    SELECT 84
    UNION ALL
    SELECT 85
    UNION ALL
    SELECT 86
    UNION ALL
    SELECT 87
    UNION ALL
    SELECT 88
    UNION ALL
    SELECT 89
    UNION ALL
    SELECT 90
    UNION ALL
    SELECT 91
    UNION ALL
    SELECT 92
    UNION ALL
    SELECT 93
    UNION ALL
    SELECT 94
    UNION ALL
    SELECT 95
    UNION ALL
    SELECT 96
    UNION ALL
    SELECT 97
    UNION ALL
    SELECT 98
    UNION ALL
    SELECT 99
    UNION ALL
    SELECT 100
    UNION ALL
    SELECT 101
    UNION ALL
    SELECT 102
    UNION ALL
    SELECT 103
    UNION ALL
    SELECT 104
    UNION ALL
    SELECT 105
    UNION ALL
    SELECT 106
    UNION ALL
    SELECT 107
    UNION ALL
    SELECT 108
    UNION ALL
    SELECT 109
    UNION ALL
    SELECT 110
    UNION ALL
    SELECT 111
    UNION ALL
    SELECT 112
    UNION ALL
    SELECT 113
    UNION ALL
    SELECT 114
    UNION ALL
    SELECT 115
    UNION ALL
    SELECT 116
    UNION ALL
    SELECT 117
    UNION ALL
    SELECT 118
    UNION ALL
    SELECT 119
    UNION ALL
    SELECT 120
    UNION ALL
    SELECT 121
    UNION ALL
    SELECT 122
    UNION ALL
    SELECT 123
    UNION ALL
    SELECT 124
    UNION ALL
    SELECT 125
    UNION ALL
    SELECT 126
    UNION ALL
    SELECT 127
    UNION ALL
    SELECT 128
    UNION ALL
    SELECT 129
    UNION ALL
    SELECT 130
    UNION ALL
    SELECT 131
    UNION ALL
    SELECT 132
    UNION ALL
    SELECT 133
    UNION ALL
    SELECT 134
    UNION ALL
    SELECT 135
    UNION ALL
    SELECT 136
    UNION ALL
    SELECT 137
    UNION ALL
    SELECT 138
    UNION ALL
    SELECT 139
    UNION ALL
    SELECT 140
    UNION ALL
    SELECT 141
    UNION ALL
    SELECT 142
    UNION ALL
    SELECT 143
    UNION ALL
    SELECT 144
    UNION ALL
    SELECT 145
    UNION ALL
    SELECT 146
    UNION ALL
    SELECT 147
    UNION ALL
    SELECT 148
    UNION ALL
    SELECT 149
    UNION ALL
    SELECT 150
) AS seq

JOIN ProductReference pr
    ON pr.ProductRefID = MOD(seq.ProductNumber - 1, 56) + 1;

-- Again ensuring that the number of values in Products is 150
    
SELECT COUNT(*) AS TotalProducts
FROM Products;

SELECT *
FROM Products
ORDER BY ProductID
LIMIT 100;

-- Again ensuring the number of Products by Category

SELECT
    Category,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Category
ORDER BY ProductCount DESC;

-- Orders table value updation

SELECT COUNT(*) AS GeneratedOrders
FROM (
    SELECT
        c.CustomerID,
        n.Number
    FROM Customers c
    CROSS JOIN (
        SELECT 1 AS Number
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
    ) n
) AS OrderGenerator;

INSERT INTO Orders
    (CustomerID, OrderDate, OrderStatus, PaymentMethod)
SELECT
    c.CustomerID,

    DATE_ADD(
        c.SignupDate,
        INTERVAL FLOOR(
            RAND() * (DATEDIFF('2026-09-30', c.SignupDate) + 1)
        ) DAY
    ) AS OrderDate,

    CASE
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 100) < 75
            THEN 'Delivered'
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 100) < 85
            THEN 'Shipped'
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 100) < 93
            THEN 'Processing'
        ELSE 'Cancelled'
    END AS OrderStatus,

    CASE
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 5) = 1
            THEN 'UPI'
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 5) = 2
            THEN 'Credit Card'
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 5) = 3
            THEN 'Debit Card'
        WHEN MOD((c.CustomerID - 1) * 5 + n.Number, 5) = 4
            THEN 'Net Banking'
        ELSE 'Cash on Delivery'
    END AS PaymentMethod

FROM Customers c

CROSS JOIN (
    SELECT 1 AS Number
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
) n;

SELECT COUNT(*) AS TotalOrders
FROM Orders;

-- The number of Products by Delivery Status

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;

SELECT
    o.OrderID,
    d.LineNumber,
    MOD(o.OrderID * 17 + d.LineNumber * 23 - 1, 150) + 1 AS ProductID,
    MOD(o.OrderID + d.LineNumber, 5) + 1 AS Quantity
FROM Orders o
CROSS JOIN (
    SELECT 1 AS LineNumber
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
) d
WHERE d.LineNumber <=
    CASE
        WHEN MOD(o.OrderID, 10) < 3 THEN 3
        ELSE 2
    END
LIMIT 20;

SELECT
    o.OrderID,
    d.LineNumber,

    MOD(o.OrderID * 17 + d.LineNumber * 23 - 1, 150) + 1 AS ProductID,

    MOD(o.OrderID + d.LineNumber, 5) + 1 AS Quantity,

    ROUND(
        p.Price *
        CASE
            WHEN MOD(o.OrderID, 10) = 0 THEN 0.95
            WHEN MOD(o.OrderID, 10) = 1 THEN 0.98
            ELSE 1.00
        END,
        2
    ) AS UnitPrice,

    CASE
        WHEN MOD(o.OrderID, 10) = 0 THEN 20.00
        WHEN MOD(o.OrderID, 10) = 1 THEN 10.00
        WHEN MOD(o.OrderID, 10) IN (2, 3) THEN 5.00
        ELSE 0.00
    END AS Discount

FROM Orders o

CROSS JOIN (
    SELECT 1 AS LineNumber
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
) d

JOIN Products p
    ON p.ProductID =
       MOD(o.OrderID * 17 + d.LineNumber * 23 - 1, 150) + 1

WHERE d.LineNumber <=
    CASE
        WHEN MOD(o.OrderID, 10) < 3 THEN 3
        ELSE 2
    END

LIMIT 20;

-- Inserting into OrderDetails Table

INSERT INTO OrderDetails
    (OrderID, ProductID, Quantity, UnitPrice, Discount)

SELECT
    o.OrderID,

    MOD(o.OrderID * 17 + d.LineNumber * 23 - 1, 150) + 1 AS ProductID,

    MOD(o.OrderID + d.LineNumber, 5) + 1 AS Quantity,

    ROUND(
        p.Price *
        CASE
            WHEN MOD(o.OrderID, 10) = 0 THEN 0.95
            WHEN MOD(o.OrderID, 10) = 1 THEN 0.98
            ELSE 1.00
        END,
        2
    ) AS UnitPrice,

    CASE
        WHEN MOD(o.OrderID, 10) = 0 THEN 20.00
        WHEN MOD(o.OrderID, 10) = 1 THEN 10.00
        WHEN MOD(o.OrderID, 10) IN (2, 3) THEN 5.00
        ELSE 0.00
    END AS Discount

FROM Orders o

CROSS JOIN (
    SELECT 1 AS LineNumber
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3
) d

JOIN Products p
    ON p.ProductID =
       MOD(o.OrderID * 17 + d.LineNumber * 23 - 1, 150) + 1

WHERE d.LineNumber <=
    CASE
        WHEN MOD(o.OrderID, 10) < 3 THEN 3
        ELSE 2
    END;

-- Ensuring the count of OrderDetails
    
SELECT COUNT(*) AS TotalOrderDetails
FROM OrderDetails;

-- Ensuring that the min and max of Quantity and Discount is as expected

SELECT
    MIN(Quantity) AS MinQuantity,
    MAX(Quantity) AS MaxQuantity,
    MIN(Discount) AS MinDiscount,
    MAX(Discount) AS MaxDiscount
FROM OrderDetails;

SELECT
    TABLE_NAME,
    TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'EcommerceSalesDB'
  AND TABLE_NAME IN (
      'Customers',
      'Products',
      'Orders',
      'OrderDetails'
  );
  
  -- NOW WE WILL CREATE RAW/STAGING LAYER
  
CREATE TABLE Customers_Raw AS
	SELECT *
	FROM Customers;

SELECT COUNT(*) AS RawCustomerRows
FROM Customers_Raw;

DESCRIBE Customers_Raw;

CREATE TABLE Products_Raw AS
SELECT *
FROM Products;

SELECT COUNT(*) AS RawProductRows
FROM Products_Raw;

CREATE TABLE Orders_Raw AS
SELECT *
FROM Orders;

SELECT COUNT(*) AS RawOrderRows
FROM Orders_Raw;

CREATE TABLE OrderDetails_Raw AS
SELECT *
FROM OrderDetails;

SELECT COUNT(*) AS RawOrderDetailRows
FROM OrderDetails_Raw;

-- NOW WE WILL INTRODUCE DATA INCONSISTENCY

SET SQL_SAFE_UPDATES = 0;

UPDATE Customers_Raw
SET City = ' Mumbai '
WHERE CustomerID BETWEEN 101 AND 110;

UPDATE Customers_Raw
SET City = 'mumbai'
WHERE CustomerID BETWEEN 201 AND 210;

UPDATE Customers_Raw
SET City = 'MUMBAI'
WHERE CustomerID BETWEEN 301 AND 310;

SELECT
    CustomerID,
    CustomerName,
    City,
    State
FROM Customers_Raw
WHERE CustomerID BETWEEN 101 AND 110
   OR CustomerID BETWEEN 201 AND 210
   OR CustomerID BETWEEN 301 AND 310;
   
SELECT DISTINCT City
FROM Customers_Raw;
   
UPDATE Customers_Raw
SET Gender = NULL
WHERE CustomerID BETWEEN 401 AND 410;

UPDATE Customers_Raw
SET City = NULL
WHERE CustomerID BETWEEN 501 AND 510;

UPDATE Customers_Raw
SET SignupDate = NULL
WHERE CustomerID BETWEEN 601 AND 605;

SELECT
    COUNT(*) AS TotalRows,
    SUM(Gender IS NULL) AS MissingGender,
    SUM(City IS NULL) AS MissingCity,
    SUM(SignupDate IS NULL) AS MissingSignupDate
FROM Customers_Raw;

INSERT INTO Customers_Raw
    (CustomerID, CustomerName, Gender, City, State, SignupDate)
SELECT
    CustomerID + 1000,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw
WHERE CustomerID BETWEEN 701 AND 705;

SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw
WHERE CustomerID BETWEEN 701 AND 705
   OR CustomerID BETWEEN 1701 AND 1705
ORDER BY CustomerID;

-- Detect duplicate customer information

SELECT
    CustomerName,
    Gender,
    City,
    State,
    SignupDate,
    COUNT(*) AS DuplicateCount
FROM Customers_Raw
GROUP BY
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
HAVING COUNT(*) > 1;

-- Identifying the records to remove

SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw
WHERE CustomerID BETWEEN 1701 AND 1705
ORDER BY CustomerID;

-- Remove the duplicate records

DELETE FROM Customers_Raw
WHERE CustomerID BETWEEN 1701 AND 1705;

SELECT COUNT(*) AS RawCustomerRows
FROM Customers_Raw;

-- counting for duplicate records

SELECT COUNT(*) AS DuplicateGroups
FROM (
    SELECT
        CustomerName,
        Gender,
        City,
        State,
        SignupDate
    FROM Customers_Raw
    GROUP BY
        CustomerName,
        Gender,
        City,
        State,
        SignupDate
    HAVING COUNT(*) > 1
) AS Duplicates;

-- finding out if they are exact duplicate or not

SELECT
    CustomerName,
    Gender,
    City,
    State,
    SignupDate,
    COUNT(*) AS DuplicateCount
FROM Customers_Raw
GROUP BY
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
HAVING COUNT(*) > 1;

SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw
WHERE CustomerName IN (
    SELECT CustomerName
    FROM Customers_Raw
    GROUP BY
        CustomerName,
        Gender,
        City,
        State,
        SignupDate
    HAVING COUNT(*) > 1
)
ORDER BY CustomerName, CustomerID;

-- To verify if Priya Saxena is the only genuine excat Duplicate

SELECT
    CustomerName,
    Gender,
    City,
    State,
    SignupDate,
    COUNT(*) AS DuplicateCount
FROM Customers_Raw
GROUP BY
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
HAVING COUNT(*) > 1;

-- Inspecting all 6 records found as output of the previous code as duplicates of 3 records each

SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw
WHERE CustomerName IN (
    'Nikhil Sharma',
    'Rahul Chatterjee',
    'Priya Saxena'
)
ORDER BY CustomerName, SignupDate, CustomerID;

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers_Raw c
LEFT JOIN Orders o
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerName IN (
    'Nikhil Sharma',
    'Rahul Chatterjee',
    'Priya Saxena'
)
GROUP BY
    c.CustomerID,
    c.CustomerName
ORDER BY
    c.CustomerName,
    c.CustomerID;
    
-- Nikhil Sharma appears 8 times, but most have different signup dates
-- Those could legitimately represent different customers with the same name.
-- The same applies to Priya and Rahul.

-- Identify three duplicate pairs

SELECT
    c1.CustomerID AS DuplicateCustomerID,
    c2.CustomerID AS KeepCustomerID,
    c1.CustomerName,
    c1.SignupDate
FROM Customers_Raw c1
JOIN Customers_Raw c2
    ON c1.CustomerName = c2.CustomerName
    AND c1.Gender = c2.Gender
    AND c1.City = c2.City
    AND c1.State = c2.State
    AND c1.SignupDate = c2.SignupDate
    AND c1.CustomerID > c2.CustomerID;

-- Reassigning the duplicate customer orders

UPDATE Orders
SET CustomerID = CASE
    WHEN CustomerID = 457 THEN 97
    WHEN CustomerID = 966 THEN 846
    WHEN CustomerID = 918 THEN 198
END
WHERE CustomerID IN (457, 966, 918);

-- Verify the reassignment

SELECT
    CustomerID,
    COUNT(OrderID) AS OrderCount
FROM Orders
WHERE CustomerID IN (97, 457, 846, 966, 198, 918)
GROUP BY CustomerID
ORDER BY CustomerID;

DELETE FROM Customers_Raw
WHERE CustomerID IN (457, 966, 918);

SELECT COUNT(*) AS RawCustomerRows
FROM Customers_Raw;

-- Creating inconsistent Status Values

UPDATE Orders_Raw
SET OrderStatus = 'delivered'
WHERE OrderID BETWEEN 101 AND 110;

UPDATE Orders_Raw
SET OrderStatus = 'DELIVERED'
WHERE OrderID BETWEEN 111 AND 120;

UPDATE Orders_Raw
SET OrderStatus = 'Complete'
WHERE OrderID BETWEEN 201 AND 210;

UPDATE Orders_Raw
SET OrderStatus = 'completed'
WHERE OrderID BETWEEN 211 AND 220;

-- Auditing the Problem

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders_Raw
GROUP BY OrderStatus
ORDER BY OrderStatus;

-- Standardizing the Order Status

UPDATE Orders_Raw
SET OrderStatus =
    CASE
        WHEN LOWER(OrderStatus) IN ('delivered', 'complete', 'completed')
            THEN 'Delivered'

        WHEN LOWER(OrderStatus) = 'shipped'
            THEN 'Shipped'

        WHEN LOWER(OrderStatus) = 'processing'
            THEN 'Processing'

        WHEN LOWER(OrderStatus) = 'cancelled'
            THEN 'Cancelled'

        ELSE OrderStatus
    END;
    
-- Verifying the Cleaning

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders_Raw
GROUP BY OrderStatus
ORDER BY OrderStatus;

-- Checking for unexpected statuses

SELECT DISTINCT OrderStatus
FROM Orders_Raw
WHERE OrderStatus NOT IN (
    'Delivered',
    'Shipped',
    'Processing',
    'Cancelled'
);

-- Invalid Order Dates
-- Creating a few invalid dates in Orders_Raw

UPDATE Orders_Raw o
JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
SET o.OrderDate = DATE_SUB(c.SignupDate, INTERVAL 30 DAY)
WHERE o.OrderID BETWEEN 301 AND 310;

-- Auditing the Problem

SELECT
    o.OrderID,
    o.CustomerID,
    c.SignupDate,
    o.OrderDate
FROM Orders_Raw o
JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignupDate
ORDER BY o.OrderID;

-- Correcting the invalid dates

UPDATE Orders_Raw o
JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
SET o.OrderDate = c.SignupDate
WHERE o.OrderDate < c.SignupDate;

-- Validating

SELECT
    COUNT(*) AS InvalidOrderDates
FROM Orders_Raw o
JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignupDate;

SELECT
    MIN(OrderDate) AS EarliestOrderDate,
    MAX(OrderDate) AS LatestOrderDate
FROM Orders_Raw;

-- OrderDetail Quality
-- Introducing invalid quantities

UPDATE OrderDetails_Raw
SET Quantity = 0
WHERE OrderDetailID BETWEEN 101 AND 105;

UPDATE OrderDetails_Raw
SET Quantity = -2
WHERE OrderDetailID BETWEEN 106 AND 110;

-- Auditing

SELECT
    COUNT(*) AS InvalidQuantityRows
FROM OrderDetails_Raw
WHERE Quantity <= 0;

-- Cleaning the invalid quantities

UPDATE OrderDetails_Raw
SET Quantity = 1
WHERE Quantity <= 0;

-- Validating

SELECT
    COUNT(*) AS InvalidQuantityRows
FROM OrderDetails_Raw
WHERE Quantity <= 0;

SELECT
    MIN(Quantity) AS MinimumQuantity,
    MAX(Quantity) AS MaximumQuantity
FROM OrderDetails_Raw;

-- Invalid Discount
-- Creating invalid discounts

UPDATE OrderDetails_Raw
SET Discount = -5
WHERE OrderDetailID BETWEEN 201 AND 205;

UPDATE OrderDetails_Raw
SET Discount = 110
WHERE OrderDetailID BETWEEN 206 AND 210;

-- Auditing

SELECT
    COUNT(*) AS InvalidDiscountRows
FROM OrderDetails_Raw
WHERE Discount < 0
   OR Discount > 100;
   
-- Correct invalid discounts

UPDATE OrderDetails_Raw
SET Discount = 0
WHERE Discount < 0
   OR Discount > 100;
   
-- Validating

SELECT
    COUNT(*) AS InvalidDiscountRows
FROM OrderDetails_Raw
WHERE Discount < 0
   OR Discount > 100;
   
-- checking final range

SELECT
    MIN(Discount) AS MinimumDiscount,
    MAX(Discount) AS MaximumDiscount
FROM OrderDetails_Raw;

-- Inavlid Foreign Key Reference
-- Creating invalid ProductIDs

UPDATE OrderDetails_Raw
SET ProductID = 999
WHERE OrderDetailID BETWEEN 301 AND 305;

-- Auditing using LEFT Join

SELECT
    od.OrderDetailID,
    od.ProductID
FROM OrderDetails_Raw od
LEFT JOIN Products p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- Repair the invalid ProductIDs

UPDATE OrderDetails_Raw
SET ProductID = 1
WHERE ProductID = 999;

-- Validating referential integrity again

SELECT
    COUNT(*) AS InvalidProductReferences
FROM OrderDetails_Raw od
LEFT JOIN Products p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- Checking the OrderID relationship

SELECT
    COUNT(*) AS InvalidOrderReferences
FROM OrderDetails_Raw od
LEFT JOIN Orders o
    ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

-- FINAL VALIDATION ONE LAST TIME

-- Validation 1: Row Counts

SELECT 'Customers_Raw' AS TableName, COUNT(*) AS RowCount
FROM Customers_Raw

UNION ALL

SELECT 'Orders_Raw', COUNT(*)
FROM Orders_Raw

UNION ALL

SELECT 'OrderDetails_Raw', COUNT(*)
FROM OrderDetails_Raw;

-- Validation 2: Missing Values

SELECT
    COUNT(*) AS TotalRows,
    SUM(CustomerName IS NULL) AS MissingCustomerName,
    SUM(Gender IS NULL) AS MissingGender,
    SUM(City IS NULL) AS MissingCity,
    SUM(State IS NULL) AS MissingState,
    SUM(SignupDate IS NULL) AS MissingSignupDate
FROM Customers_Raw;

-- fixing the missing Gender

UPDATE Customers_Raw c
JOIN NameReference n
    ON SUBSTRING_INDEX(c.CustomerName, ' ', 1) = n.FirstName
SET c.Gender = n.Gender
WHERE c.Gender IS NULL;

-- Validating

SELECT COUNT(*) AS MissingGender
FROM Customers_Raw
WHERE Gender IS NULL;

-- Fixing the missing City

SELECT
    State,
    COUNT(*) AS MissingCityCount
FROM Customers_Raw
WHERE City IS NULL
GROUP BY State
ORDER BY State;

-- Fill missing City from the reference table

UPDATE Customers_Raw c
JOIN (
    SELECT
        State,
        MIN(City) AS ReplacementCity
    FROM CityReference
    GROUP BY State
) r
    ON c.State = r.State
SET c.City = r.ReplacementCity
WHERE c.City IS NULL;

-- Validating

SELECT COUNT(*) AS MissingCity
FROM Customers_Raw
WHERE City IS NULL;

-- Finding Earliest SignupDate

SELECT MIN(SignupDate) AS EarliestSignupDate
FROM Customers_Raw
WHERE SignupDate IS NOT NULL;

-- Filling missing signupdate

UPDATE Customers_Raw c
JOIN (
    SELECT MIN(SignupDate) AS EarliestSignupDate
    FROM (
        SELECT SignupDate
        FROM Customers_Raw
        WHERE SignupDate IS NOT NULL
    ) AS ValidDates
) d
SET c.SignupDate = d.EarliestSignupDate
WHERE c.SignupDate IS NULL;

-- Validating

SELECT COUNT(*) AS MissingSignupDate
FROM Customers_Raw
WHERE SignupDate IS NULL;

-- Validation 3 — Confirm no missing values remain

SELECT
    COUNT(*) AS TotalRows,
    SUM(CustomerName IS NULL) AS MissingCustomerName,
    SUM(Gender IS NULL) AS MissingGender,
    SUM(City IS NULL) AS MissingCity,
    SUM(State IS NULL) AS MissingState,
    SUM(SignupDate IS NULL) AS MissingSignupDate
FROM Customers_Raw;

-- Validation 4: Duplicate Customers

SELECT
    CustomerName,
    Gender,
    City,
    State,
    SignupDate,
    COUNT(*) AS DuplicateCount
FROM Customers_Raw
GROUP BY
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
HAVING COUNT(*) > 1;

-- Validation 5: Order Status

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders_Raw
GROUP BY OrderStatus
ORDER BY OrderStatus;

SELECT COUNT(*) AS InvalidStatusRows
FROM Orders_Raw
WHERE OrderStatus NOT IN (
    'Delivered',
    'Shipped',
    'Processing',
    'Cancelled'
);

-- Validation 6: Order Date Integrity

SELECT
    COUNT(*) AS InvalidOrderDateRows
FROM Orders_Raw o
JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignupDate;

SELECT
    COUNT(*) AS MissingOrderDates
FROM Orders_Raw
WHERE OrderDate IS NULL;

-- Validation 7: Quantity & Discount
-- Quantity

SELECT
    COUNT(*) AS InvalidQuantityRows
FROM OrderDetails_Raw
WHERE Quantity <= 0
   OR Quantity IS NULL;
   
-- Discount

SELECT
    COUNT(*) AS InvalidDiscountRows
FROM OrderDetails_Raw
WHERE Discount < 0
   OR Discount > 100
   OR Discount IS NULL;
   
-- Validation 8: Foreign-Key Relationships
-- 8A: Every Order belongs to a valid Customer

SELECT
    COUNT(*) AS InvalidCustomerReferences
FROM Orders_Raw o
LEFT JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- Since there are 15 null values for InvalidCustomerRefernce, So let's tackle it

SELECT
    o.CustomerID,
    COUNT(*) AS OrderCount
FROM Orders_Raw o
LEFT JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
GROUP BY o.CustomerID
ORDER BY o.CustomerID;

UPDATE Orders_Raw
SET CustomerID = CASE
    WHEN CustomerID = 457 THEN 97
    WHEN CustomerID = 918 THEN 198
    WHEN CustomerID = 966 THEN 846
END
WHERE CustomerID IN (457, 918, 966);

SELECT
    COUNT(*) AS InvalidCustomerReferences
FROM Orders_Raw o
LEFT JOIN Customers_Raw c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- 8B: OrderDetails --> Orders

SELECT
    COUNT(*) AS InvalidOrderReferences
FROM OrderDetails_Raw od
LEFT JOIN Orders_Raw o
    ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

-- 8C: OrderDetails --> Products

SELECT
    COUNT(*) AS InvalidProductReferences
FROM OrderDetails_Raw od
LEFT JOIN Products p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- BUILD FINAL CLEAN DATASET

-- Checking the current row counts

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount
FROM Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders

UNION ALL

SELECT 'OrderDetails', COUNT(*)
FROM OrderDetails;

-- Checking the current table definition

DESCRIBE Customers;
DESCRIBE Orders;
DESCRIBE OrderDetails;
DESCRIBE Products;

-- Building Customers_Clean from Customers_Raw

CREATE TABLE Customers_Clean (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    City VARCHAR(50),
    State VARCHAR(50),
    SignupDate DATE
);

DESCRIBE Customers_Clean;

INSERT INTO Customers_Clean
    (CustomerID, CustomerName, Gender, City, State, SignupDate)
SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    SignupDate
FROM Customers_Raw;

SELECT COUNT(*) AS CleanCustomerRows
FROM Customers_Clean;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CustomerID) AS UniqueCustomerIDs,
    SUM(CustomerName IS NULL) AS MissingNames,
    SUM(Gender IS NULL) AS MissingGender,
    SUM(City IS NULL) AS MissingCity,
    SUM(State IS NULL) AS MissingState,
    SUM(SignupDate IS NULL) AS MissingSignupDate
FROM Customers_Clean;

-- Building Orders_Clean from Orders_Raw

CREATE TABLE Orders_Clean (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE,
    OrderStatus VARCHAR(20),
    PaymentMethod VARCHAR(30),

    CONSTRAINT FK_OrdersClean_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers_Clean(CustomerID)
);

DESCRIBE Orders_Clean;

INSERT INTO Orders_Clean
    (OrderID, CustomerID, OrderDate, OrderStatus, PaymentMethod)
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    OrderStatus,
    PaymentMethod
FROM Orders_Raw;

SELECT COUNT(*) AS CleanOrderRows
FROM Orders_Clean;

	-- validating the customer relationship
    
SELECT
    COUNT(*) AS InvalidCustomerReferences
FROM Orders_Clean o
LEFT JOIN Customers_Clean c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

	-- Validate the Orders data itself
    
SELECT
    COUNT(*) AS TotalOrders,
    SUM(OrderID IS NULL) AS MissingOrderID,
    SUM(CustomerID IS NULL) AS MissingCustomerID,
    SUM(OrderDate IS NULL) AS MissingOrderDate,
    SUM(OrderStatus IS NULL) AS MissingOrderStatus,
    SUM(PaymentMethod IS NULL) AS MissingPaymentMethod
FROM Orders_Clean;

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders_Clean
GROUP BY OrderStatus
ORDER BY OrderStatus;

-- Buislding OrderDetails_Clean table

CREATE TABLE OrderDetails_Clean (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT FK_OrderDetailsClean_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders_Clean(OrderID),

    CONSTRAINT FK_OrderDetailsClean_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

DESCRIBE OrderDetails_Clean;

	-- Loading the validated orderdetails
    
INSERT INTO OrderDetails_Clean
    (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice, Discount)
SELECT
    OrderDetailID,
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    Discount
FROM OrderDetails_Raw;

SELECT COUNT(*) AS CleanOrderDetailRows
FROM OrderDetails_Clean;

	-- Validate OrderDetails_Clean
    -- Check Order references
    
SELECT
    COUNT(*) AS InvalidOrderReferences
FROM OrderDetails_Clean od
LEFT JOIN Orders_Clean o
    ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

	-- Check Product references
    
SELECT
    COUNT(*) AS InvalidProductReferences
FROM OrderDetails_Clean od
LEFT JOIN Products p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

	-- Validate Quantity and Discount
    
SELECT
    COUNT(*) AS InvalidQuantityRows
FROM OrderDetails_Clean
WHERE Quantity <= 0;

SELECT
    MIN(Quantity) AS MinimumQuantity,
    MAX(Quantity) AS MaximumQuantity
FROM OrderDetails_Clean;

SELECT
    COUNT(*) AS InvalidDiscountRows
FROM OrderDetails_Clean
WHERE Discount < 0
   OR Discount > 100;
   
SELECT
    MIN(Discount) AS MinimumDiscount,
    MAX(Discount) AS MaximumDiscount
FROM OrderDetails_Clean;

	-- Final Clean-Layer Validation
    
SELECT
    'Customers_Clean' AS TableName,
    COUNT(*) AS RowCount
FROM Customers_Clean

UNION ALL

SELECT
    'Products',
    COUNT(*)
FROM Products

UNION ALL

SELECT
    'Orders_Clean',
    COUNT(*)
FROM Orders_Clean

UNION ALL

SELECT
    'OrderDetails_Clean',
    COUNT(*)
FROM OrderDetails_Clean;

-- Verifying old vs new table

CREATE TABLE Customers_Old AS
SELECT * FROM Customers;

CREATE TABLE Orders_Old AS
SELECT * FROM Orders;

CREATE TABLE OrderDetails_Old AS
SELECT * FROM OrderDetails;

		-- Verifying the backup
        
SELECT 'Customers_Old' AS TableName, COUNT(*) AS RowCount
FROM Customers_Old

UNION ALL

SELECT 'Orders_Old', COUNT(*)
FROM Orders_Old

UNION ALL

SELECT 'OrderDetails_Old', COUNT(*)
FROM OrderDetails_Old;

DROP TABLE OrderDetails;
DROP TABLE Orders;
DROP TABLE Customers;

		-- Renaming tables
        
RENAME TABLE Customers_Clean TO Customers;
RENAME TABLE Orders_Clean TO Orders;
RENAME TABLE OrderDetails_Clean TO OrderDetails;

		-- FINAL DATABASE INTTEGRITY CHECK
        
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'EcommerceSalesDB'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;