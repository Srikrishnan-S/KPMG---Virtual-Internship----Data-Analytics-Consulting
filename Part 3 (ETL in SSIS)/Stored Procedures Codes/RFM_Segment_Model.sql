USE [KPMG_Sprocket_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[RFM_Segment_Model]    Script Date: 17-01-2024 07:08:33 ******/
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
