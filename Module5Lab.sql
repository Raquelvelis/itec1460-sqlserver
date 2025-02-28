--INSERT OPERATION

-- Create New Customer
sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country) 
VALUES ('STUD3', 'ALIBABA', 'Raquel Velis', 'USA');"

--Verify the Insertion
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

--Create a New Order
sqlq "INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry) 
VALUES ('STUDE', 1, GETDATE(), 'USA');"

-- Verify if the order was creates
sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;"

--UPDATE OPERATION
-- Change the Contact Name for our customer:
sqlq "UPDATE Customers SET ContactName = 'New Contact Name' WHERE CustomerID= 'STUDE';"

--Verify if the name was updated: 
sqlq "SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';"

--Update Orders Details
sqlq "UPDATE Orders SET ShipCountry = 'New Country' WHERE CustomerID = 'STUDE';"

-- Verify if the country was updated 
sqlq "SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';"

--DELETE OPERATION
sqlq "DELETE FROM Orders WHERE CustomerID = 'STUDE';"

--Verify if the order was deleted:
sqlq "SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';"

--Delete the customer:
sqlq "DELETE FROM Customers WHERE CustomerID = 'STUDE';"

--Verify that the customer was deleted:
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

--LAB 5 PART 2 

sqlq "INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-up Foods', 'Raquel', 'Owner', 'Venezuela');"

-- Check your work:
sqlq "SELECT * FROM Suppliers WHERE CompanyName = 'Pop-up Foods';"

-- Insert the new product directly using a subquery to get the SupplierID

sqlq "INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock) 
      VALUES ('House Special Pizza', (
        SELECT SupplierID FROM Suppliers 
        WHERE CompanyName = 'Pop-up Foods'), 2, 15.99, 50                                    
);"

-- Verify the new product was added
-- 
sqlq "SELECT * FROM Products
      WHERE ProductName = 'House Special Pizza';" -- Filter to only show the new product

--Another Update Product Name
sqlq "UPDATE Products
      SET UnitPrice = 15.55
      WHERE ProductName = 'Chai';"

--My Own Update
 -- Reduce inventory from 50 to 25 units UnitPrice = 17.99  
 -- Increase price from $15.99 to $17.99

sqlq "UPDATE Products
    SET 
        UnitsInStock = 25,
        UnitPrice = 17.99
    WHERE 
    ProductName = 'House Special Pizza';"

-- DELETE command to remove your pizza product.
    sqlq "DELETE FROM Products
    WHERE ProductName = 'House Special Pizza';"

-- Verify the product has been deleted
sqlq "SELECT * FROM Products 
      WHERE ProductName = 'House Special Pizza';"


    -- Creating my OWN MENU

    -- Add a new menu item: Chocolate Lava Cake
    -- Assuming category 3 is desserts
sqlq "INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
    VALUES (
    'Chocolate Lava Cake',
        (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Pop-up Foods'),
    3,
    8.99,
    35
);"

-- Verify the product was added
sqlq "SELECT * FROM Products WHERE ProductName = 'Chocolate Lava Cake';"

--Update the Price and Inventory

sqlq "UPDATE Products
      SET 
        UnitPrice = 9.99,
        UnitsInStock = 42
      WHERE 
        ProductName = 'Chocolate Lava Cake';"

-- Verify the changes
sqlq "SELECT ProductName, UnitPrice, UnitsInStock 
      FROM Products 
      WHERE ProductName = 'Chocolate Lava Cake';"

-- Remove the Product
sqlq "DELETE FROM Products
WHERE ProductName = 'Chocolate Lava Cake';"

-- Verify the product was removed
sqlq "SELECT * FROM Products 
WHERE ProductName = 'Chocolate Lava Cake';"