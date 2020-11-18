--SM
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Sales.SendNewInvoice 
	@CustomerID INT,
	@Firstdate date,
	@Lastdate date
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @InitDlgHandle UNIQUEIDENTIFIER; 
DECLARE @RequestMessage NVARCHAR(4000);

BEGIN TRAN

SELECT @RequestMessage = (SELECT CustomerID,  @Firstdate AS Firstdat , @Lastdate AS Lastdate
							  FROM Sales.Invoices AS Inv
							  WHERE CustomerID = @CustomerID 
							  GROUP BY  CustomerID
							  FOR XML AUTO, root('RequestMessage')); 

							  BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//WWI/SB/InitiatorService]
	TO SERVICE
	'//WWI/SB/TargetService'
	ON CONTRACT
	[//WWI/SB/Contract]
	WITH ENCRYPTION=OFF; 


	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//WWI/SB/RequestMessage]
	(@RequestMessage);
	COMMIT TRAN 
END
GO
