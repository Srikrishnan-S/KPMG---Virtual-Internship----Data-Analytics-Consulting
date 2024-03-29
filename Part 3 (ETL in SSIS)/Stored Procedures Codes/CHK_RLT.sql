USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[CHK_RLT]    Script Date: 17-01-2024 07:08:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Check relationship in Facts and Dimensions Tables inside Warehouse Database
-- =============================================
ALTER PROC[dbo].[CHK_RLT]
AS
BEGIN
-- =============================================
-- Check Relationship Between the Tables
-- =============================================
ALTER TABLE [FACT_Transactions] WITH CHECK CHECK CONSTRAINT ALL;

END
