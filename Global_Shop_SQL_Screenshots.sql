-- 1. إنشاء جدول المنتجات
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    CostPrice NUMERIC(10, 2),
    SalePrice NUMERIC(10, 2)
);

-- 2. إنشاء جدول العملاء
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    City VARCHAR(50),
    Country VARCHAR(50),
    RegistrationDate DATE
);

-- 3. إنشاء جدول المبيعات
CREATE TABLE Sales_Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT REFERENCES Customers(CustomerID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    SalesChannel VARCHAR(20)
);

-- حشو بيانات جدول المنتجات
INSERT INTO Products VALUES 
(101, 'iPhone 15 Pro', 'Electronics', 'Phones', 800.00, 1200.00),
(102, 'MacBook Air M3', 'Electronics', 'Laptops', 900.00, 1400.00),
(103, 'Ergonomic Desk Chair', 'Furniture', 'Chairs', 120.00, 250.00),
(104, 'Electric Coffee Maker', 'Appliances', 'Kitchen', 45.00, 90.00),
(105, 'Running Shoes Max', 'Apparel', 'Shoes', 35.00, 85.00),
(106, 'Wireless Headphones', 'Electronics', 'Accessories', 60.00, 150.00),
(107, 'Leather Wallet', 'Apparel', 'Accessories', 15.00, 45.00),
(108, 'Smart Fitness Watch', 'Electronics', 'Watches', 110.00, 220.00);

-- حشو بيانات جدول العملاء
INSERT INTO Customers VALUES 
(201, 'Ahmed Ali', 'Male', 'Cairo', 'Egypt', '2025-01-15'),
(202, 'Sarah Smith', 'Female', 'London', 'UK', '2025-02-20'),
(203, 'John Doe', 'Male', 'New York', 'USA', '2025-03-05'),
(204, 'Fatima Hassan', 'Female', 'Dubai', 'UAE', '2025-06-12'),
(205, 'Omar Khaled', 'Male', 'Alexandria', 'Egypt', '2025-08-22'),
(206, 'Emily Davis', 'Female', 'Manchester', 'UK', '2025-11-01'),
(207, 'Michael Brown', 'Male', 'California', 'USA', '2026-01-10'),
(208, 'Yasmine Amine', 'Female', 'Casablanca', 'Morocco', '2026-02-18');

-- حشو بيانات جدول المبيعات (تغطي فترات مختلفة)
INSERT INTO Sales_Orders VALUES 
(1, '2025-02-01', 201, 101, 1, 'Online'),
(2, '2025-02-15', 202, 104, 2, 'In-Store'),
(3, '2025-03-10', 203, 102, 1, 'Online'),
(4, '2025-04-05', 201, 106, 2, 'Online'),
(5, '2025-06-15', 204, 101, 1, 'In-Store'),
(6, '2025-07-20', 202, 103, 1, 'Online'),
(7, '2025-08-25', 205, 105, 3, 'In-Store'),
(8, '2025-09-12', 203, 107, 1, 'Online'),
(9, '2025-10-05', 201, 101, 1, 'Online'), -- أحمد علي اشترى مجدداً
(10, '2025-11-15', 206, 102, 1, 'Online'),
(11, '2025-12-20', 204, 108, 1, 'In-Store'),
(12, '2026-01-05', 202, 101, 1, 'Online'), -- سارة اشترت مجدداً
(13, '2026-01-22', 207, 103, 2, 'In-Store'),
(14, '2026-02-10', 205, 106, 1, 'Online'),
(15, '2026-03-01', 208, 102, 1, 'Online'),
(16, '2026-03-15', 201, 105, 2, 'In-Store'), -- أحمد علي اشترى للمرة الثالثة
(17, '2026-04-02', 203, 108, 1, 'Online'),
(18, '2026-05-10', 207, 101, 1, 'Online'),
(19, '2026-06-01', 204, 105, 2, 'Online'),
(20, '2026-06-18', 208, 107, 4, 'In-Store');

Create Or Replace View v_order_financials As 
	Select 
		SO.OrderID,
		SO. OrderDate,
		C. CustomerName,
		C.Country,
		C.City,
		P.ProductName,
		P.Category,
		SO.Quantity,
		(P.SalePrice* SO.Quantity) AS Revenue,
		(p.CostPrice * SO.Quantity) AS Total_Cost,
		((P.SalePrice- p.CostPrice)* SO.Quantity) AS Profit
	From 
		Sales_Orders SO INNER JOIN Customers C ON SO. CustomerID = C. CustomerID
						INNER JOIN Products P ON SO.ProductID = P.ProductID;

Select 
	* 
From 
	v_order_financials;

Create Or Replace View v_sales_channel_performance AS 
		Select 
			SO.SalesChannel,
			SUM(SO.Quantity) AS Total_Quantity,
			Sum(p.SalePrice * SO.Quantity ) AS Total_revenue,
			Sum((p.SalePrice-p.CostPrice)*SO.Quantity) AS Profit
		From 
			Sales_Orders SO INNER JOIN  Products P ON SO.ProductID = P.ProductID
		Group By 
			SO.SalesChannel;
Select 
	* 
From 
	v_sales_channel_performance;

CREATE OR REPLACE VIEW v_running_revenue_trend AS
SELECT 
    so.OrderID,
    so.OrderDate,
    (p.SalePrice * so.Quantity) AS Order_Revenue,
    SUM(p.SalePrice * so.Quantity) OVER (ORDER BY so.OrderDate, so.OrderID) AS Running_Total_Revenue
FROM Sales_Orders so
JOIN Products p ON so.ProductID = p.ProductID;

Select 
	* 
From 
	v_running_revenue_trend
		