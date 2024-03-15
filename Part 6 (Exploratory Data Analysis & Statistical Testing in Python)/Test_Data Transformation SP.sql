USE [KPMG_Sprocket_Stagging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 19/11/2023
-- Description:	Transformed Test Data
-- =============================================
CREATE PROC [dbo].[Call_Test_Data]
AS
BEGIN
-- =============================================
-- TRANSFORM CREATE  AGE AND TENURE GROUPS
-- =============================================
SELECT [first_name]
      ,[last_name]
      ,[gender]
      ,[DOB]
	  ,DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) AS age
	  ,(CASE 
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 30 THEN '21-30'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 40 THEN '31-40'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 50 THEN '41-50'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 60 THEN '51-60'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 70 THEN '61-70'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 80 THEN '71-80'
		WHEN DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) <= 90 THEN '81-90'
		ELSE '90+' END) AS age_group
      ,[job_title]
      ,[job_industry_category]
      ,[wealth_segment]
      ,[tenure]
	  ,(CASE
		WHEN tenure <= 5 THEN '1-5'
		WHEN tenure <= 11 THEN '6-11'
		WHEN tenure <= 17 THEN '12-17'
		WHEN tenure <= 22 THEN '18-22'
		ELSE '22+' END) AS tenure_group
      ,[address]
      ,[postcode]
      ,[state]
      ,[country]
  FROM [KPMG_Sprocket_Stagging].[dbo].[TEST_CustomerList]

END
GO
