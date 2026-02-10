DROP PROCEDURE IF EXISTS etl.sp_Clean_StgSales;
GO

CREATE PROCEDURE etl.sp_Clean_StgSales
AS
BEGIN
    -- Remove rows with missing fields
    DELETE FROM raw.StgSales
    WHERE 
        SaleID IS NULL OR
        CustomerName IS NULL OR
        ProductName IS NULL OR
        Quantity IS NULL OR
        Amount IS NULL OR
        SaleDate IS NULL;

    -- Remove invalid numeric values
    DELETE FROM raw.StgSales
    WHERE 
        Quantity <= 0
        OR Amount <= 0;

    -- Trim whitespace from product names
    UPDATE raw.StgSales
    SET ProductName = LTRIM(RTRIM(ProductName));

    -- Remove test/sample rows
    DELETE FROM raw.StgSales
    WHERE ProductName LIKE '%TEST%'
       OR ProductName LIKE '%SAMPLE%';
END;
GO