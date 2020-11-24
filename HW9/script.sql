 --Загрузить данные из файла StockItems.xml в таблицу Warehouse.StockItems.

 
DECLARE @x XML
SET @x = ( 
  SELECT * FROM OPENROWSET
  (BULK 'C:\Users\user\Desktop\StockItems.xml',
   SINGLE_BLOB)
   as d)

select @x

--2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml

SELECT  StockItemName as [@Name],
		SupplierID as [SupplierID],
		UnitPackageID as [Package/UnitPackageID],
		OuterPackageID as [Package/OuterPackageID],
		QuantityPerOuter as [Package/QuantityPerOuter],
		TypicalWeightPerUnit as [Package/TypicalWeightPerUnit],
		LeadTimeDays as [LeadTimeDays],
		IsChillerStock as [IsChillerStock],
		TaxRate as [TaxRate],
		UnitPrice as [UnitPrice]
FROM Warehouse.StockItems
FOR XML PATH('Item'), ROOT('StockItems')


--3.В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
--Написать SELECT для вывода

select	  StockItemID
		, StockItemName
		, (select json_value((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = si.StockItemID),'$.CountryOfManufacture')) CountryOfManufacture
		, (select json_value((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = si.StockItemID),'$.Tags[1]')) FirstTag
	from Warehouse.StockItems si order by StockItemID




--4. Найти в StockItems строки, где есть тэг "Vintage

select StockItemID, StockItemName,(select json_query((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = t.StockItemID),'$.Tags')) as Tags
from Warehouse.StockItems t
where (select json_value((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = t.StockItemID),'$.Tags[0]')) = 'Vintage' or (select json_value((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = t.StockItemID),'$.Tags[1]')) = 'Vintage' or(select json_value((select top 1 CustomFields as CustomFields from Warehouse.StockItems where StockItemID = t.StockItemID),'$.Tags[2]')) = 'Vintage'

--Пишем динамический PIVOT

DECLARE @query varchar(max), @name varchar(max)
SELECT @name = (SELECT SUBSTRING(c.CustomerName, 16,LEN(c.CustomerName)-16) as CustomerName FROM Sales.Customers c WHERE c.CustomerID between 2 and 6)

set @query = 'SELECT *
FROM(
		SELECT distinct CustomerName, FORMAT(i.InvoiceDate,''dd.MM.yyyy'') AS InvoiceMonth, il.InvoiceID
		FROM Sales.Customers c
		JOIN Sales.Invoices i ON c.CustomerID = i.CustomerID
		JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
		WHERE c.CustomerID between 2 and 6
	) AS Customer
PIVOT(count(InvoiceID)
	FOR CustomerName IN ('+ @name +')) AS  PVT
ORDER BY YEAR(PVT.InvoiceMonth), DAY(PVT.InvoiceMonth), MONTH(PVT.InvoiceMonth)'

exec (@query);