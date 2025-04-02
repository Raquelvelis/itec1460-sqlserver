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


-- This procedure checks if a product needs to be reordered based on its inventory levels
CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,                  -- Input: The ID of the product we want to check
    @NeedsReorder BIT OUTPUT         -- Output: Will be set to 1 if reordering needed, 0 if not
AS
BEGIN
    -- Suppress rowcount messages for better performance
    SET NOCOUNT ON;
    
    -- STEP 1: Check inventory levels for the specified product
    -- Compare UnitsInStock against ReorderLevel from the Products table
    -- If stock is at or below reorder level, we need to reorder (set to 1)
    -- Otherwise, we don't need to reorder (set to 0)
    SELECT @NeedsReorder = CASE
                              WHEN UnitsInStock <= ReorderLevel THEN 1  -- Need to reorder
                              ELSE 0                                    -- Don't need to reorder
                           END
    FROM Products
    WHERE ProductID = @ProductID;  -- Filter to only look at the requested product
    
    -- STEP 2: Error handling - check if product exists
    -- @@ROWCOUNT will be 0 if no matching ProductID was found
    
    IF @@ROWCOUNT = 0
    BEGIN
        -- If product not found:
        SET @NeedsReorder = 0;                               -- Set output parameter to 0
        RAISERROR('Product ID %d not found.', 11, 1, @ProductID);  -- Display error with product ID
        RETURN;                                              -- Exit the procedure
    END
    
    -- Note: If we reach this point, the procedure was successful
    -- and @NeedsReorder contains our result (1 or 0)
END
GO  -- Marks the end of the procedure definition

-- TESTING SECTION
-- This code demonstrates how to use the procedure

-- Step 1: Declare a variable to hold the result
DECLARE @NeedsReorder BIT;

-- Step 2: Execute the procedure with a sample product ID (11)
-- and store the result in our @NeedsReorder variable
EXEC CheckProductStock 
    @ProductID = 11,                        -- Input parameter
    @NeedsReorder = @NeedsReorder OUTPUT;   -- Output parameter

-- Step 3: Display the result (1 = needs reorder, 0 = doesn't need reorder)
PRINT 'Needs Reorder:' + CAST(@NeedsReorder AS VARCHAR(1));