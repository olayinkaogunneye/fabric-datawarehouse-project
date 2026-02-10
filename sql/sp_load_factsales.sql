DROP PROCEDURE IF EXISTS etl.sp_Load_FactSales;
GO

CREATE PROCEDURE etl.sp_Load_FactSales
AS
BEGIN
    BEGIN TRY
        DECLARE @Watermark DATETIME2;  -- Last successful load timestamp

        ---------------------------------------------------------
        -- 1. Retrieve the watermark from LoadControl
        ---------------------------------------------------------
        SELECT @Watermark = LastRun
        FROM etl.LoadControl
        WHERE StepName = 'Load FactSales';

        ---------------------------------------------------------
        -- 2. Insert only new rows into FactSales
        ---------------------------------------------------------
        INSERT INTO transformed.FactSales (
            SaleID,
            CustomerKey,
            ProductName,
            Quantity,
            Amount,
            SaleDate
        )
        SELECT 
            s.SaleID,
            d.CustomerKey,
            s.ProductName,
            s.Quantity,
            s.Amount,
            s.SaleDate
        FROM raw.StgSales s
        JOIN transformed.DimCustomer d
            ON s.CustomerName = d.CustomerName
        WHERE 
            @Watermark IS NULL          -- First run
            OR s.SaleDate > @Watermark; -- Only new rows

        ---------------------------------------------------------
        -- 3. Update the watermark
        ---------------------------------------------------------
        UPDATE etl.LoadControl
        SET LastRun = GETDATE()
        WHERE StepName = 'Load FactSales';
    END TRY

    BEGIN CATCH
        ---------------------------------------------------------
        -- 4. Log any errors
        ---------------------------------------------------------
        INSERT INTO etl.ErrorLog (
            StepName,
            ProcedureName,
            ErrorMessage,
            ErrorTime
        )
        VALUES (
            'Load FactSales',
            'etl.sp_Load_FactSales',
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH
END;
GO