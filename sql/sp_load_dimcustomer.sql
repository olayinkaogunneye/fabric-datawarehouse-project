DROP PROCEDURE IF EXISTS etl.sp_Load_DimCustomer;
GO

CREATE PROCEDURE etl.sp_Load_DimCustomer
AS
BEGIN
    ---------------------------------------------------------
    -- 1. Get the list of distinct customers from staging
    ---------------------------------------------------------
    WITH DistinctCustomers AS (
        SELECT DISTINCT 
            CustomerName
        FROM raw.StgSales
        WHERE CustomerName IS NOT NULL
    )

    ---------------------------------------------------------
    -- 2. Merge into DimCustomer (SCD Type 1)
    ---------------------------------------------------------
    MERGE transformed.DimCustomer AS Target
    USING DistinctCustomers AS Source
        ON Target.CustomerName = Source.CustomerName

    WHEN NOT MATCHED THEN
        INSERT (CustomerName)
        VALUES (Source.CustomerName)

    WHEN MATCHED THEN
        UPDATE SET 
            Target.CustomerName = Source.CustomerName;  
END;
GO