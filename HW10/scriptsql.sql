--Написать функцию возвращающую Клиента с набольшей суммой покупки.

create or alter function [Reports].maxSum()
returns int
as
BEGIN 
    return (select TOP 1 FIRST_VALUE(i.CustomerID) OVER(ORDER BY sum(il.Quantity * il.UnitPrice) DESC) 
	         from Sales.Invoices i 
			     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
		    group by i.CustomerID);
END
GO

SELECT [Reports].maxSum()


--2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
create or alter procedure [Reports].getSum (@CustomerID int)
as
begin
    set nocount on; 

    select c.CustomerID,
	       c.CustomerName,
		   sum(il.Quantity * il.UnitPrice) SumSale,
		   max(i.InvoiceDate) LastInvoiceDate
	  from Sales.Customers c
      left join Sales.Invoices i on i.CustomerID = c.CustomerID
      left join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	where c.CustomerID = @CustomerID 
	group by c.CustomerID, c.CustomerName;
	return;
end
go

declare @CustomerId int = [Reports].maxSum();
exec [Reports].getSum @CustomerId
go

--4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла.

create or alter function [Reports].SaleInfo( @CustomerID int)
returns table  
as
RETURN (
    select sum(il.Quantity * il.UnitPrice) SumSale,
		   max(i.InvoiceDate) LastInvoiceDate
	  from Sales.Invoices i  
      join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
	where i.CustomerID= @CustomerID 
	);  
GO
 
--1
select c.CustomerID,
       c.CustomerName,
	   (select top 1 SumSale from [Reports].SaleInfo(c.CustomerID)) SumSale
  from Sales.Customers c

--2
select c.CustomerID,
       c.CustomerName,
	   i.SumSale,
	   i.LastInvoiceDate
  from Sales.Customers c
  outer apply [Reports].SaleInfo(c.CustomerID) i