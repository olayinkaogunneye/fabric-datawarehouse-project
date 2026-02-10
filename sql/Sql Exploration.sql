SELECT TOP 10 *
FROM raw.StgSales;

SELECT *
FROM raw.StgSales
ORDER BY SaleDate;

SELECT *
FROM raw.StgSales
WHERE Amount > 500;

SELECT *
FROM raw.StgSales
WHERE CustomerName = 'Alice Johnson';

SELECT *,
    CASE WHEN Quantity <=0 THEN 'invalid quantity'
    WHEN Amount <= 0 THEN 'invalid amount'
    ELSE 'OK'
    END as Qty_flag
    FROM raw.StgSales

SELECT UPPER(CustomerName)
    FROM raw.StgSales;