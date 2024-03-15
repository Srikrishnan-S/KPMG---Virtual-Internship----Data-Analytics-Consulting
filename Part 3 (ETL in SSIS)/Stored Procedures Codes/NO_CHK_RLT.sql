USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[NO_CHK_RLT]    Script Date: 17-01-2024 07:07:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Check relationship in Facts and Dimensions Tables inside Warehouse Database
-- =============================================
ALTER PROC[dbo].[NO_CHK_RLT]
AS
BEGIN
-- =============================================
-- Check Relationship Between the Tables
-- =============================================
ALTER TABLE [FACT_Transactions] NOCHECK CONSTRAINT ALL;

END
