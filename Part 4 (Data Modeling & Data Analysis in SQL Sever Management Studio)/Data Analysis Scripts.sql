--======================================================================
-- DATA ANALYSIS: 
--======================================================================
--**********************************************************************
--======================================================================
-- DATA PREVIEW: 
--======================================================================

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate]

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct]

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers]

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address]

SELECT *
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments]

--======================================================================
-- 1) GRAND SALES: 
--======================================================================
SELECT SUM(list_price) AS Total_Sales
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

--======================================================================
-- 2) GROSS PROFIT: 
--======================================================================
SELECT SUM(profit) AS Total_Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

--======================================================================
-- 3) NET PROFIT MARGIN: 
--======================================================================
SELECT (SUM(profit)/SUM(list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

--======================================================================
-- 4) RETURN ON INVESTMENT: 
--======================================================================
SELECT (SUM(profit)/SUM(standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

--======================================================================
-- 5) COST PER PRODUCT: 
--======================================================================
SELECT (SUM(T.standard_cost)/COUNT(DISTINCT P.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] P
ON T.transaction_id = P.transaction_id

--======================================================================
-- 6) TOTAL CUSTOMERS: 
--======================================================================
SELECT COUNT(customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers]

--======================================================================
-- 7) TOTAL PRODUCTS SOLD: 
--======================================================================
SELECT COUNT(DISTINCT transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions]

--======================================================================
-- 8) SALES BY DATE(MONTH): 
--======================================================================
SELECT TD.transaction_month_name, SUM(T.list_price) AS Sales
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_month_name
ORDER BY Sales DESC

--======================================================================
-- 9) SALES BY DATE(QUARTER): 
--======================================================================
SELECT TD.transaction_quarter, SUM(T.list_price) AS Sales
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_quarter
ORDER BY Sales DESC

--======================================================================
-- 10) PROFIT BY DATE(MONTH): 
--======================================================================
SELECT TD.transaction_month_name, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_month_name
ORDER BY Profit DESC

--======================================================================
-- 11) PROFIT BY DATE(QUARTER): 
--======================================================================
SELECT TD.transaction_quarter, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_quarter
ORDER BY Profit DESC

--======================================================================
-- 12) PROFIT BY AGE GROUP: 
--======================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Profit DESC

--======================================================================
-- 13) PROFIT BY TENURE GROUP: 
--======================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Profit DESC

--======================================================================
-- 16) PROFIT BY WEALTH SEGMENT: 
--======================================================================
SELECT CS.wealth_segments, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Profit DESC

--======================================================================
-- 17) PROFIT BY STATE: 
--======================================================================
SELECT A.state, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Profit DESC

--======================================================================
-- 18) PROFIT BY JOB INDUSTRY CATEGORY: 
--======================================================================
SELECT C.job_industry_category, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Profit DESC

--======================================================================
-- 19) PROFIT BY JOB INDUSTRY TITLE: 
--======================================================================
SELECT TOP 10 C.job_title, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Profit DESC

--======================================================================
-- 20) NET PROFIT MARGIN BY DATE(MONTH): 
--======================================================================
SELECT TD.transaction_month_name, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_month_name
ORDER BY Net_Profit_Margin DESC

--======================================================================
-- 21) NET PROFIT MARGIN BY DATE(QUARTER): 
--======================================================================
SELECT TD.transaction_quarter, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_quarter
ORDER BY Net_Profit_Margin DESC

--======================================================================
-- 22) COST PER PRODUCT BY DATE(MONTH): 
--======================================================================
SELECT TD.transaction_month_name, (SUM(T.standard_cost)/COUNT(DISTINCT P.product_id)) AS Avg_Cost
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] P
ON T.transaction_id = P.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_month_name
ORDER BY Avg_Cost DESC

--======================================================================
-- 23) COST PER PRODUCT BY DATE(QUARTER): 
--======================================================================
SELECT TD.transaction_quarter, (SUM(T.standard_cost)/COUNT(DISTINCT P.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] P
ON T.transaction_id = P.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_quarter
ORDER BY Cost_per_Product DESC

--======================================================================
-- 24) RETURN ON INVESTMENT BY DATE(MONTH): 
--======================================================================
SELECT TD.transaction_month_name, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_month_name
ORDER BY Return_on_Investment DESC

--======================================================================
-- 25) RETURN ON INVESTMENT BY DATE(QUARTER): 
--======================================================================
SELECT TD.transaction_quarter, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
--LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] P
--ON T.transaction_id = P.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
GROUP BY TD.transaction_quarter
ORDER BY Return_on_Investment DESC

--======================================================================
-- 26) NET PROFIT MARGIN BY AGE GROUP: 
--======================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Net_Profit_Margin DESC
  
--======================================================================
-- 27) RETURN ON INVESTMENT BY AGE GROUP: 
--======================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Return_on_Investment DESC
  
--============================================================================================================================================
-- 28) COST PER PRODUCT BY AGE GROUP: 
--============================================================================================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, (SUM(T.standard_cost)/COUNT(DISTINCT P.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] P
ON T.transaction_id = P.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 29) CUSTOMER COUNT BY AGE GROUP: 
--============================================================================================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 30) TOTAL PRODUCT SOLD BY AGE GROUP: 
--============================================================================================================================================
SELECT (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY (CASE 
    WHEN C.age <= 30 THEN '21-30'
    WHEN C.age <= 40 THEN '31-40'
    WHEN C.age <= 50 THEN '41-50'
    WHEN C.age <= 60 THEN '51-60'
    WHEN C.age <= 70 THEN '61-70'
    WHEN C.age <= 80 THEN '71-80'
    WHEN C.age <= 90 THEN '81-90'
    ELSE '90+' END)
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 31) NET PROFIT MARGIN BY TENURE GROUP: 
--============================================================================================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 32) RETURN ON INVESTMENT BY TENURE GROUP: 
--============================================================================================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, (SUM(profit)/SUM(standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 33) COST PER PRODUCT BY TENURE GROUP: 
--============================================================================================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 34) CUSTOMER COUNT BY TENURE GROUP: 
--============================================================================================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 35) TOTAL PRODUCT SOLD BY TENURE GROUP: 
--============================================================================================================================================
SELECT (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END)
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 36) NET PROFIT MARGIN BY WEALTH SEGMENT: 
--============================================================================================================================================
SELECT CS.wealth_segments, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 37) RETURN ON INVESTMENT BY WEALTH SEGMENT: 
--============================================================================================================================================
SELECT CS.wealth_segments, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 38) COST PER PRODUCT BY WEALTH SEGMENT:  
--============================================================================================================================================
SELECT CS.wealth_segments, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 39) CUSTOMER COUNT BY WEALTH SEGMENT:  
--============================================================================================================================================
SELECT CS.wealth_segments, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 40) TOTAL PRODUCT SOLD BY WEALTH SEGMENT:  
--============================================================================================================================================
SELECT CS.wealth_segments, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
GROUP BY CS.wealth_segments
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 41) NET PROFIT MARGIN BY STATE: 
--============================================================================================================================================
SELECT A.state, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 42) RETURN ON INVESTMENT BY STATE: 
--============================================================================================================================================
SELECT A.state, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Return_on_Investment DESC
 
--============================================================================================================================================
-- 43) COST PER PRODUCT BY STATE: 
--============================================================================================================================================
SELECT A.state, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) * 100 AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 44) CUSTOMER COUNT BY STATE: 
--============================================================================================================================================
SELECT A.state, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 45) TOTAL PRODUCT SOLD BY STATE: 
--============================================================================================================================================
SELECT A.state, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] A 
ON T.customer_id = A.customer_id
GROUP BY A.state
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 46) NET PROFIT MARGIN BY JOB INDUSTRY CATEGORY: 
--============================================================================================================================================
SELECT C.job_industry_category, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 47) RETURN ON INVESTMENT BY JOB INDUSTRY CATEGORY: 
--============================================================================================================================================
SELECT C.job_industry_category, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 48) COST PER PRODUCT BY JOB INDUSTRY CATEGORY: 
--============================================================================================================================================
SELECT C.job_industry_category, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 46) CUSTOMER COUNT BY JOB INDUSTRY CATEGORY: 
--============================================================================================================================================
SELECT C.job_industry_category, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 46) TOTAL_PRODUCT SOLD BY JOB INDUSTRY CATEGORY: 
--============================================================================================================================================
SELECT C.job_industry_category, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_industry_category
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 47) NET PROFIT MARGIN BY JOB INDUSTRY TITLE: 
--============================================================================================================================================
SELECT TOP 10 C.job_title, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 48) RETURN ON INVESTMENT BY JOB INDUSTRY TITLE: 
--============================================================================================================================================
SELECT TOP 10 C.job_title, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 49) COST PER PRODUCT BY JOB INDUSTRY TITLE: 
--============================================================================================================================================
SELECT TOP 10 C.job_title, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 50) CUSTOMER COUNT BY JOB INDUSTRY TITLE: 
--============================================================================================================================================
SELECT TOP 10 C.job_title, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 51) TOTAL PRODUCT SOLD BY JOB INDUSTRY TITLE: 
--============================================================================================================================================
SELECT TOP 10 C.job_title, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.job_title
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 52) NO OF UNIQUE BRANDS: 
--============================================================================================================================================
SELECT COUNT(DISTINCT brand) AS Unique_Brand_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct]

--============================================================================================================================================
-- 52) SALES BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, SUM(T.list_price) AS Total_Sales
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Total_Sales DESC

--============================================================================================================================================
-- 53) PROFIT BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 54) NET PROFIT MARGIN BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 55) RETURN ON INVESTMENT BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 56) COST PER PRODUCT BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 57) TOTAL PRODUCT SOLD BY UNIQUE BRANDS: 
--============================================================================================================================================
SELECT SP.brand, COUNT(DISTINCT T.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
GROUP BY SP.brand
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 58) PROFIT BY GENDER: 
--============================================================================================================================================
SELECT C.gender, SUM(T.profit) AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Profit DESC

--============================================================================================================================================
-- 59) PROFIT PERCENTAGE BY GENDER: 
--============================================================================================================================================
SELECT C.gender, (SUM(T.profit)/(SELECT SUM(T2.profit) FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T2)) * 100 AS Profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Profit DESC

--============================================================================================================================================
-- 60) NET PROFIT MARGIN BY GENDER: 
--============================================================================================================================================
SELECT C.gender, (SUM(T.profit)/SUM(T.list_price)) * 100 AS Net_Profit_Margin
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Net_Profit_Margin DESC

--============================================================================================================================================
-- 61) RETURN ON INVESTMENT BY GENDER: 
--============================================================================================================================================
SELECT C.gender, (SUM(T.profit)/SUM(T.standard_cost)) * 100 AS Return_on_Investment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Return_on_Investment DESC

--============================================================================================================================================
-- 62) SALES BY GENDER: 
--============================================================================================================================================
SELECT C.gender, SUM(T.list_price) AS Sales
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Sales DESC

--============================================================================================================================================
-- 63) COST PER PRODUCT BY GENDER: 
--============================================================================================================================================
SELECT C.gender, (SUM(T.standard_cost)/COUNT(DISTINCT SP.product_id)) AS Cost_per_Product
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Cost_per_Product DESC

--============================================================================================================================================
-- 64) CUSTOMER COUNT BY GENDER: 
--============================================================================================================================================
SELECT C.gender, COUNT(DISTINCT T.customer_id) AS Customer_Count
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Customer_Count DESC

--============================================================================================================================================
-- 65) TOTAL PRODUCT SOLD BY GENDER: 
--============================================================================================================================================
SELECT C.gender, COUNT(DISTINCT SP.transaction_id) AS Total_Product_Sold
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] C
ON T.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY Total_Product_Sold DESC

--============================================================================================================================================
-- 66) RFM MODEL : R SCORE, F SCORE, M SCORE & RFM SCORE 
--============================================================================================================================================
WITH CustomerRFM AS
(
    SELECT
        T.customer_id,
        DATEDIFF(DAY, 
                MAX(TD.transaction_date),
                (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2)) AS Recency,
        COUNT(DISTINCT SP.transaction_id) AS Frequency,
        SUM(T.list_price) AS Monetary
    FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
    ON T.transaction_id = TD.transaction_id
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
    ON T.transaction_id = SP.transaction_id
    GROUP BY T.customer_id
)

SELECT 
    customer_id, 
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    (R_Score + F_Score + M_Score) / 3.0 AS RFM_Score,
    CASE 
        WHEN (R_Score + F_Score + M_Score) / 3.0 <= 1.5 THEN 'Tier 1 Customer' 
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 1.5 AND (R_Score + F_Score + M_Score) / 3.0 <= 2 THEN 'Tier 2 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 2 AND (R_Score + F_Score + M_Score) / 3.0 <= 2.5 THEN 'Tier 3 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 2.5 AND (R_Score + F_Score + M_Score) / 3.0 <= 3 THEN 'Tier 4 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 3 AND (R_Score + F_Score + M_Score) / 3.0 <= 3.5 THEN 'Tier 5 Customer'
        ELSE 'Tier 6 Customer' 
    END AS RFM_Segment
FROM (
    SELECT 
        customer_id, 
        Recency,
        Frequency,
        Monetary,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) < 0.25 THEN 1
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Recency) < 0.50 THEN 2
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Recency) < 0.75 THEN 3
            ELSE 4
        END AS R_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Frequency) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Frequency) < 0.75 THEN 2
            ELSE 1
        END AS F_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Monetary) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Monetary) < 0.75 THEN 2
            ELSE 1
        END AS M_Score
    FROM CustomerRFM
) AS Subquery
ORDER BY RFM_Score DESC;

--============================================================================================================================================
-- 66) JOIN TABLE 
--============================================================================================================================================

SELECT 
	T.transaction_id
	,T.transaction_date
	,TD.transaction_month_name
	,TD.transaction_month_number
	,TD.transaction_quarter
	,TD.transaction_year
	,T.customer_id
	,DC.first_name
	,DC.last_name
	,DC.DOB
	,DC.age
	,(CASE 
    WHEN DC.age <= 30 THEN '21-30'
    WHEN DC.age <= 40 THEN '31-40'
    WHEN DC.age <= 50 THEN '41-50'
    WHEN DC.age <= 60 THEN '51-60'
    WHEN DC.age <= 70 THEN '61-70'
    WHEN DC.age <= 80 THEN '71-80'
    WHEN DC.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group
	,DC.gender
	,DC.job_industry_category
	,DC.job_title
	,DA.address
	,DA.state
	,DA.country
	,DA.postcode
	,CS.tenure
	,(CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group
	,CS.wealth_segments
	,SP.product_sold_date
	,SP.product_sold_month_name
	,SP.product_sold_month_number
	,SP.product_sold_quarter
	,SP.product_sold_year
	,SP.product_id
	,SP.brand
	,SP.product_class
	,SP.product_size
	,SP.product_line
	,T.list_price
	,T.standard_cost
	,T.profit
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
ON T.transaction_id = TD.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] DC
ON T.customer_id = DC.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] DA
ON T.customer_id = DA.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS
ON T.customer_id = CS.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
ON T.transaction_id = SP.transaction_id

--============================================================================================================================================
-- 67) RFM MODEL : R SCORE, F SCORE, M SCORE & RFM SCORE USING STORE PROCEDURE FOR TABLEAU REPORT
--============================================================================================================================================
USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[RFM_Segment_Model]    Script Date: 21-12-2023 01:08:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Create a Customer Segmentation Model using RFM Analysis technique
-- =============================================
ALTER PROC [dbo].[RFM_Segment_Model]
AS
BEGIN
--======================================================================
-- RFM MODEL : R SCORE, F SCORE, M SCORE & RFM SCORE
--======================================================================
WITH CustomerRFM AS
(
    SELECT
        T.customer_id,
        DATEDIFF(DAY, 
                MAX(TD.transaction_date),
                (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2)) AS Recency,
        COUNT(DISTINCT SP.transaction_id) AS Frequency,
        SUM(T.list_price) AS Monetary
    FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD
    ON T.transaction_id = TD.transaction_id
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP
    ON T.transaction_id = SP.transaction_id
    GROUP BY T.customer_id
)

SELECT 
    customer_id, 
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    (R_Score + F_Score + M_Score) / 3.0 AS RFM_Score,
    CASE 
        WHEN (R_Score + F_Score + M_Score) / 3.0 <= 1.5 THEN 'Tier 1 Customer' 
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 1.5 AND (R_Score + F_Score + M_Score) / 3.0 <= 2 THEN 'Tier 2 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 2 AND (R_Score + F_Score + M_Score) / 3.0 <= 2.5 THEN 'Tier 3 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 2.5 AND (R_Score + F_Score + M_Score) / 3.0 <= 3 THEN 'Tier 4 Customer'
        WHEN (R_Score + F_Score + M_Score) / 3.0 > 3 AND (R_Score + F_Score + M_Score) / 3.0 <= 3.5 THEN 'Tier 5 Customer'
        ELSE 'Tier 6 Customer' 
    END AS RFM_Segment
FROM (
    SELECT 
        customer_id, 
        Recency,
        Frequency,
        Monetary,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) < 0.25 THEN 1
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Recency) < 0.50 THEN 2
            WHEN PERCENT_RANK() OVER(ORDER BY Recency) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Recency) < 0.75 THEN 3
            ELSE 4
        END AS R_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Frequency) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY Frequency) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Frequency) < 0.75 THEN 2
            ELSE 1
        END AS F_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY Monetary) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY Monetary) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY Monetary) < 0.75 THEN 2
            ELSE 1
        END AS M_Score
    FROM CustomerRFM
) AS Subquery
ORDER BY RFM_Score DESC;

-- =============================================
-- END PROC
-- =============================================

END

-- =============================================
-- EXECUTE PROC
-- =============================================
EXEC RFM_Segment_Model

--============================================================================================================================================
-- 68) FINAL TABLE
--============================================================================================================================================
WITH CustomerRFM AS
(
    -- RFM calculations
    SELECT
        T.customer_id,
        DATEDIFF(
            DAY,
            MAX(TD.transaction_date),
            (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2)
        ) AS Recency,
        COUNT(DISTINCT SP.transaction_id) AS Frequency,
        SUM(T.list_price) AS Monetary,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.25 THEN 1
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.50 THEN 2
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.75 THEN 3
            ELSE 4
        END AS R_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.75 THEN 2
            ELSE 1
        END AS F_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.75 THEN 2
            ELSE 1
        END AS M_Score
    FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD ON T.transaction_id = TD.transaction_id
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP ON T.transaction_id = SP.transaction_id
    GROUP BY T.customer_id
)

-- Combine data from Code 1 and the CTE
SELECT 
    T.transaction_id,
    T.transaction_date,
    TD.transaction_month_name,
    TD.transaction_month_number,
    TD.transaction_quarter,
    TD.transaction_year,
    T.customer_id,
    DC.first_name,
    DC.last_name,
    DC.DOB,
    DC.age,
    (CASE 
    WHEN DC.age <= 30 THEN '21-30'
    WHEN DC.age <= 40 THEN '31-40'
    WHEN DC.age <= 50 THEN '41-50'
    WHEN DC.age <= 60 THEN '51-60'
    WHEN DC.age <= 70 THEN '61-70'
    WHEN DC.age <= 80 THEN '71-80'
    WHEN DC.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_grou,
    DC.gender,
    DC.job_industry_category,
    DC.job_title,
    DA.address,
    DA.state,
    DA.country,
    DA.postcode,
    CS.tenure,
    (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group,
    CS.wealth_segments,
    SP.product_sold_date,
    SP.product_sold_month_name,
    SP.product_sold_month_number,
    SP.product_sold_quarter,
    SP.product_sold_year,
    SP.product_id,
    SP.brand,
    SP.product_class,
    SP.product_size,
    SP.product_line,
    T.list_price,
    T.standard_cost,
    T.profit,
    RFM.Recency,
    RFM.Frequency,
    RFM.Monetary,
    RFM.R_Score,
    RFM.F_Score,
    RFM.M_Score,
    (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 AS RFM_Score,
    CASE 
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 1.5 THEN 'Tier 1 Customer' 
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 1.5 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 2 THEN 'Tier 2 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 2 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 2.5 THEN 'Tier 3 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 2.5 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 3 THEN 'Tier 4 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 3 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 3.5 THEN 'Tier 5 Customer'
        ELSE 'Tier 6 Customer' 
    END AS RFM_Segment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD ON T.transaction_id = TD.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] DC ON T.customer_id = DC.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] DA ON T.customer_id = DA.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS ON T.customer_id = CS.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP ON T.transaction_id = SP.transaction_id
LEFT JOIN CustomerRFM RFM ON T.customer_id = RFM.customer_id;

--============================================================================================================================================
-- 69) FINAL TABLE STORED PROC
--============================================================================================================================================
USE [KPMG_Sprocket_Warehouse]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Create a Final Table 
-- =============================================
ALTER PROC Final_Table
AS
BEGIN
--======================================================================
-- RFM MODEL : R SCORE, F SCORE, M SCORE & RFM SCORE
--======================================================================

WITH CustomerRFM AS
(
    -- RFM calculations
    SELECT
        T.customer_id,
        DATEDIFF(
            DAY,
            MAX(TD.transaction_date),
            (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2)
        ) AS Recency,
        COUNT(DISTINCT SP.transaction_id) AS Frequency,
        SUM(T.list_price) AS Monetary,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.25 THEN 1
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.50 THEN 2
            WHEN PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY DATEDIFF(DAY, MAX(TD.transaction_date), (SELECT MAX(TD2.transaction_date) FROM [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD2))) < 0.75 THEN 3
            ELSE 4
        END AS R_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY COUNT(DISTINCT SP.transaction_id)) < 0.75 THEN 2
            ELSE 1
        END AS F_Score,
        CASE 
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.25 THEN 4
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) >= 0.25 AND PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.50 THEN 3
            WHEN PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) >= 0.50 AND PERCENT_RANK() OVER(ORDER BY SUM(T.list_price)) < 0.75 THEN 2
            ELSE 1
        END AS M_Score
    FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T 
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD ON T.transaction_id = TD.transaction_id
    LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP ON T.transaction_id = SP.transaction_id
    GROUP BY T.customer_id
)

-- Combine data from Code 1 and the CTE
SELECT 
    T.transaction_id,
    T.transaction_date,
    TD.transaction_month_name,
    TD.transaction_month_number,
    TD.transaction_quarter,
    TD.transaction_year,
    T.customer_id,
    DC.first_name,
    DC.last_name,
    DC.DOB,
    DC.age,
    (CASE 
    WHEN DC.age <= 30 THEN '21-30'
    WHEN DC.age <= 40 THEN '31-40'
    WHEN DC.age <= 50 THEN '41-50'
    WHEN DC.age <= 60 THEN '51-60'
    WHEN DC.age <= 70 THEN '61-70'
    WHEN DC.age <= 80 THEN '71-80'
    WHEN DC.age <= 90 THEN '81-90'
    ELSE '90+' END) AS age_group,
    DC.gender,
    DC.job_industry_category,
    DC.job_title,
    DA.address,
    DA.state,
    DA.country,
    DA.postcode,
    CS.tenure,
    (CASE
    WHEN CS.tenure <= 5 THEN '1-5'
    WHEN CS.tenure <= 11 THEN '6-11'
    WHEN CS.tenure <= 17 THEN '12-17'
    WHEN CS.tenure <= 22 THEN '18-22'
    ELSE '22+' END) AS tenure_group,
    CS.wealth_segments,
    SP.product_sold_date,
    SP.product_sold_month_name,
    SP.product_sold_month_number,
    SP.product_sold_quarter,
    SP.product_sold_year,
    SP.product_id,
    SP.brand,
    SP.product_class,
    SP.product_size,
    SP.product_line,
    T.list_price,
    T.standard_cost,
    T.profit,
    RFM.Recency,
    RFM.Frequency,
    RFM.Monetary,
    RFM.R_Score,
    RFM.F_Score,
    RFM.M_Score,
    (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 AS RFM_Score,
    CASE 
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 1.5 THEN 'Tier 1 Customer' 
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 1.5 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 2 THEN 'Tier 2 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 2 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 2.5 THEN 'Tier 3 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 2.5 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 3 THEN 'Tier 4 Customer'
        WHEN (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 > 3 AND (RFM.R_Score + RFM.F_Score + RFM.M_Score) / 3.0 <= 3.5 THEN 'Tier 5 Customer'
        ELSE 'Tier 6 Customer' 
    END AS RFM_Segment
FROM [KPMG_Sprocket_Warehouse].[dbo].[FACT_Transactions] T
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_TransactionDate] TD ON T.transaction_id = TD.transaction_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Customers] DC ON T.customer_id = DC.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_Address] DA ON T.customer_id = DA.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_CustomerSegments] CS ON T.customer_id = CS.customer_id
LEFT JOIN [KPMG_Sprocket_Warehouse].[dbo].[DIM_SoldProduct] SP ON T.transaction_id = SP.transaction_id
LEFT JOIN CustomerRFM RFM ON T.customer_id = RFM.customer_id;

-- =============================================
-- END PROC
-- =============================================

END

-- =============================================
-- EXECUTE PROC
-- =============================================
EXEC Final_Table

--============================================================================================================================================
-- END
--============================================================================================================================================
