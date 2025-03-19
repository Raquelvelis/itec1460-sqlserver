-- 1) Write a query to list all employees(FirstName, LastName) along with their start date.
 SELECT
    FirstName,
    LastName,
    HireDate
 FROM 
    employees
 ORDER BY 
    HireDate;

-- 2) Write a query that:
    --1. Lists employee names (FirstName and LastName)
    --2. Shows the OrderID for each order they've processed
    --3. Shows the OrderDate
    --4. Sorts the results by EmployeeID and then OrderDate
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

    --3) Create a simple report showing total sales by product category. Include the CategoryName and TotalSales 
    --(calculated as the sum of UnitPrice * Quantity). Sort your results by TotalSales in descending order.
  SELECT 
      c.CategoryName,
      SUM(od.UnitPrice * od.Quantity)
         AS 
         TotalSales
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
  Group BY 
      c.CategoryName
  ORDER BY 
      TotalSales 
  DESC;

--4) Complete the following tasks:
--    a) Insert a new supplier named "Northwind Traders" based in Seattle, USA.
  INSERT INTO 
      Suppliers (CompanyName, City, Country)
      VALUES ('Northwind Trades', 'Seattle', 'USA');

--    b) Create a new category called "Organic Products".
   INSERT INTO
      Categories (CategoryName)
      VALUES (LEFT('Organic Products', 15)); -- Adjust 15 to Whatever the actual limit is 

--     c) Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values.
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
   UPDATE
      Products
   SET 
      CategoryID  = (
      SELECT TOP 1 CategoryID
      FROM Categories
      WHERE CategoryName ='Organic Products'
      )
   WHERE  SupplierID = (
      SELECT TOP 1 SupplierID
      FROM Suppliers
      WHERE CompanyName = 'Exotic Liquids'
      );
   
-- 6) Remove the product "Minneapolis Pizza".
   DELETE FROM
      Products
   WHERE 
      ProductName = 'Minneapolis Pizza';      

--  7) Create a new table named "EmployeePerformance" --with the following columns: PerformanceID (int, primary key, auto-increment)

   --EmployeeID (int, foreign key referencing Employees table)
      --Year (int)
      --Quarter (int)
      --SalesTarget (decimal(15,2))
      --ActualSales (decimal(15,2))    

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
-- 8) Create a view named "vw_ProductInventory" that shows ProductName, CategoryName, 
-- UnitsInStock, and UnitsOnOrder for all products.

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
-- 9) Create a stored procedure called "sp_UpdateProductInventory" that:
--Takes two inputs: ProductID and NewStockLevel
--Updates the UnitsInStock value for the product you specify
--Makes sure the stock level is never less than zero

  CREATE PROCEDURE sp_UpdateProductInventory
      @ProductID int,
      @NewStockLevel int
   AS
   BEGIN
      IF @NewStockLevel < 0
        SET @NewStockLevel = 0; 
      UPDATE Products
      SET UnitsInStock = @NewStockLevel
      WHERE ProductID = @ProductID;
      SELECT ProductName, UnitsInStock
      FROM Products
      WHERE ProductID = @ProductID;
   END;    

   -- Test the stored procedure with a valid order
   SELECT ProductID, ProductName, UnitsInStock 
   FROM Products 
   WHERE ProductID = 1; 
      EXEC sp_UpdateProductInventory 
         @ProductID = 1, 
         @NewStockLevel = 25;
   EXEC sp_UpdateProductInventory 
    @ProductID = 1, 
    @NewStockLevel = -10;
   SELECT ProductID, ProductName, UnitsInStock 
   FROM Products 
   WHERE ProductID = 1;
GO
   -- 10) Write a query to find the top 5 customers by total freight costs. Include CustomerID, 
   -- TotalFreightCost, NumberOfOrders, and AverageFreightPerOrder. 

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


      


      
