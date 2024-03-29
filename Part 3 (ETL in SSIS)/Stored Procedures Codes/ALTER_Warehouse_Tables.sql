USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[ALTER_Warehouse_Tables]    Script Date: 17-01-2024 07:07:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Estabilishing relationship in Facts and Dimensions Tables inside Warehouse Database
-- =============================================
ALTER PROC [dbo].[ALTER_Warehouse_Tables]
AS
BEGIN
-- =============================================
-- ALTER TABLE FK
-- =============================================
ALTER TABLE [FACT_Transactions] 
WITH CHECK ADD CONSTRAINT [FK_FACT_Transactions_Customers] 
FOREIGN KEY([customer_id])
REFERENCES [DIM_Customers] ([customer_id])

ALTER TABLE [FACT_Transactions] 
CHECK CONSTRAINT [FK_FACT_Transactions_Customers]

ALTER TABLE [FACT_Transactions] 
WITH CHECK ADD CONSTRAINT [FK_FACT_Transactions_Address] 
FOREIGN KEY([customer_id])
REFERENCES [DIM_Address] ([customer_id])

ALTER TABLE [FACT_Transactions] 
CHECK CONSTRAINT [FK_FACT_Transactions_Address]

ALTER TABLE [FACT_Transactions] 
WITH CHECK ADD CONSTRAINT [FK_DIM_TransactionsCustomerSegments] 
FOREIGN KEY([customer_id])
REFERENCES [DIM_CustomerSegments] ([customer_id])

ALTER TABLE [FACT_Transactions] 
CHECK CONSTRAINT [FK_DIM_TransactionsCustomerSegments]

ALTER TABLE [FACT_Transactions] 
WITH CHECK ADD CONSTRAINT [FK_FACT_TransactionsDate] 
FOREIGN KEY ([transaction_id]) 
REFERENCES [DIM_TransactionDate] ([transaction_id])

ALTER TABLE [FACT_Transactions] 
CHECK CONSTRAINT [FK_FACT_TransactionsDate]

ALTER TABLE [FACT_Transactions] 
WITH CHECK ADD CONSTRAINT [FK_FACT_TransactionsProduct] 
FOREIGN KEY ([transaction_id]) 
REFERENCES [DIM_SoldProduct] ([transaction_id])

ALTER TABLE [FACT_Transactions] 
CHECK CONSTRAINT [FK_FACT_TransactionsProduct]

-- =============================================
-- END
-- =============================================



END
