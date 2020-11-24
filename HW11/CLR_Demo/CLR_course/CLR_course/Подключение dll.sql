use WideWorldImporters;

---- Чистим от предыдущих экспериментов
--DROP FUNCTION IF EXISTS dbo.fn_SumFunc
--GO
--DROP PROCEDURE IF EXISTS dbo.usp_SayHello
--GO
--DROP ASSEMBLY IF EXISTS SimpleDemoAssembly
--GO

-- Включаем CLR
exec sp_configure 'show advanced options', 1;
go
reconfigure;
go

exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
go

reconfigure;
go

-- Для EXTERNAL_ACCESS или UNSAFE
alter database WideWorldImporters set trustworthy on; 

-- Подключаем dll 
create assembly DemoAssembly
from 'C:\CLR_Demo\CLR_course\CLR_course\bin\Debug\CLR_course.dll'
with permission_set = safe;  

-- DROP ASSEMBLY SimpleDemoAssembly

-- Подключить функцию из dll
create function dbo.fn_SumFunc(@Num1 int, @Num2 int)  
returns int
as external name [DemoAssembly].[CLR_course.Class1].SumFunction;
go 

-- Без namespace будет так:
-- [SimpleDemoAssembly].[DemoClass].SayHelloFunction

-- Используем функцию
select 
   dbo.fn_SumFunc(2,3) as [2+3], 
   dbo.fn_SumFunc(4,5) as [4+5]

-- Подключить процедуру из dll
create procedure dbo.usp_DemoName 
(  
    @Name nvarchar(50)
)  
AS EXTERNAL NAME  [DemoAssembly].[CLR_course.Class1].NameProcedure;  
GO 

-- Используем ХП
exec dbo.usp_DemoName @Name = 'Oksana Orlovskaya';

-- --------------------------

-- Как посмотреть зарегистрированные сборки 

-- SSMS
-- <DB> -> Programmability -> Assemblies 

-- Посмотреть подключенные сборки (SSMS: <DB> -> Programmability -> Assemblies)
SELECT * FROM sys.assemblies

-- Проверяем, что создали ХП и функцию
SELECT * FROM sys.assembly_modules

-- Посмотреть "код" сборки
-- SSMS: <DB> -> Programmability -> Assemblies -> Script Assembly as ...