USE [KPMG_Sprocket_Stagging]
GO
/****** Object:  StoredProcedure [dbo].[BLD_Fact_Dim_Tables]    Script Date: 17-01-2024 07:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Create Facts and Dimensions Tables from the MDL_Transactions
-- =============================================
ALTER PROC [dbo].[BLD_Fact_Dim_Tables]
AS
BEGIN
-- =============================================
-- DROP DIM & FACTS TABLES BLOCK
-- =============================================
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.FACT_Transactions') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[FACT_Transactions]
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.DIM_Customers') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_Customers]
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.DIM_CustomerSegments') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_CustomerSegments]
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.DIM_Address') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_Address]
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.DIM_TransactionDate') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_TransactionDate]
IF OBJECT_ID('KPMG_Sprocket_Stagging.dbo.DIM_SoldProduct') IS NOT NULL
	DROP TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_SoldProduct]

-- =============================================
-- CREATE DIM & FACT TABLES BLOCK
-- =============================================
CREATE TABLE [DIM_Customers] 
(
    [customer_id] INT PRIMARY KEY NOT NULL ,
    [first_name] VARCHAR(255)  NOT NULL ,
    [last_name] VARCHAR(255)  NOT NULL ,
    [gender] VARCHAR(10)  NOT NULL ,
    [DOB] DATE  NOT NULL ,
    [age] INT  NOT NULL ,
    [job_title] VARCHAR(100)  NOT NULL ,
    [job_industry_category] VARCHAR(100)  NOT NULL ,

)

CREATE TABLE [DIM_Address] 
(
    [customer_id] INT PRIMARY KEY NOT NULL ,
    [address] VARCHAR(500)  NOT NULL ,
    [postcode] VARCHAR(10)  NOT NULL ,
    [state] VARCHAR(50)  NOT NULL ,
    [country] VARCHAR(50)  NOT NULL ,

)

CREATE TABLE [DIM_CustomerSegments] 
(
    [customer_id] INT PRIMARY KEY NOT NULL ,
    [wealth_segments] VARCHAR(50)  NOT NULL ,
    [tenure] INT  NOT NULL ,

)

CREATE TABLE [DIM_TransactionDate] 
(
	[transaction_id] INT PRIMARY KEY NOT NULL,
    [transaction_date] DATE  NOT NULL ,
    [transaction_year] INT  NOT NULL ,
    [transaction_month_name] VARCHAR(50)  NOT NULL ,
    [transaction_month_number] INT  NOT NULL ,
    [transaction_quarter] INT  NOT NULL ,

)

CREATE TABLE [DIM_SoldProduct] 
(
	[transaction_id] INT PRIMARY KEY NOT NULL,
    [product_sold_date] DATE  NOT NULL ,
    [product_sold_year] INT  NOT NULL ,
    [product_sold_month_name] VARCHAR(50)  NOT NULL ,
    [product_sold_month_number] INT  NOT NULL ,
    [product_sold_quarter] INT  NOT NULL ,
    [product_id] INT  NOT NULL ,
    [brand] VARCHAR(100)  NOT NULL ,
    [product_class] VARCHAR(15)  NOT NULL ,
    [product_line] VARCHAR(15)  NOT NULL ,
    [product_size] VARCHAR(15)  NOT NULL ,

)

CREATE TABLE [FACT_Transactions] 
(
	[num_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [transaction_id] INT NOT NULL ,
    [customer_id] INT  NOT NULL ,
    [transaction_date] DATE  NOT NULL ,
    [product_first_sold_date] DATE  NOT NULL ,
    [list_price] FLOAT  NOT NULL ,
    [standard_cost] FLOAT  NOT NULL ,
    [profit] FLOAT  NOT NULL ,

)

-- =============================================
-- TRUNCATE DIM & FACTS TABLES BLOCK
-- =============================================
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_Customers]
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_Address]
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_CustomerSegments]
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_TransactionDate]
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[DIM_SoldProduct]
TRUNCATE TABLE [KPMG_Sprocket_Stagging].[dbo].[FACT_Transactions]

-- =============================================
-- INSERT INTO DIM & FACTS TABLES BLOCK
-- =============================================
INSERT INTO [DIM_Customers] 
(
    [customer_id]
    ,[first_name]
    ,[last_name]
    ,[gender]
    ,[DOB]
    ,[age]
    ,[job_title]
    ,[job_industry_category]

)
SELECT DISTINCT transaction_customer_id
	   ,first_name
	   ,last_name
	   ,gender
	   ,DOB
	   ,DATEDIFF(YEAR, CONVERT(DATE, DOB), GETDATE()) AS age
	   ,job_title
	   ,job_industry_category
FROM MDL_Transactions

-- =============================================
INSERT INTO [DIM_Address] 
(
    [customer_id]
    ,[address]
    ,[postcode]
    ,[state]
    ,[country]

)
SELECT DISTINCT transaction_customer_id
	   ,address
	   ,postcode
	   ,state
	   ,country
FROM MDL_Transactions

-- =============================================
INSERT INTO [DIM_CustomerSegments] 
(
    [customer_id]
    ,[wealth_segments]
    ,[tenure]

)
SELECT DISTINCT transaction_customer_id
	   ,wealth_segment
	   ,CASE 
        WHEN tenure LIKE '%.0' THEN LEFT(tenure, LEN(tenure) - 2)
        ELSE tenure
    END AS CleanedTenure
FROM MDL_Transactions

-- =============================================
INSERT INTO [DIM_TransactionDate] 
(
	[transaction_id]
    ,[transaction_date]
    ,[transaction_year]
    ,[transaction_month_name]
    ,[transaction_month_number]
    ,[transaction_quarter]

)
SELECT transaction_id
	   ,transaction_date
	   ,YEAR(CONVERT(DATE, transaction_Date)) AS transaction_year
	   ,DATENAME(MONTH, CONVERT(DATE, transaction_date)) AS transaction_month
	   ,MONTH(CONVERT(DATE, transaction_Date)) AS transaction_month_number
	   ,DATEPART(QUARTER, CONVERT(DATE, transaction_date)) AS transaction_quarter
FROM MDL_Transactions

-- =============================================
INSERT INTO [DIM_SoldProduct] 
(
	[transaction_id]
    ,[product_sold_date]
    ,[product_sold_year]
    ,[product_sold_month_name]
    ,[product_sold_month_number]
    ,[product_sold_quarter]
    ,[product_id]
    ,[brand]
    ,[product_class]
    ,[product_line]
    ,[product_size]

)
SELECT transaction_id
	   ,product_first_sold_date
	   ,YEAR(CONVERT(DATE, product_first_sold_date)) AS product_sold_year
	   ,DATENAME(MONTH, CONVERT(DATE, product_first_sold_date)) AS product_sold_month
	   ,MONTH(CONVERT(DATE, product_first_sold_date)) AS product_sold_month_number
	   ,DATEPART(QUARTER, CONVERT(DATE, product_first_sold_date)) AS product_sold_quarter
	   ,product_id
	   ,brand
	   ,product_class
	   ,product_line
	   ,product_size
FROM MDL_Transactions

-- =============================================
INSERT INTO [FACT_Transactions] 
(
    [transaction_id] 
    ,[customer_id] 
    ,[transaction_date] 
    ,[product_first_sold_date] 
    ,[list_price] 
    ,[standard_cost] 
    ,[profit] 

)
SELECT transaction_id
	   ,transaction_customer_id
	   ,transaction_date
	   ,product_first_sold_date
	   ,list_price
	   ,standard_cost
	   ,(CAST(list_price AS FLOAT) - CAST(standard_cost AS FLOAT)) AS profit
FROM MDL_Transactions

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
