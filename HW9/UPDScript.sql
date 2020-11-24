--1
declare @x xml
set @x = ( 
  select * from openrowset
  (bulk 'C:\Users\user\Desktop\StockItems.xml',
   single_blob)
   as d)

select @x

merge Warehouse.StockItems as target
using (
select *
from openxml(@x, N'/StockItems/Item')
with ( 
	[StockItemName] nvarchar(20) '@Name',
	[SupplierID] int 'SupplierID',
	[UnitPackageID] int 'Package/UnitPackageID',
	[OuterPackageID]   int  'Package/OuterPackageID',
	[QuantityPerOuter] int 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] decimal(18,3) 'Package/TypicalWeightPerUnit',
	[LeadTimeDays] int 'LeadTimeDays',
	[IsChillerStock] bit 'IsChillerStock',
	[TaxRate] decimal(18,3) 'TaxRate',
	[UnitPrice] decimal(18,2) 'UnitPrice'
))  as source on target.StockItemName=source.StockItemName
when matched 
then update set 
	target.SupplierID=source.SupplierId,
	target.UnitPackageID=source.UnitPackageID,
	target.OuterPackageID=source.OuterPackageID,
	target.QuantityPerOuter=source.QuantityPerOuter,
	target.TypicalWeightPerUnit=source.TypicalWeightPerUnit,
	target.LeadTimeDays=source.LeadTimeDays,
	target.IsChillerStock=source.IsChillerStock,
	target.TaxRate=source.TaxRate,
	target.UnitPrice=source.UnitPrice
when not matched 
then insert([StockItemName],[SupplierID],[UnitPackageID],[OuterPackageID],[QuantityPerOuter],[TypicalWeightPerUnit],[LeadTimeDays],[IsChillerStock],[TaxRate],[UnitPrice],[LastEditedBy]) 
values (source.StockItemName, source.SupplierId,source.UnitPackageID, source.OuterPackageID,source.QuantityPerOuter, source.TypicalWeightPerUnit,source.LeadTimeDays,source.IsChillerStock, source.TaxRate,source.UnitPrice,1)
output  deleted.*,$action, inserted.*;
--4
select a.StockItemID, a.StockItemName, b.[value], string_agg(c.[value], ', ')
from Warehouse.StockItems a
cross apply openjson(a.CustomFields, '$.Tags') as b
cross apply openjson(json_query(a.CustomFields, '$.Tags')) as c
where b.value = 'Vintage'
group by a.StockItemID, a.StockItemName, b.[value];

--5
declare @query nvarchar(max)
declare @Name nvarchar(max)

select @Name =  stuff(( select distinct '],[' + CustomerName from Sales.Customers 
    for xml path('') ),1,2,'') + ']';

SET @query = 'select  Date, ' + @Name + ' from 
(select c.CustomerName,
        convert(varchar, InvoiceDate, 104) as Date,
	    i.InvoiceID
from Sales.Customers as c
join Sales.Invoices as i
on c.CustomerID = i.CustomerID) as t
pivot (count (InvoiceID) 
for  CustomerName in (' + @Name + ')) as pvt
order by Date'


exec (@query);