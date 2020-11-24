--1. Требуется написать запрос, который в результате своего выполнения формирует таблицу

select * from(
			  select substring(c.CustomerName, 16,len(c.CustomerName)-16) as CustomerName, format(i.InvoiceDate,'dd.MM.yyyy') as InvoiceMonth, il.InvoiceID
			  from Sales.Customers c
			  join Sales.Invoices i on c.CustomerID = i.CustomerID
			  join Sales.InvoiceLines il on i.InvoiceID = il.InvoiceID
		   	  where c.CustomerID between 2 and 6
			  ) as Customer
pivot(count(InvoiceID)
	for CustomerName IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) as  PVT
order by year(PVT.InvoiceMonth), day(PVT.InvoiceMonth), month(PVT.InvoiceMonth)


--
--2. Для всех клиентов с именем, в котором есть Tailspin Toys
--вывести все адреса, которые есть в таблице, в одной колонке

select * from(
				select  CustomerName,c.DeliveryAddressLine1,c.DeliveryAddressLine2,c.PostalAddressLine1,c.PostalAddressLine2
				from Sales.Customers c
				where CustomerName like 'Tailspin Toys%'
			  ) as Customer
unpivot(AddressLine
for [name] in (DeliveryAddressLine1, DeliveryAddressLine2, PostalAddressLine1, PostalAddressLine2)) as pvt


--3. В таблице стран есть поля с кодом страны цифровым и буквенным
--сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
--Пример выдачи

select * from(
				select CountryID,CountryName,IsoAlpha3Code
				,(select cast(IsoNumericCode as nvarchar(3)) from Application.Countries co where co.CountryID = c.CountryID) as IsoNumericCodes
	from Application.Countries c
	) as Country
UNPIVOT (Code for [name] IN (IsoAlpha3Code,IsoNumericCodes)) as unpvt


--Перепишите ДЗ из оконных функций через CROSS APPLY

select c.CustomerID,c.CustomerName, i.StockItemName, i.UnitPrice,i.InvoiceDate
from Sales.Customers c
cross apply (select top 2 si.StockItemName,si.StockItemID, si.UnitPrice, i.InvoiceDate
			 from Sales.Invoices i
			 join Sales.InvoiceLines il on i.InvoiceID = il.InvoiceID
			 join Warehouse.StockItems si on  il.StockItemID = si.StockItemID
			 where il.StockItemID = si.StockItemID and i.CustomerID = c.CustomerID
			 order by si.UnitPrice desc) as i
order by CustomerID, i.InvoiceDate