use WideWorldImporters;

SELECT *
FROM Sales.Invoices
WHERE CustomerID = 22;

--Send message
EXEC Sales.SendNewInvoice
	@CustomerID = 22, @Firstdate='2013-07-01', @Lastdate='2014-07-18';

SELECT CAST(message_body AS XML),*
FROM dbo.InitiatorQueueWWI;

SELECT CAST(message_body AS XML),*
FROM dbo.TargetQueueWWI;

EXEC Sales.GetNewInvoice;

EXEC Sales.ConfirmInvoice;

SELECT * FROM HomeWork

SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;
