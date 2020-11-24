--Все товары, в названии которых есть "urgent" или название начинается с "Animal". Вывести: ИД товара, наименование товара.
select StockItemID, StockItemName 
from Warehouse.StockItems 
where StockItemName like '%urgent%' or StockItemName like'Animal%'

--Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
--Сделать через JOIN, с подзапросом задание принято не будет.
--Вывести: ИД поставщика, наименование поставщика.

select top 10 t1.SupplierID, t1.SupplierName from Purchasing.Suppliers t1 
left join  Purchasing.PurchaseOrders t2  on t1.SupplierID = t2.SupplierID
where t2.PurchaseOrderID is null

-- Заказы (Orders) с ценой товара более 100$ либо количеством единиц товара более 20 штук и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
--Вывести:
--* OrderID
--* дату заказа в формате ДД.ММ.ГГГГ
--* название месяца, в котором была продажа
--* номер квартала, к которому относится продажа
--* треть года, к которой относится дата продажи (каждая треть по 4 месяца)
--* имя заказчика (Customer)
--Добавьте вариант этого запроса с постраничной выборкой, пропустив первую 1000 и отобразив следующие 100 записей. 
--Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

select o.OrderID , 
       convert( varchar(16), orderdate, 104) as DATEORDER,
       datename( month, orderdate) as month , 
       datepart( qq, orderdate ) as Quarter,
       ceiling (convert(float, month(orderdate))/4) as ThirdYear,
       c.CustomerName
from  Sales.Orders as o  
join  Sales.OrderLines as  l  on o.OrderId = l.OrderID
join   Sales.Customers as c  on c.CustomerID = o.CustomerID
where (UnitPrice > 100  or Quantity > 20 ) and o.PickingCompletedWhen is not null
order by ThirdYear,  Quarter, DATEORDER
offset 1000 rows fetch next 100 rows only

--Заказы поставщикам (Purchasing.Suppliers), которые были исполнены в январе 2014 года с доставкой Air Freight или Refrigerated Air Freight (DeliveryMethodName).
--Вывести:
--* способ доставки (DeliveryMethodName)
--* дата доставки
--* имя поставщика
--* имя контактного лица принимавшего заказ (ContactPerson)

select DeliveryMethodName,convert(varchar, OrderDate, 104), SupplierName, FullName
from Purchasing.PurchaseOrders p 
join Application.DeliveryMethods d on p.DeliveryMethodID = d.DeliveryMethodID
join Purchasing.Suppliers s on p.SupplierID = s.SupplierID
join Application.People pl on p.ContactPersonID = pl.PersonID
where (OrderDate between '01.01.2014' and '31.01.2014') and (DeliveryMethodName = 'Air Freight' or DeliveryMethodName = 'Refrigerated Air Freight')


--Десять последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPerson).

select top 10 orderdate, fullname, CustomerName
from  sales.orders as o
join Application.People as a on a.personid = o.SalespersonPersonid
join sales.customers as c on c.customerid = o.customerid 
order by orderdate desc

-- Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g. Имя товара смотреть в Warehouse.StockItems.

select c.customerid,  CustomerName, phonenumber
from sales.customers c
join sales.orders o on c.customerID = o.customerID
join  sales.orderlines o1 on o1.orderID = o.orderID
join Warehouse.StockItems s on s.stockitemid = o1.stockitemid
where stockitemname = 'Chocolate frogs 250g'