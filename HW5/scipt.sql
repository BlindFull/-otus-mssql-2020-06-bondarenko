--Посчитать среднюю цену товара, общую сумму продажи по месяцам
--Вывести:
--* Год продажи
--* Месяц продажи
--* Средняя цена за месяц по всем товарам
--* Общая сумма продаж

select datepart(yy,(i.InvoiceDate)) as 'year',
	   datename(month, i.InvoiceDate) as 'month',
	   avg(l.UnitPrice) as 'average price',
	   sum(l.UnitPrice) as 'total sales'
from Sales.Invoices as i
join Sales.InvoiceLines as l on i.InvoiceID = l.InvoiceID
group by datepart(yy, i.InvoiceDate), datename(month, i.InvoiceDate)
order by datepart(yy, i.InvoiceDate), datename(month, i.InvoiceDate)



-- Отобразить все месяцы, где общая сумма продаж превысила 10 000
--Вывести:
--* Год продажи
--* Месяц продажи
--* Общая сумма продаж

select datepart(yy,(i.InvoiceDate)) as 'year',
	   datename(month, i.InvoiceDate) as 'month',
	   sum(l.UnitPrice) as 'total sales'
from Sales.Invoices as i
join Sales.InvoiceLines as l on i.InvoiceID = l.InvoiceID
group by datepart(yy, i.InvoiceDate),
		 datename(month, i.InvoiceDate)
having sum(l.UnitPrice) > 10000
order by datepart(yy, i.InvoiceDate),
		 datename(month, i.InvoiceDate)


--Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц.
--Группировка должна быть по году, месяцу, товару.
--Вывести:
--* Год продажи
--* Месяц продажи
--* Наименование товара
--* Сумма продаж
--* Дата первой продажи
--* Количество проданного

select datepart(yy,(i.InvoiceDate)) as 'year',
	   datename(month, i.InvoiceDate) as 'mosnth',
	   w.StockItemName,
	   sum(l.UnitPrice) as 'sales amount',
	   sum(l.Quantity) as 'quantity sold',
	   min(i.InvoiceDate) as 'first day of sale'
from Sales.Invoices as i
join Sales.InvoiceLines as l on i.InvoiceID = l.InvoiceID
join Warehouse.StockItems as w on l.StockItemID = w.StockItemID
group by datepart(yy,i.InvoiceDate),
		 datename(month, i.InvoiceDate),
		 w.StockItemName
having sum(l.Quantity) < 50
order by datepart(yy, i.InvoiceDate),
		 datename(month, i.InvoiceDate)


--Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную

;with recurse(employeeid, [name], title, employeelevel, managerid)
as
(
	select
		m.employeeid as id,
		(select m.firstname + ' ' + m.Lastname) as [name],
		m.title as title,
		1 as employelevel,
		m.managerid
	from dbo.MyEmployees m
	where m.ManagerID is null
	union all
	select
		m.employeeid as id,
		(select m.firstname + ' ' + m.lastname) as [name],
		m.title as title,
		(select rc.employeelevel + 1) as employelevel,
		m.managerid
	from dbo.myemployees m
	join recurse rc on rc.employeeid = m.managerid
)
select
	rm.employeeid,
	cast(replicate(' | ', rm.employeelevel - 1) + rm.[name] as varchar(100)) as [name],
	rm.title,
	rm.employeelevel
from recurse rm