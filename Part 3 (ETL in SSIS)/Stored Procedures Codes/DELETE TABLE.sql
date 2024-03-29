USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[DELETE TABLE]    Script Date: 17-01-2024 07:09:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[DELETE TABLE]
AS
BEGIN
--==================================
-- DELETE STATEMENT
--==================================
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers]
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address]
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments]
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate]
DELETE FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct]

END
