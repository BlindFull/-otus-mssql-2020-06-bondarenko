--Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), и не сделали ни одной продажи 04 июля 2015 года. Вывести ИД сотрудника и его полное имя. Продажи смотреть в таблице Sales.Invoices.

select p.FullName,p.PersonID
from Application.People as p
where p.IsSalesPerson = 1 and  not exists
	 (select i.SalespersonPersonID
	 from Sales.Invoices as i
	 where p.PersonID = i.SalespersonPersonID and InvoiceDate = '2015-07-04');

with salesCTE as 
(select p.FullName, p.PersonID, p.IsSalesPerson
from Application.People as p
where  p.IsSalesPerson = 1 
)

---
select p.FullName,
		p.PersonID 		
from salesCTE as p
where  not exists
	 (select i.SalespersonPersonID
	 from Sales.Invoices as i
	 where p.PersonID = i.SalespersonPersonID and InvoiceDate = '2015-07-04');


--Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. Вывести: ИД товара, наименование товара, цена

select StockItemID,
	   StockItemName,
		UnitPrice
from Warehouse.StockItems
where UnitPrice <= all ( select UnitPrice  from Warehouse.StockItems);

with MinPricecte as
(select StockItemID,
		StockItemName,
		UnitPrice
from Warehouse.StockItems
where UnitPrice <= all ( select UnitPrice  from Warehouse.StockItems))
select  s.StockItemID,
		s.StockItemName,
		s.UnitPrice
from Warehouse.StockItems as s
join MinPricecte as m
on s.StockItemID = m.StockItemID


--Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. Представьте несколько способов (в том числе с CTE).

select s.CustomerID,
       s.CustomerName,
	   t.TransactionAmount
from [Sales].[Customers] as s
	join (select top 5(CustomerID),
		          TransactionAmount             
		  from [Sales].[CustomerTransactions]
		  order by TransactionAmount desc) as t
	on s.CustomerID = t. CustomerID ;

		
with Transactioncte as 
(select top 5(CustomerID) ,
		    transactionAmount             
from [Sales].[CustomerTransactions]
order by TransactionAmount desc )		  		   
select s.CustomerID,
       s.CustomerName,
	   t.TransactionAmount
from [Sales].[Customers] as s
join Transactioncte as t
 on s.CustomerID = t. CustomerID 
 order by t.TransactionAmount


 --Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, а также имя сотрудника, который осуществлял упаковку заказов (PackedByPersonID).

select c.CityName,
        c.CityID,
		p.FullName
from [Application].[Cities] as c
join [Application].[People] as p
on c.LastEditedBy = p.personid
join [Sales].[Invoices] as i
on  p.PersonID = i.PackedByPersonID
where exists(select   top 3 ( StockItemid),
                              UnitPrice
	         from [Sales].[InvoiceLines]
	         Order by UnitPrice desc ) 
group by c.CityName,  c.CityID,	p.FullName;

--5. Объясните, что делает
SELECT Invoices.InvoiceID,Invoices.InvoiceDate,People.FullName AS SalesPersonName, SalesTotals.TotalSumm AS TotalSummByInvoice,
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		INNER HASH JOIN Sales.Orders ON OrderLines.OrderID = Orders.OrderID
		WHERE Orders.OrderId = Invoices.OrderId and Orders.PickingCompletedWhen IS NOT NULL) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN Application.People ON  People.PersonID = Invoices.SalespersonPersonID
JOIN (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
		FROM Sales.InvoiceLines
		GROUP BY InvoiceId
		HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

--Выбирает id счёта, дату составления счёта, имя продавца, коформляющим счета.
--Выбирает общую сумму оформленного заказа > 27000, и общую цену товара.
--В порядке убывания общей суммы заказа.