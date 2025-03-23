-- 1) Write a query to list all employees(FirstName, LastName) along with their start date.
-- This query retrieves basic employee information and sorts by their hire date (oldest employees first)
SELECT
    FirstName,
    LastName,
    HireDate
FROM 
    employees
ORDER BY 
    HireDate;

-- 2) Write a query that:
--   1. Lists employee names (FirstName and LastName)
--   2. Shows the OrderID for each order they've processed
--   3. Shows the OrderDate
--   4. Sorts the results by EmployeeID and then OrderDate
-- This query joins the Employees and Orders tables to show which orders were processed by which employees
-- The INNER JOIN means we only see employees who have processed at least one order
-- Results are organized first by employee and then chronologically by order date
SELECT 
    e.FirstName,
    e.LastName,
    o.OrderID,
    o.OrderDate
FROM
    Employees e
INNER JOIN
    Orders o
    ON
    e.EmployeeID = o.EmployeeID
ORDER BY
    e.EmployeeID,
    o.OrderDate;

-- 3) Create a simple report showing total sales by product category.
-- This query uses multiple joins to connect categories, products, and order details
-- It calculates sales by multiplying price by quantity for each line item
-- Then it groups these sales by category and sorts from highest to lowest sales
SELECT 
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM 
    Categories c 
JOIN 
    Products p
    ON
    c.CategoryID = p.CategoryID
JOIN 
    [Order Details] od 
    ON
    p.ProductID = od.ProductID
GROUP BY 
    c.CategoryName
ORDER BY 
    TotalSales 
DESC;

-- 4) Complete the following tasks:
-- a) Insert a new supplier named "Northwind Traders" based in Seattle, USA.
-- This adds a new row to the Suppliers table with basic information
-- Note that we're only specifying CompanyName, City, and Country; other columns will use their default values
INSERT INTO 
    Suppliers (CompanyName, City, Country)
    VALUES ('Northwind Trades', 'Seattle', 'USA');

-- b) Create a new category called "Organic Products".
-- Using LEFT() function to ensure the name fits within the column's maximum length (15 characters)
-- This is a defensive programming technique to avoid insertion errors
INSERT INTO
    Categories (CategoryName)
    VALUES (LEFT('Organic Products', 15)); -- Adjust 15 to Whatever the actual limit is 

-- c) Insert a new product called "Minneapolis Pizza".
-- This INSERT uses subqueries to find the appropriate CategoryID and SupplierID values
-- Rather than hardcoding IDs, this approach is more maintainable since it works even if IDs change
INSERT INTO
    Products (ProductName, CategoryID, SupplierID, UnitPrice, UnitsInStock)
VALUES ('Minneapolis Pizza',
        (SELECT 
            CategoryID
        FROM
            Categories
        WHERE
            CategoryName = 'Organic Products'),
        (SELECT
            SupplierID
        FROM
            Suppliers
        WHERE
            CompanyName = 'Northwind Traders'), 12.99, 50);

-- 5) Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
-- This mass update changes the category for all products from a specific supplier
-- The nested SELECT statements find the appropriate IDs to use in the update
-- TOP 1 is used to ensure only one ID is returned, preventing potential errors
UPDATE
    Products
SET 
    CategoryID = (
    SELECT TOP 1 CategoryID
    FROM Categories
    WHERE CategoryName ='Organic Products'
    )
WHERE SupplierID = (
    SELECT TOP 1 SupplierID
    FROM Suppliers
    WHERE CompanyName = 'Exotic Liquids'
    );
   
-- 6) Remove the product "Minneapolis Pizza".
-- Simple deletion based on product name
-- Note: In a real system, you might want to use ProductID instead for more precision
DELETE FROM
    Products
WHERE 
    ProductName = 'Minneapolis Pizza';      

-- 7) Create a new table named "EmployeePerformance"
-- This creates a table structure with appropriate data types and constraints:
-- - IDENTITY creates an auto-incrementing primary key
-- - NOT NULL ensures required fields cannot be empty
-- - FOREIGN KEY enforces referential integrity with the Employees table
CREATE TABLE EmployeePerformance (
    PerformanceID int PRIMARY KEY IDENTITY(1,1),
    EmployeeID int NOT NULL,
    Year int NOT NULL,
    Quarter int NOT NULL,
    SalesTarget decimal(15,2) NOT NULL,
    ActualSales decimal(15,2) NOT NULL,
    CONSTRAINT FK_EmployeePerformance_Employees 
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- 8) Create a view named "vw_ProductInventory"
-- This view simplifies access to inventory information by joining product and category data
-- Views are useful for frequently used queries and for hiding complexity from end users
-- They can also be used to implement security by restricting access to certain columns
CREATE VIEW vw_ProductInventory AS
SELECT 
    p.ProductName,
    c.CategoryName,
    p.UnitsInStock,
    p.UnitsOnOrder
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID;
GO

-- 9) Create a stored procedure called "sp_UpdateProductInventory"
-- This procedure encapsulates business logic for inventory updates:
-- - Takes two parameters: which product to update and what the new stock level should be
-- - Includes validation logic to prevent negative inventory
-- - Returns the updated product info for confirmation
CREATE PROCEDURE sp_UpdateProductInventory
    @ProductID int,
    @NewStockLevel int
AS
BEGIN
    -- Validation to ensure stock level is never negative
    IF @NewStockLevel < 0
        SET @NewStockLevel = 0; 
    
    -- Update the product's stock level
    UPDATE Products
    SET UnitsInStock = @NewStockLevel
    WHERE ProductID = @ProductID;
    
    -- Return the updated product information for confirmation
    SELECT ProductName, UnitsInStock
    FROM Products
    WHERE ProductID = @ProductID;
END;    

-- Test the stored procedure with a valid product and positive value
-- First checking current value, then updating to 25 units
SELECT ProductID, ProductName, UnitsInStock 
FROM Products 
WHERE ProductID = 1; 

EXEC sp_UpdateProductInventory 
    @ProductID = 1, 
    @NewStockLevel = 25;

-- Test with negative value (should be converted to zero)
EXEC sp_UpdateProductInventory 
    @ProductID = 1, 
    @NewStockLevel = -10;

-- Verify final result
SELECT ProductID, ProductName, UnitsInStock 
FROM Products 
WHERE ProductID = 1;
GO

-- 10) Write a query to find the top 5 customers by total freight costs.
-- This analysis query:
-- - Joins customer data with their orders
-- - Calculates multiple aggregate values (sum, count, average)
-- - Uses GROUP BY to analyze by customer
-- - Limits results to just the top 5 using TOP
-- - Orders results by highest freight cost first
SELECT TOP 5
    c.CustomerID,
    SUM(o.Freight) AS TotalFreightCost,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.Freight) / COUNT(o.OrderID) AS AverageFreightPerOrder
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID
ORDER BY 
    TotalFreightCost DESC;

      


      
