DROP TABLE IF EXISTS raw.StgSales;

CREATE TABLE raw.StgSales(
    SaleID INT,
    CustomerName VARCHAR(100),
    ProductName VARCHAR(100),
    Quantity INT,
    Amount DECIMAL(10,2),
    SaleDate DATE
);

    
CREATE TABLE transformed.DimCustomer (
    CustomerKey BIGINT IDENTITY,
    CustomerName VARCHAR(100)
);

DROP TABLE IF EXISTS transformed.FactSales
CREATE TABLE transformed.FactSales (
    SaleID INT,
    CustomerKey BIGINT,
    ProductName VARCHAR(100),
    Quantity INT,
    Amount DECIMAL(10,2),
    SaleDate DATE
);

CREATE SCHEMA etl;

DROP TABLE etl.LoadControl;

CREATE TABLE etl.LoadControl (
    StepOrder INT,
    StepName VARCHAR(100),
    ProcedureName VARCHAR(200),
    IsActive BIT,
    LastRun DATETIME2(0)
);

INSERT INTO etl.LoadControl (StepOrder, StepName, ProcedureName, IsActive)
VALUES
(1, 'Clean Staging', 'etl.sp_Clean_StgSales', 1),
(2, 'Load DimCustomer', 'etl.sp_Load_DimCustomer', 1),
(3, 'Load FactSales', 'etl.sp_Load_FactSales', 1);

CREATE TABLE etl.ETLQueue (
    StepOrder INT,
    ProcedureName VARCHAR(200)
);
GO