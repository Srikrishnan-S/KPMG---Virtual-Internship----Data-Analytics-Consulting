USE [KPMG_Sprocket_Stagging]
GO
/****** Object:  StoredProcedure [dbo].[TRUNCATE_Raw_Table]    Script Date: 17-01-2024 07:03:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 19/11/2023
-- Description:	Truncate Table Before Load
-- =============================================
ALTER PROC [dbo].[TRUNCATE_Raw_Table]
AS
BEGIN
-- =============================================
-- TRUNCATE RAW TABLES BLOCK
-- =============================================
	IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.RAW_Transactions') IS NOT NULL
		TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[RAW_Transactions]
	IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.RAW_CustomerDemographics') IS NOT NULL
		TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[RAW_CustomerDemographics]
	IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.RAW_CustomerAddress') IS NOT NULL
		TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[RAW_CustomerAddress]
	IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.RAW_NewCustomerList') IS NOT NULL
		TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[RAW_NewCustomerList]
END
