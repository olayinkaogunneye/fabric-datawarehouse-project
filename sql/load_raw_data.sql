COPY INTO raw.StgSales
FROM 'https://onelake.dfs.fabric.microsoft.com/<WorkspaceGUID>/<LakehouseGUID>/Files/StgSales.csv'
WITH (
    FILE_TYPE = 'CSV',       -- File format
    FIRSTROW = 2,            -- Skip header row
    FIELDTERMINATOR = ','    -- CSV delimiter
);