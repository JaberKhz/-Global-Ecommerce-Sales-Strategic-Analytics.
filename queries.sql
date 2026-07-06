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


CREATE OR REPLACE VIEW v_running_revenue_trend AS
SELECT 
    so.OrderID,
    so.OrderDate,
    (p.SalePrice * so.Quantity) AS Order_Revenue,
    SUM(p.SalePrice * so.Quantity) OVER (ORDER BY so.OrderDate, so.OrderID) AS Running_Total_Revenue
FROM Sales_Orders so
JOIN Products p ON so.ProductID = p.ProductID;

