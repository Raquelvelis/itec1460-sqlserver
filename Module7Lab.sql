-- Create a new stored procedure that calculate the 
--Total amount for an order
--Our stored procedure accepts two paramenters as input
--Accepts the order ID and the total amount,
-- Then return the updated total amount as output
CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Calculate the total amount for the given order.
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    -- Check if the order exists - handle the error condition
    -- if the order ID doesn't match any items in the Order Details table

    IF @TotalAmount IS NULL 
    BEGIN
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        -- Exits the stored procedure
        RETURN;
    END

    -- Output the total amount for the order
    PRINT 'The total amount for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' is $' + 
    CAST(@TotalAmount AS NVARCHAR(20));
END
-- Go causes the stored procedure to run after it's altered or created
GO

-- Tests the stored procedure with a valid order
-- First declare the variables 
DECLARE @OrderID INT = 99999;
DECLARE @TotalAmount MONEY;

--Call the stored procedured
EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
     @TotalAmount =  @TotalAmount OUTPUT;

-- Print the results of the stored Procedur (output the results)
PRINT 'Returned total amount: $' + CAST(ISNULL( @TotalAmount, 0) AS NVARCHAR(20));
-- Test with an invalid order
SET @OrderID = 10248;
SET @TotalAmount = NULL;
EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount =  @TotalAmount OUTPUT;
PRINT 'Returned total amount: $' + CAST(ISNULL( @TotalAmount, 0) AS NVARCHAR(20));
GO
-- Test with an invalid order
SET @OrderID = 99999;
SET @TotalAmount = NULL;
-- Call the stored procedure
EXEC CalculateOrderTotal
    @OrderID = @OrderID,
    @TotalAmount =  @TotalAmount OUTPUT;
-- Print the results of the stored procedure (output the results)
PRINT 'Returned total amount: $' + CAST(ISNULL( @TotalAmount, 0) AS NVARCHAR(20));