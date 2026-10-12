		-- E-Commerce Sales & Customer Analytics
		-- Business analysis using MySQL 8.0
		-- Database: EcommerceSalesDB

USE EcommerceSalesDB;

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Products;

		-- CHAPTER 1: SALES AND REVENUE PERFORMANCE
			-- Calculating Total Gross Sales
            
SELECT
    SUM(Quantity * UnitPrice) AS TotalGrossSales
FROM OrderDetails;

			-- Calculating Total Discount Amount
            
SELECT
    ROUND(SUM(Quantity * UnitPrice * Discount / 100),2) AS TotalDiscountAmount
FROM OrderDetails; 

			-- Calculating Total Net Revenue
            
SELECT
    ROUND(SUM(
        Quantity * UnitPrice
        - (Quantity * UnitPrice * Discount / 100)
    ),2) AS TotalNetRevenue
FROM OrderDetails;

			-- Calculating overall Discount Rate
            
SELECT
    ROUND(
        SUM(Quantity * UnitPrice * Discount / 100)
        / NULLIF(SUM(Quantity * UnitPrice), 0) * 100,
        2
    ) AS OverallDiscountRate
FROM OrderDetails;

			-- Creating Sales Performance Summary
            
SELECT
    ROUND(SUM(Quantity * UnitPrice), 2)
        AS TotalGrossSales,

    ROUND(
        SUM(Quantity * UnitPrice * Discount / 100),
        2
    ) AS TotalDiscountAmount,

    ROUND(
        SUM(
            Quantity * UnitPrice
            * (1 - Discount / 100)
        ),
        2
    ) AS TotalNetRevenue,

    ROUND(
        SUM(Quantity * UnitPrice * Discount / 100)
        / NULLIF(SUM(Quantity * UnitPrice), 0) * 100,
        2
    ) AS OverallDiscountRate
FROM OrderDetails;

			-- Total Orders and Average Order Value (AOV)
            
SELECT
    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) / COUNT(DISTINCT o.OrderID),
        2
    ) AS AverageOrderValue
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID;
    
			-- Analyze Order Status
        
SELECT
    OrderStatus,
    COUNT(*) AS TotalOrders,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM Orders),
        2
    ) AS PercentageOfOrders
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;

			-- MONTHLY SALES TREND
            -- Find the best and worst sales month
            
SELECT
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS NetRevenue,

    ROUND(
        SUM(od.Quantity * od.UnitPrice),
        2
    ) AS GrossSales,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * od.Discount / 100
        ),
        2
    ) AS DiscountAmount

FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
ORDER BY OrderMonth;

			-- CHAPTER 3: PRODUCT AND CATEGORY PERFORMANCE
            -- Rank product categories by net revenue
            
SELECT
    p.Category,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    SUM(od.Quantity) AS UnitsSold,

    ROUND(
        SUM(od.Quantity * od.UnitPrice),
        2
    ) AS GrossSales,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * od.Discount / 100
        ),
        2
    ) AS DiscountAmount,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS NetRevenue

FROM OrderDetails od
JOIN Orders o
    ON od.OrderID = o.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID

GROUP BY p.Category
ORDER BY NetRevenue DESC;

			-- Identify the Top 10 Products by Delivered Net Revenue
            
SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.State,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS TotalNetRevenue

FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

WHERE o.OrderStatus = 'Delivered'

GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.State

ORDER BY TotalNetRevenue DESC
LIMIT 10;

			-- Verifying the number of Total delivery orders

SELECT
    COUNT(DISTINCT OrderID) AS TotalDeliveredOrders
FROM Orders
WHERE OrderStatus = 'Delivered';

			-- CHAPTER 4: CUSTOMER BEHAVIOUR AND VALUE
            -- Rank the top 10 customers by net revenue
            
SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.State,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS TotalNetRevenue

FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.State

ORDER BY TotalNetRevenue DESC
LIMIT 10;

SELECT
    c.State,
    COUNT(DISTINCT o.OrderID) AS DeliveredOrders
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.State
ORDER BY DeliveredOrders DESC;

			-- Measure the Repeat-Customer Rate
            
WITH CustomerOrderCounts AS (
    SELECT
        CustomerID,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS TotalCustomers,

    SUM(TotalOrders > 1) AS RepeatCustomers,

    SUM(TotalOrders = 1) AS OneTimeCustomers,

    ROUND(
        SUM(TotalOrders > 1) * 100.0
        / COUNT(*),
        2
    ) AS RepeatCustomerRate

FROM CustomerOrderCounts;

			-- CHAPTER 5: REGIONAL SALES ANALYSIS
            -- Rank States by Net Revenue
SELECT
    c.State,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    COUNT(DISTINCT c.CustomerID) AS CustomersWithOrders,

    SUM(od.Quantity) AS UnitsSold,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS NetRevenue,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) / COUNT(DISTINCT o.OrderID),
        2
    ) AS RevenuePerOrder

FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

WHERE o.OrderStatus = 'Delivered'

GROUP BY c.State
ORDER BY NetRevenue DESC;

			-- CHAPTER 6: DISCOUNT EFFECTIVENESS
			-- Compare sales performance across discount levels
		
SELECT
    Discount,

    COUNT(*) AS OrderLines,

    SUM(Quantity) AS UnitsSold,

    ROUND(
        SUM(Quantity * UnitPrice),
        2
    ) AS GrossSales,

    ROUND(
        SUM(Quantity * UnitPrice * Discount / 100),
        2
    ) AS DiscountAmount,

    ROUND(
        SUM(
            Quantity * UnitPrice
            * (1 - Discount / 100)
        ),
        2
    ) AS NetRevenue

FROM OrderDetails

GROUP BY Discount
ORDER BY Discount;

			-- Comparing Order Status
SELECT
    o.OrderStatus,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.Quantity) AS Units,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS GrossSales,
    ROUND(
        SUM(od.Quantity * od.UnitPrice * od.Discount / 100),
        2
    ) AS DiscountAmount,
    ROUND(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount / 100)),
        2
    ) AS NetOrderValue
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderStatus
ORDER BY TotalOrders DESC;

			-- Delivered Sales Performance
            
SELECT
    COUNT(DISTINCT o.OrderID) AS DeliveredOrders,

    SUM(od.Quantity) AS DeliveredUnits,

    ROUND(
        SUM(od.Quantity * od.UnitPrice),
        2
    ) AS DeliveredGrossSales,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * od.Discount / 100),
        2
    ) AS DeliveredDiscount,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS DeliveredNetSales,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) / NULLIF(COUNT(DISTINCT o.OrderID), 0),
        2
    ) AS DeliveredAOV

FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
WHERE o.OrderStatus = 'Delivered';

			-- Payment Method Analysis
            
SELECT
    o.PaymentMethod,

    COUNT(DISTINCT o.OrderID) AS DeliveredOrders,

    SUM(od.Quantity) AS UnitsSold,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ),
        2
    ) AS DeliveredNetSales,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) / NULLIF(COUNT(DISTINCT o.OrderID), 0),
        2
    ) AS AverageOrderValue

FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

WHERE o.OrderStatus = 'Delivered'

GROUP BY o.PaymentMethod
ORDER BY DeliveredNetSales DESC;

			-- Category Ranking and Revenue Contribution
            
WITH CategorySales AS (
    SELECT
        p.Category,
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) AS NetRevenue
    FROM OrderDetails od
    JOIN Products p
        ON od.ProductID = p.ProductID
    JOIN Orders o
        ON od.OrderID = o.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY p.Category
)
SELECT
    Category,
    ROUND(NetRevenue, 2) AS NetRevenue,

    RANK() OVER (
        ORDER BY NetRevenue DESC
    ) AS RevenueRank,

    ROUND(
        NetRevenue * 100.0
        / NULLIF(SUM(NetRevenue) OVER (), 0),
        2
    ) AS RevenueSharePct

FROM CategorySales
ORDER BY RevenueRank;

			-- Monthly Sales Growth using LAG()
            
WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth,

        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) AS NetRevenue

    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID

    WHERE o.OrderStatus = 'Delivered'

    GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
),

RevenueWithPrevious AS (
    SELECT
        OrderMonth,
        NetRevenue,

        LAG(NetRevenue) OVER (
            ORDER BY OrderMonth
        ) AS PreviousMonthRevenue

    FROM MonthlySales
)

SELECT
    OrderMonth,
    ROUND(NetRevenue, 2) AS NetRevenue,
    ROUND(PreviousMonthRevenue, 2) AS PreviousMonthRevenue,

    ROUND(
        NetRevenue - PreviousMonthRevenue,
        2
    ) AS MoMChange,

    ROUND(
        (NetRevenue - PreviousMonthRevenue)
        / NULLIF(PreviousMonthRevenue, 0) * 100,
        2
    ) AS MoMGrowthPct

FROM RevenueWithPrevious
ORDER BY OrderMonth;

			-- Customer Segmentation
            
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        COUNT(DISTINCT o.OrderID) AS OrderCount,

        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) AS NetSales

    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID

    WHERE o.OrderStatus = 'Delivered'

    GROUP BY c.CustomerID
),

CustomerSegments AS (
    SELECT
        CustomerID,
        OrderCount,
        NetSales,

        CASE
            WHEN OrderCount >= 5 AND NetSales >= 10000
                THEN 'High Value / Frequent'
            WHEN OrderCount >= 3
                THEN 'Repeat Customers'
            WHEN OrderCount = 1
                THEN 'One-Time Customers'
            ELSE 'Occasional Customers'
        END AS CustomerSegment

    FROM CustomerMetrics
)

SELECT
    CustomerSegment,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(NetSales), 2) AS TotalNetSales,
    ROUND(AVG(NetSales), 2) AS AverageSalesPerCustomer,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS CustomerSharePct

FROM CustomerSegments

GROUP BY CustomerSegment
ORDER BY TotalNetSales DESC;

			-- FINAL AUDIT: VERIFY DATA QUALITY AND INTEGRITY
            
SELECT 'Customers: missing name' AS AuditCheck,
       COUNT(*) AS IssueCount
FROM Customers
WHERE CustomerName IS NULL
   OR TRIM(CustomerName) = ''

UNION ALL

SELECT 'Customers: missing location or signup date',
       COUNT(*)
FROM Customers
WHERE City IS NULL
   OR State IS NULL
   OR SignupDate IS NULL

UNION ALL

SELECT 'Products: missing name or category',
       COUNT(*)
FROM Products
WHERE ProductName IS NULL
   OR TRIM(ProductName) = ''
   OR Category IS NULL
   OR SubCategory IS NULL

UNION ALL

SELECT 'Products: invalid price',
       COUNT(*)
FROM Products
WHERE Price IS NULL OR Price <= 0

UNION ALL

SELECT 'Orders: invalid status',
       COUNT(*)
FROM Orders
WHERE OrderStatus IS NULL
   OR OrderStatus NOT IN (
       'Delivered', 'Shipped', 'Processing', 'Cancelled'
   )

UNION ALL

SELECT 'Orders: before customer signup',
       COUNT(*)
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignupDate

UNION ALL

SELECT 'OrderDetails: invalid quantity',
       COUNT(*)
FROM OrderDetails
WHERE Quantity IS NULL OR Quantity <= 0

UNION ALL

SELECT 'OrderDetails: invalid discount',
       COUNT(*)
FROM OrderDetails
WHERE Discount IS NULL
   OR Discount < 0
   OR Discount > 100

UNION ALL

SELECT 'OrderDetails: missing order reference',
       COUNT(*)
FROM OrderDetails od
LEFT JOIN Orders o
    ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL

UNION ALL

SELECT 'OrderDetails: missing product reference',
       COUNT(*)
FROM OrderDetails od
LEFT JOIN Products p
    ON od.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

			-- Verify final table counts
            
SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows
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

			-- Final sales calculation consistency check
            
SELECT
    ROUND(
        SUM(Quantity * UnitPrice),
        2
    ) AS GrossSales,

    ROUND(
        SUM(Quantity * UnitPrice * Discount / 100),
        2
    ) AS DiscountAmount,

    ROUND(
        SUM(Quantity * UnitPrice * (1 - Discount / 100)),
        2
    ) AS NetSales,

    ROUND(
        SUM(Quantity * UnitPrice)
        - SUM(Quantity * UnitPrice * Discount / 100)
        - SUM(Quantity * UnitPrice * (1 - Discount / 100)),
        6
    ) AS ReconciliationDifference

FROM OrderDetails;

			-- Capture the final business KPIs
            
SELECT
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT o.CustomerID) AS CustomersWithOrders,
    SUM(od.Quantity) AS TotalUnitsSold,

    ROUND(
        SUM(od.Quantity * od.UnitPrice), 2
    ) AS GrossSales,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * od.Discount / 100), 2
    ) AS DiscountAmount,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount / 100)), 2
    ) AS NetSalesAfterDiscount,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount / 100))
        / NULLIF(COUNT(DISTINCT o.OrderID), 0), 2
    ) AS AverageOrderValue,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * od.Discount / 100)
        / NULLIF(SUM(od.Quantity * od.UnitPrice), 0) * 100, 2
    ) AS OverallDiscountRate

FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID;
    
			-- Delivered-only sales summary
            
SELECT
    COUNT(DISTINCT o.OrderID) AS DeliveredOrders,

    COUNT(DISTINCT o.CustomerID) AS DeliveredCustomers,

    SUM(od.Quantity) AS DeliveredUnits,

    ROUND(
        SUM(od.Quantity * od.UnitPrice), 2
    ) AS DeliveredGrossSales,

    ROUND(
        SUM(od.Quantity * od.UnitPrice * od.Discount / 100), 2
    ) AS DeliveredDiscount,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ), 2
    ) AS DeliveredNetSales,

    ROUND(
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) / NULLIF(COUNT(DISTINCT o.OrderID), 0),
        2
    ) AS DeliveredAOV,

    ROUND(
        COUNT(DISTINCT o.OrderID) * 100.0
        / NULLIF((SELECT COUNT(*) FROM Orders), 0),
        2
    ) AS DeliveredOrderRatePct

FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID

WHERE o.OrderStatus = 'Delivered';

			-- Break down the undelivered orders
            
SELECT
    OrderStatus,
    COUNT(*) AS TotalOrders,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM Orders),
        2
    ) AS OrderSharePct
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;

			-- Final analytical coverage check
            
WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.Category,
        SUM(
            od.Quantity * od.UnitPrice
            * (1 - od.Discount / 100)
        ) AS NetSales
    FROM OrderDetails od
    JOIN Products p
        ON od.ProductID = p.ProductID
    JOIN Orders o
        ON od.OrderID = o.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY p.ProductID, p.ProductName, p.Category
),
RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        Category,
        NetSales,
        RANK() OVER (ORDER BY NetSales DESC) AS ProductRank
    FROM ProductSales
)
SELECT
    COUNT(*) AS ProductsWithDeliveredSales,
    ROUND(SUM(NetSales), 2) AS TotalDeliveredNetSales,
    ROUND(
        SUM(CASE WHEN ProductRank <= 10 THEN NetSales ELSE 0 END),
        2
    ) AS Top10ProductsNetSales,
    ROUND(
        100.0 * SUM(CASE WHEN ProductRank <= 10 THEN NetSales ELSE 0 END)
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS Top10RevenueSharePct
FROM RankedProducts;

			-- Delivered-customer repeat rate
            
WITH CustomerDeliveredOrders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT OrderID) AS DeliveredOrderCount
    FROM Orders
    WHERE OrderStatus = 'Delivered'
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS CustomersWithDeliveredOrders,

    SUM(DeliveredOrderCount > 1) AS RepeatCustomers,

    SUM(DeliveredOrderCount = 1) AS OneDeliveredOrderCustomers,

    ROUND(
        SUM(DeliveredOrderCount > 1) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS RepeatCustomerRatePct

FROM CustomerDeliveredOrders;

			-- REMAINING VERIFICATION
            
SELECT
    CustomerName,
    COUNT(*) AS CustomerRecords
FROM Customers
GROUP BY CustomerName
HAVING COUNT(*) > 1
ORDER BY CustomerRecords DESC;