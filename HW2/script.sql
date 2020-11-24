--��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal". �������: �� ������, ������������ ������.
select StockItemID, StockItemName 
from Warehouse.StockItems 
where StockItemName like '%urgent%' or StockItemName like'Animal%'

--����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders).
--������� ����� JOIN, � ����������� ������� ������� �� �����.
--�������: �� ����������, ������������ ����������.

select top 10 t1.SupplierID, t1.SupplierName from Purchasing.Suppliers t1 
left join  Purchasing.PurchaseOrders t2  on t1.SupplierID = t2.SupplierID
where t2.PurchaseOrderID is null

-- ������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
--�������:
--* OrderID
--* ���� ������ � ������� ��.��.����
--* �������� ������, � ������� ���� �������
--* ����� ��������, � �������� ��������� �������
--* ����� ����, � ������� ��������� ���� ������� (������ ����� �� 4 ������)
--* ��� ��������� (Customer)
--�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������. 
--���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).

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

--������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� � ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
--�������:
--* ������ �������� (DeliveryMethodName)
--* ���� ��������
--* ��� ����������
--* ��� ����������� ���� ������������ ����� (ContactPerson)

select DeliveryMethodName,convert(varchar, OrderDate, 104), SupplierName, FullName
from Purchasing.PurchaseOrders p 
join Application.DeliveryMethods d on p.DeliveryMethodID = d.DeliveryMethodID
join Purchasing.Suppliers s on p.SupplierID = s.SupplierID
join Application.People pl on p.ContactPersonID = pl.PersonID
where (OrderDate between '01.01.2014' and '31.01.2014') and (DeliveryMethodName = 'Air Freight' or DeliveryMethodName = 'Refrigerated Air Freight')


--������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).

select top 10 orderdate, fullname, CustomerName
from  sales.orders as o
join Application.People as a on a.personid = o.SalespersonPersonid
join sales.customers as c on c.customerid = o.customerid 
order by orderdate desc

-- ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.

select c.customerid,  CustomerName, phonenumber
from sales.customers c
join sales.orders o on c.customerID = o.customerID
join  sales.orderlines o1 on o1.orderID = o.orderID
join Warehouse.StockItems s on s.stockitemid = o1.stockitemid
where stockitemname = 'Chocolate frogs 250g'