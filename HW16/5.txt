--gm

CREATE TABLE HomeWork(  
CustomerID INT,
CountOrder INT,
F_DATE date,
L_DATE date);

CREATE PROCEDURE Sales.GetNewInvoice
AS
BEGIN

DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, 
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@CustomerID INT,
	        @Firstdate date,
			@Lastdate date,
			@xml XML; 


	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message;

SET @xml = CAST(@Message AS XML);

SELECT @CustomerID = R.Iv.value('@CustomerID','INT'),
       @Firstdate = R.Iv.value('@Firstdate','Date'),
	   @Lastdate = R.Iv.value('@Lastdate','Date')
FROM @xml.nodes('/RequestMessage/Inv') as R(Iv);


		INSERT INTO HomeWork (CustomerID, CountOrder, F_DATE, L_DATE)
		VALUES( @CustomerID,
		( SELECT Count(Orderid) FROM Sales.Invoices WHERE CustomerID =  @CustomerID and  (Invoicedate between @Firstdate and @Lastdate )), 
		@Firstdate,@Lastdate)
		
	

SELECT @Message AS ReceivedRequestMessage, @MessageType;

IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received  </ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;--çàêðîåì äèàëîã ñî ñòîðîíû òàðãåòà
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; --â ëîã

	COMMIT TRAN;
END