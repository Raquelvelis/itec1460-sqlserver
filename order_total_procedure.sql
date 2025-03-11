-- Create a new stored procedure that calculates the total amount for an order
-- Specifying a parameter as OUTPUT means the procedure can modify
-- the parameter's value.


CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate the total amount for the given order
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    -- Check if the order exists
    IF @TotalAmount IS NULL
    BEGIN
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN;
    END

    PRINT 'The total amount for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' is $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- Test the stored procedure with a valid order
DECLARE @OrderID INT = 10248;
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(@TotalAmount AS NVARCHAR(20));

-- Test with an invalid order
SET @OrderID = 99999;
SET @TotalAmount = NULL;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(ISNULL(@TotalAmount, 0) AS NVARCHAR(20));
GO

-- =============================================
-- Part 2: CheckProductStock Procedure
-- =============================================


CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,
    @NeedsReorder BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the product needs to be reordered
    -- (when UnitsInStock is less than or equal to ReorderLevel)
    SELECT @NeedsReorder = CASE
                              WHEN UnitsInStock <= ReorderLevel THEN 1
                              ELSE 0
                           END
    FROM Products
    WHERE ProductID = @ProductID;
    
    -- Handle the case when the product ID doesn't exist
    IF @@ROWCOUNT = 0
    BEGIN
        SET @NeedsReorder = 0;
        RAISERROR('Product ID %d not found.', 11, 1, @ProductID);
        RETURN;
    END
END
GO

-- Test the new procedure
DECLARE @NeedsReorder BIT;
EXEC CheckProductStock 
    @ProductID = 11,
    @NeedsReorder = @NeedsReorder OUTPUT;
PRINT 'Needs Reorder: ' + CAST(@NeedsReorder AS VARCHAR(1));