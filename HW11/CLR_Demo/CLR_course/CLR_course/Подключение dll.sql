use WideWorldImporters;

--DROP FUNCTION IF EXISTS dbo.fn_SumFunc
--GO
--DROP PROCEDURE IF EXISTS dbo.usp_SayHello
--GO
--DROP ASSEMBLY IF EXISTS SimpleDemoAssembly
--GO

exec sp_configure 'show advanced options', 1;
go
reconfigure;
go

exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
go

reconfigure;
go


alter database WideWorldImporters set trustworthy on; 


create assembly DemoAssembly
from 'C:\CLR_Demo\CLR_course\CLR_course\bin\Debug\CLR_course.dll'
with permission_set = safe;  

-- DROP ASSEMBLY SimpleDemoAssembly

create function dbo.fn_SumFunc(@Num1 int, @Num2 int)  
returns int
as external name [DemoAssembly].[CLR_course.Class1].SumFunction;
go 

select 
   dbo.fn_SumFunc(2,3) as [2+3], 
   dbo.fn_SumFunc(4,5) as [4+5]

create procedure dbo.usp_DemoName 
(  
    @Name nvarchar(50)
)  
AS EXTERNAL NAME  [DemoAssembly].[CLR_course.Class1].NameProcedure;  
GO 

-- Используем ХП
exec dbo.usp_DemoName @Name = 'vlad';

-- --------------------------

