USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[Final_Table]    Script Date: 17-01-2024 07:08:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 23/11/2023
-- Description:	Create a Final Table 
-- =============================================
ALTER PROC [dbo].[Final_Table]
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
