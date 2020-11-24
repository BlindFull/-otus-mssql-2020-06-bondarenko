--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers

insert into Sales.Customers (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy)
values (next value for Sequences.CustomerID, 'John Doe',next value for Sequences.CustomerID,6, 3256,3,3714,3714,4000,'2016-08-22',0,0,0,7,'(092) 555-0100','(092) 555-0101','','','https://www.google.com/','Shop 30','278 Jackson Street','90298','PO Box 7789','Nadaville','90273',1),
(next value for Sequences.CustomerID, 'Alice Smit',next value for Sequences.CustomerID,4,3240,3,2117,2117,1990,'2016-08-05',0,0,0,7,'(032) 555-0100','(032) 555-0101','','','https://www.google.com/','Shop 22','45  Yashin Street','90607','PO Box 78','Irmaville','90201',1),
(next value for Sequences.CustomerID, 'Marilyn Manson',next value for Sequences.CustomerID,5,3214,3,1982,1982,2913,'2016-09-15',0,0,0,7,'(123) 555-0100','(123) 555-0101','','','https://www.google.com/','Suite 12','918 Manson Street','90008','PO Box 097','Anupamville','90027',1),
(next value for Sequences.CustomerID, 'John Smit',next value for Sequences.CustomerID,7,3168,3,2983,2983,1827,'2016-10-03',0,0,0,7,'(123) 555-0100','(123) 555-0101','','','https://www.google.com/','Unit 10','829  Jordan Street','90309','PO Box 796','Baalaamjaliville','90056',1),
(next value for Sequences.CustomerID, 'Alice Doe',next value for Sequences.CustomerID,6,3138,3,1827,1827,1928,'2016-11-01',0,0,0,7,'(324) 555-0100','(123) 555-0101','','','https://www.google.com/','Shop 14','15  Bruno Street','90012','PO Box 751','Selmaville','90922',1)



--2. удалите 1 запись из Customers, которая была вами добавлена
delete from Sales.Customers
where CustomerName = 'John Doe'

--3. изменить одну запись, из добавленных через UPDATE

update Sales.Customers
set PostalAddressLine1 = 'BC street 14'
where CustomerName = 'Alice Doe'

--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть

merge Sales.Customers as target
using (select CustomerID, CustomerName, BillToCustomerID, cc.CustomerCategoryID, PrimaryContactPersonID, dm.DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,IsOnCreditHold, PaymentDays, p.PhoneNumber, p.FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, p.LastEditedBy
		from Sales.Customers c
		join Application.People p ON c.AlternateContactPersonID = p.PersonID and c.PrimaryContactPersonID = p.PersonID
		join Sales.BuyingGroups b ON c.BuyingGroupID = b.BuyingGroupID
		join Sales.CustomerCategories cc ON c.CustomerCategoryID = cc.CustomerCategoryID
		join Application.Cities ac ON c.DeliveryCityID = ac.CityID and c.PostalCityID = ac.CityID
		join Application.DeliveryMethods dm ON c.DeliveryMethodID = dm.DeliveryMethodID)
		as source(CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy)
		on (target.CustomerID = source.CustomerID)
		when matched
			then update set CustomerID = source.CustomerID,
				CustomerName = source.CustomerName,
				BillToCustomerID = source.BillToCustomerID,
				CustomerCategoryID = source.CustomerCategoryID,
				PrimaryContactPersonID = source.PrimaryContactPersonID,
				DeliveryMethodID = source.DeliveryMethodID,
				DeliveryCityID = source.DeliveryCityID,
				PostalCityID = source.PostalCityID,
				CreditLimit = source.CreditLimit,
				AccountOpenedDate = source.AccountOpenedDate,
				StandardDiscountPercentage = source.StandardDiscountPercentage,
				IsStatementSent = source.IsStatementSent,
				IsOnCreditHold = source.IsOnCreditHold,
				PaymentDays = source.PaymentDays,
				PhoneNumber = source.PhoneNumber,
				FaxNumber = source.FaxNumber,
				DeliveryRun = source.DeliveryRun,
				RunPosition = source.RunPosition,
				WebsiteURL = source.WebsiteURL,
				DeliveryAddressLine1 = source.DeliveryAddressLine1,
				DeliveryAddressLine2 = source.DeliveryAddressLine2,
				DeliveryPostalCode = source.DeliveryPostalCode,
				PostalAddressLine1 = source.PostalAddressLine1,
				PostalAddressLine2 = source.PostalAddressLine2,
				PostalPostalCode = source.PostalPostalCode,
				LastEditedBy = source.LastEditedBy
		when not matched
			then insert(CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, PostalAddressLine1, PostalAddressLine2, PostalPostalCode, LastEditedBy)
			values (source.CustomerID, source.CustomerName, source.BillToCustomerID, source.CustomerCategoryID, source.PrimaryContactPersonID, source.DeliveryMethodID, source.DeliveryCityID, source.PostalCityID, source.CreditLimit, source.AccountOpenedDate, source.StandardDiscountPercentage, source.IsStatementSent,source.IsOnCreditHold, source.PaymentDays, source.PhoneNumber, source.FaxNumber, source.DeliveryRun, source.RunPosition, source.WebsiteURL, source.DeliveryAddressLine1, source.DeliveryAddressLine2, source.DeliveryPostalCode, source.PostalAddressLine1, source.PostalAddressLine2, source.PostalPostalCode, source.LastEditedBy)
		output deleted.*,$action,inserted.*;





--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO 

SELECT @@SERVERNAME

exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.InvoiceLines" out  "C:\1\InvoiceLines15.txt" -T -w -t";" -S DESKTOP-7R10TKF\SQLEXPRESS'

-------------------------------------------------------

drop table if exists [Sales].[InvoiceLines_BulkDemo]

CREATE TABLE [Sales].[InvoiceLines_BulkDemo](
	[InvoiceLineID] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[LineProfit] [decimal](18, 2) NOT NULL,
	[ExtendedPrice] [decimal](18, 2) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Sales_InvoiceLines_BulkDemo] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA]
) ON [USERDATA]
----

	BULK INSERT [WideWorldImporters].[Sales].[InvoiceLines_BulkDemo]
				   FROM "C:\1\InvoiceLines15.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = ';',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );



select Count(*) from [Sales].[InvoiceLines_BulkDemo];

TRUNCATE TABLE [Sales].[InvoiceLines_BulkDemo];
