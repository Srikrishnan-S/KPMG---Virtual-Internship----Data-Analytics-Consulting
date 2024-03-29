USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[BLD_Warehouse_Tables]    Script Date: 17-01-2024 07:06:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Create Facts and Dimensions Tables in Warehouse
-- =============================================
ALTER PROC [dbo].[BLD_Warehouse_Tables] 
AS
BEGIN

-- =============================================
-- CREATE DIM & FACT TABLES BLOCK
-- =============================================

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.DIM_Customers') IS NULL
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

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.DIM_CustomerSegments') IS NULL
	CREATE TABLE [DIM_CustomerSegments] 
(
    [customer_id] INT PRIMARY KEY NOT NULL ,
    [wealth_segments] VARCHAR(50)  NOT NULL ,
    [tenure] INT  NOT NULL ,

)

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.DIM_Address') IS NULL
	CREATE TABLE [DIM_Address] 
(
    [customer_id] INT PRIMARY KEY NOT NULL ,
    [address] VARCHAR(500)  NOT NULL ,
    [postcode] VARCHAR(10)  NOT NULL ,
    [state] VARCHAR(50)  NOT NULL ,
    [country] VARCHAR(50)  NOT NULL ,

)

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.DIM_TransactionDate') IS NULL
	CREATE TABLE [DIM_TransactionDate] 
(
	[transaction_id] INT PRIMARY KEY NOT NULL,
    [transaction_date] DATE  NOT NULL ,
    [transaction_year] INT  NOT NULL ,
    [transaction_month_name] VARCHAR(50)  NOT NULL ,
    [transaction_month_number] INT  NOT NULL ,
    [transaction_quarter] INT  NOT NULL ,

)

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.DIM_SoldProduct') IS NULL
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

IF OBJECT_ID('KPMG_Sprocket_Warehouse.dbo.FACT_Transactions') IS NULL
	CREATE TABLE [FACT_Transactions] 
(
	[num_id] INT PRIMARY KEY NOT NULL,
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
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers]
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address]
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments]
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate]
--DROP TABLE [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct]

-- =============================================
-- END
-- =============================================

END
