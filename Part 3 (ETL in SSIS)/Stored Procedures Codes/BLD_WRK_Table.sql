USE [KPMG_Sprocket_Stagging]
GO
/****** Object:  StoredProcedure [dbo].[BLD_WRK_Table]    Script Date: 17-01-2024 07:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 19/11/2023
-- Description:	Create WRK Tables and Transfer Datas from RAW-->WRK Tables
-- =============================================
ALTER PROC [dbo].[BLD_WRK_Table]
AS
BEGIN
-- =============================================
-- DROP WRK TRANSACTION TABLE BLOCK
-- =============================================
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.WRK_Transactions') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[WRK_Transactions]

-- =============================================
-- CREATE WRK TRANSACTION TABLE BLOCK
-- =============================================
CREATE TABLE [WRK_Transactions]
(
	[transaction_id]							VARCHAR(1000)
    ,[transaction_customer_id]					VARCHAR(1000)
	,[demographics_customer_id]					VARCHAR(1000)
    ,[first_name]								VARCHAR(1000)
    ,[last_name]								VARCHAR(1000)
    ,[gender]									VARCHAR(1000)
    ,[DOB]										VARCHAR(1000)
    ,[job_title]								VARCHAR(1000)
    ,[job_industry_category]					VARCHAR(1000)
    ,[wealth_segment]							VARCHAR(1000)
    ,[tenure]									VARCHAR(1000)
	,[address_customer_id]						VARCHAR(1000)
    ,[address]									VARCHAR(1000)
    ,[postcode]									VARCHAR(1000)
    ,[state]									VARCHAR(1000)
    ,[country]									VARCHAR(1000)
    ,[product_first_sold_date]					VARCHAR(1000)
    ,[product_id]								VARCHAR(1000)
    ,[online_order]								VARCHAR(1000)
    ,[order_status]								VARCHAR(1000)
    ,[brand]									VARCHAR(1000)
    ,[product_line]								VARCHAR(1000)
    ,[product_class]							VARCHAR(1000)
    ,[product_size]								VARCHAR(1000)
    ,[transaction_date]							VARCHAR(1000)
    ,[list_price]								VARCHAR(1000)
    ,[standard_cost]							VARCHAR(1000)

	)

-- =============================================
-- TRUNCATE WRK TRANSACTION TABLE BLOCK
-- =============================================
TRUNCATE TABLE [WRK_Transactions]

-- =============================================
-- INSERT INTO WRK TRANSACTION TABLE BLOCK
-- =============================================
INSERT INTO [WRK_Transactions]
(
	[transaction_id]
    ,[transaction_customer_id]
	,[demographics_customer_id]
    ,[first_name]
    ,[last_name]
    ,[gender]
    ,[DOB]
    ,[job_title]
    ,[job_industry_category]
    ,[wealth_segment]
    ,[tenure]
	,[address_customer_id]
    ,[address]
    ,[postcode]
    ,[state]
    ,[country]
    ,[product_first_sold_date]
    ,[product_id]
    ,[online_order]
    ,[order_status]
    ,[brand]
    ,[product_line]
    ,[product_class]
    ,[product_size]
    ,[transaction_date]
    ,[list_price]
    ,[standard_cost]

	)

SELECT T.[transaction_id]
      ,T.[customer_id]
	  ,D.[customer_id]
      ,D.[first_name]
      ,D.[last_name]
      ,D.[gender]
      ,D.[DOB]
      ,D.[job_title]
      ,D.[job_industry_category]
      ,D.[wealth_segment]
      ,D.[tenure]
	  ,A.[customer_id]
      ,A.[address]
      ,A.[postcode]
      ,A.[state]
      ,A.[country]
      ,T.[product_first_sold_date]
      ,T.[product_id]
      ,T.[online_order]
      ,T.[order_status]
      ,T.[brand]
      ,T.[product_line]
      ,T.[product_class]
      ,T.[product_size]
      ,T.[transaction_date]
      ,T.[list_price]
      ,T.[standard_cost]
FROM [KPMG_Sprocket_Stagging].[dbo].[RAW_Transactions] T
FULL OUTER JOIN [KPMG_Sprocket_Stagging].[dbo].[RAW_CustomerDemographics] D
ON T.[customer_id] = D.[customer_id]
FULL OUTER JOIN [KPMG_Sprocket_Stagging].[dbo].[RAW_CustomerAddress] A
ON T.[customer_id] = A.[customer_id]

-- =============================================
-- DROP TEST CUSTOMER TABLE BLOCK
-- =============================================
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.TEST_CustomerList') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[TEST_CustomerList]

-- =============================================
-- CREATE TEST CUSTOMER TABLE BLOCK
-- =============================================
CREATE TABLE [TEST_CustomerList]
( 
	[row_number]				INT IDENTITY(1,1)
    ,[first_name]				VARCHAR(255)
    ,[last_name]				VARCHAR(255)
    ,[gender]					VARCHAR(7)
    ,[DOB]						DATE
    ,[job_title]				VARCHAR(100)
    ,[job_industry_category]	VARCHAR(50)
    ,[wealth_segment]			VARCHAR(50)
    ,[tenure]					INT
    ,[address]					VARCHAR(500)
    ,[postcode]					VARCHAR(10)
    ,[state]					VARCHAR(50)
    ,[country]					VARCHAR(50)

	)

-- =============================================
-- TRUNCATE TEST CUSTOMER TABLE BLOCK
-- =============================================
TRUNCATE TABLE [TEST_CustomerList]

-- =============================================
-- INSERT INTO TEST CUSTOMER TABLE BLOCK
-- =============================================
INSERT INTO [TEST_CustomerList]
(
	[first_name]
    ,[last_name]
    ,[gender]
    ,[DOB]
    ,[job_title]
    ,[job_industry_category]
    ,[wealth_segment]
    ,[tenure]
    ,[address]
    ,[postcode]
    ,[state]
    ,[country]
	
	)

SELECT [first_name]
      ,[last_name]
      ,[gender]
      ,[DOB]
      ,[job_title]
      ,[job_industry_category]
      ,[wealth_segment]
      ,[tenure]
      ,[address]
      ,[postcode]
      ,[state]
      ,[country]
  FROM [KPMG_Sprocket_Stagging].[dbo].[RAW_NewCustomerList]

-- =============================================
-- TRUNCATE MODEL TRANSACTION TABLE(BEFORE LOAD) BLOCK
-- =============================================
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.MDL_Transactions') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[MDL_Transactions]

-- =============================================
-- CREATE MODEL TRANSACTION TABLE(BEFORE LOAD) BLOCK
-- =============================================
CREATE TABLE [MDL_Transactions]
(
	[transaction_id]							VARCHAR(1000)
    ,[transaction_customer_id]					VARCHAR(1000)
	,[demographics_customer_id]					VARCHAR(1000)
    ,[first_name]								VARCHAR(1000)
    ,[last_name]								VARCHAR(1000)
    ,[gender]									VARCHAR(1000)
    ,[DOB]										VARCHAR(1000)
    ,[job_title]								VARCHAR(1000)
    ,[job_industry_category]					VARCHAR(1000)
    ,[wealth_segment]							VARCHAR(1000)
    ,[tenure]									VARCHAR(1000)
	,[address_customer_id]						VARCHAR(1000)
    ,[address]									VARCHAR(1000)
    ,[postcode]									VARCHAR(1000)
    ,[state]									VARCHAR(1000)
    ,[country]									VARCHAR(1000)
    ,[product_first_sold_date]					VARCHAR(1000)
    ,[product_id]								VARCHAR(1000)
    ,[online_order]								VARCHAR(1000)
    ,[order_status]								VARCHAR(1000)
    ,[brand]									VARCHAR(1000)
    ,[product_line]								VARCHAR(1000)
    ,[product_class]							VARCHAR(1000)
    ,[product_size]								VARCHAR(1000)
    ,[transaction_date]							VARCHAR(1000)
    ,[list_price]								VARCHAR(1000)
    ,[standard_cost]							VARCHAR(1000)
)


-- =============================================
-- COLUMNS with NO INFORMATION
-- =============================================
-- past_3_years_bike_related_purchases from CustomerDemographics Table & NewCustomerList Table.
-- property_valuation from CustomerAddress Table & NewCustomerList Table.
-- Column17, Column18, Column19, Column20, Column21, Rank, Value in NewCustomerList Table.

-- =============================================
-- COLUMNS NOT REQUIRED FOR ANALYSIS
-- =============================================
-- deceased_indicator from CustomerDemographics Table & NewCustomerList Table (since we are including only active customers for our analysis)
-- owns_car from CustomerDemographics Table & NewCustomerList Table (they dont make significance difference in the analysis)

-- =============================================
-- All these eliminated columns improves the optimization of Data Warehouse, inour case its SQL Server Database.
-- =============================================
-- =============================================
-- END
-- =============================================
END
