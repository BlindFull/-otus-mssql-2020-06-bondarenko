--ENABLE

USE master
GO
ALTER DATABASE WideWorldImporters SET SINGLE_USER WITH ROLLBACK IMMEDIATE

USE master
ALTER DATABASE WideWorldImporters
SET ENABLE_BROKER;


ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON; 
select DATABASEPROPERTYEX ('WideWorldImporters','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';

 
ALTER AUTHORIZATION    
   ON DATABASE::WideWorldImporters TO [sa];

ALTER DATABASE WideWorldImporters SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO