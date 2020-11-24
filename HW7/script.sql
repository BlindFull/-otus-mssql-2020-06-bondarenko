--1. Напишите запрос с временной таблицей и перепишите его с табличной переменной.

drop table if exists #temp
; with cte as(
	select distinct i.InvoiceID,
	c.CustomerName,
	i.InvoiceDate,
	(select sum(ct.TransactionAmount)
	from Sales.Invoices i1
	join Sales.CustomerTransactions ct on i1.InvoiceID = ct.InvoiceID
	where month(i1.InvoiceDate) = month(i.InvoiceDate) and InvoiceDate >= '2015.01.01'
	group by month(i1.InvoiceDate)) as Progressive_Total
from Sales.Invoices i
join Sales.Customers c ON i.CustomerID = c.CustomerID
where InvoiceDate >= '2015.01.01'
)
select * into #temp from cte
select * from #temp order by InvoiceID 


declare @t table
(
	InvoiceID int not null,
	CustomerName nvarchar(100) not null,
	InvoiceDate date not null,
	Progressive_Total float not null
)
; with cte as(
select distinct i.InvoiceID,
	c.CustomerName,
	i.InvoiceDate,
	(select sum(ct.TransactionAmount)
	from Sales.Invoices i1
	join Sales.CustomerTransactions ct on i1.InvoiceID = ct.InvoiceID
	where month(i1.InvoiceDate) = month(i.InvoiceDate) and InvoiceDate >= '2015.01.01'
	group by month(i1.InvoiceDate)
	) as Progressive_Total
from Sales.Invoices i
join Sales.Customers c on i.CustomerID = c.CustomerID
where InvoiceDate >= '2015.01.01'
)
insert into @t select * from cte
select * from @t order by InvoiceID


--2.

set statistics time on;

select distinct i.InvoiceID,c.CustomerName,i.InvoiceDate,(sum(ct.TransactionAmount) over(order by month(InvoiceDate))) as Progressive_Total
from Sales.Invoices i
join Sales.CustomerTransactions ct on i.InvoiceID = ct.InvoiceID
join Sales.Customers c on i.CustomerID = c.CustomerID
where InvoiceDate >= '2015.01.01'
order by InvoiceID;
set statistics time on;


select distinct i.InvoiceID,c.CustomerName,i.InvoiceDate,
	(select sum(ct.TransactionAmount)
	 from Sales.Invoices i1
	 join Sales.CustomerTransactions ct on i1.InvoiceID = ct.InvoiceID
	 where month(i1.InvoiceDate) = month(i.InvoiceDate) and InvoiceDate >= '2015.01.01'
	 group by month(i1.InvoiceDate)
	 ) as Progressive_Total
from Sales.Invoices i
join Sales.Customers c on i.CustomerID = c.CustomerID
where InvoiceDate >= '2015.01.01'
order by InvoiceID;


--Оконная функция выполняется быстрее.


--3. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)
select * from
	(	
		select InvoiceDate, StockItemName, Quantity,row_number() over(partition by month(InvoiceDate) order by Quantity desc, InvoiceDate) as quan_num
		from Sales.Invoices i
		join Sales.InvoiceLines il on i.InvoiceID = il.InvoiceID
		join Warehouse.StockItems si on il.StockItemID = si.StockItemID
		where year(InvoiceDate) = '2016'
	) as t
where quan_num <= 2
order by InvoiceDate


--4. Функции одним запросом

select StockItemID, StockItemName, Brand, UnitPrice,
	row_number() over(partition by left(StockItemName,1) order by StockItemName) as numb,
	count(StockItemName) over() as total_num,
	count(StockItemName) over(partition by left(StockItemName,1)) as total_num_name,
	lead(StockItemID) over(order by StockItemName) as [lead],
	lag(StockItemID) over(order by StockItemName) as [lag],
	lag(StockItemName,2,'No items') over(order by StockItemName) as lag_two,
	ntile(30) over(order by TypicalWeightPerUnit) as [group]
from Warehouse.StockItems
order by StockItemName

--5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал

select * from 
			(
				select o.SalespersonPersonID,p.FullName as SalesPersonName,o.CustomerID,c.CustomerName as CustomerName,o.OrderDate,ol.Quantity*ol.UnitPrice as Total,row_number() over (partition by o.SalespersonPersonID order by o.OrderDate desc
			) as lastsales
from Sales.Orders as o
join Sales.OrderLines as ol on o.OrderID=ol.OrderID
join Application.People as p on o.SalespersonPersonID=p.PersonID
join Sales.Customers as c on c.CustomerID=o.CustomerID
) as t
where t.lastsales = 1;

--6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал

select * from
			(
				select i.CustomerID, c.CustomerName, si.StockItemName,si.UnitPrice, i.InvoiceDate, 
					 row_number() over(partition by i.CustomerID order by si.UnitPrice desc) as num
				from Sales.InvoiceLines il
				join Sales.Invoices i on  il.InvoiceID = i.InvoiceID
				join Sales.Customers c on i.CustomerID = c.CustomerID
				join Warehouse.StockItems si on il.StockItemID = si.StockItemID
			) as tab
where num <= 2


--7.Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов и последний заказ был не позднее апреля 2016.

select distinct top 10 I.CustomerID, C.CustomerName
from Sales.Invoices I
join Sales.Customers C on I.CustomerID = C.CustomerID
where 30 < (select count(OrderID)
			from Sales.Invoices i
			where I.InvoiceID = i.InvoiceID) 
and (select top 1 InvoiceDate
		from Sales.Invoices inv
		where inv.CustomerID = I.CustomerID
		order by InvoiceDate desc) >= '2016-04-01'