DROP PROCEDURE IF EXISTS etl.sp_Run_ETL;
GO

CREATE PROCEDURE etl.sp_Run_ETL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @StepOrder INT,
        @ProcedureName VARCHAR(200);

    BEGIN TRY
        ---------------------------------------------------------
        -- 1. Start fresh: clear the ETL queue
        ---------------------------------------------------------
        DELETE FROM etl.ETLQueue;

        ---------------------------------------------------------
        -- 2. Load all active ETL steps into the queue
        ---------------------------------------------------------
        INSERT INTO etl.ETLQueue (StepOrder, ProcedureName)
        SELECT StepOrder, ProcedureName
        FROM etl.LoadControl
        WHERE IsActive = 1
        ORDER BY StepOrder;

        ---------------------------------------------------------
        -- 3. Run each step in order
        ---------------------------------------------------------
        WHILE EXISTS (SELECT 1 FROM etl.ETLQueue)
        BEGIN
            -- Get the next step
            SELECT TOP 1
                @StepOrder = StepOrder,
                @ProcedureName = ProcedureName
            FROM etl.ETLQueue
            ORDER BY StepOrder;

            -- Run the stored procedure
            EXEC (@ProcedureName);

            -- Update the LastRun timestamp
            UPDATE etl.LoadControl
            SET LastRun = GETDATE()
            WHERE StepOrder = @StepOrder;

            -- Remove the step from the queue
            DELETE FROM etl.ETLQueue
            WHERE StepOrder = @StepOrder;
        END
    END TRY

    BEGIN CATCH
        ---------------------------------------------------------
        -- 4. Log any errors that happen in the wrapper
        ---------------------------------------------------------
        INSERT INTO etl.ErrorLog (
            StepName,
            ProcedureName,
            ErrorMessage,
            ErrorTime
        )
        VALUES (
            'Wrapper Execution',
            'etl.sp_Run_ETL',
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH
END;
GO
