--INSERT OPERATION
-- Create New Customer
sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country) 
VALUES ('STUD5', 'ALIBABA', 'Raquel Velis', 'USA');"

--Verify the Insertion
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

--Create a New Order
sqlq "INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry) 
VALUES ('STUDE', 1, GETDATE(), 'USA');"

-- Verify if the order was creates
sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;"

--UPDATE OPERATION
-- Change the Contact Name for our customer:
sqlq "UPDATE Customers SET ContactName = 'Maria Perez' WHERE CustomerID = 'STUDE';"

--Verify if the name was updated: 
sqlq "SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';"

--Update Orders Details
sqlq "UPDATE Orders SET ShipCountry = 'Venezuela' WHERE CustomerID = 'STUDE';"

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