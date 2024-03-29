USE [KPMG_Sprocket_Stagging]
GO
/****** Object:  StoredProcedure [dbo].[Transform_RAW_Tables]    Script Date: 17-01-2024 07:04:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Srikrishnan
-- Create date: 19/11/2023
-- Description:	Transformation 1 --> RAW_Tables
-- =============================================
ALTER PROC [dbo].[Transform_RAW_Tables]
AS
BEGIN
-- =============================================
-- TRANSFORM TABLE --> RAW_Transactions
-- =============================================
-- ============================================= online_order Column Transform
UPDATE RAW_Transactions
SET online_order = CASE WHEN online_order = '1.0' THEN 'Yes' ELSE 'No' END

-- =============================================
-- TRANSFORM TABLE --> RAW_CustomerDemographics
-- =============================================
-- ============================================= Male & Female Inconsistency
UPDATE RAW_CustomerDemographics
SET gender = CASE WHEN UPPER(LEFT(gender, 1)) = 'F' THEN 'Female'
				WHEN UPPER(LEFT(gender, 1)) = 'M' THEN 'Male'
				ELSE gender END

-- =============================================
-- TRANSFORM TABLE --> RAW_CustomerAddress
-- =============================================
-- ============================================= state Column Inconsistency
UPDATE RAW_CustomerAddress
SET state = CASE WHEN UPPER(LEFT(state, 1)) = 'N' THEN 'New South Wales'
			WHEN UPPER(LEFT(state, 1)) = 'V' THEN 'Victoria'
			WHEN UPPER(LEFT(state, 1)) = 'Q' THEN 'Queensland'
			ELSE state END

-- =============================================
-- TRANSFORM TABLE --> RAW_NewCustomerList
-- =============================================
-- ============================================= state Column Inconsistency
UPDATE RAW_NewCustomerList
SET state = CASE WHEN UPPER(LEFT(state, 1)) = 'N' THEN 'New South Wales'
			WHEN UPPER(LEFT(state, 1)) = 'V' THEN 'Victoria'
			WHEN UPPER(LEFT(state, 1)) = 'Q' THEN 'Queensland'
			ELSE state END

-- ============================================= Male & Female Inconsistency
UPDATE RAW_NewCustomerList
SET gender = CASE WHEN UPPER(LEFT(gender, 1)) = 'F' THEN 'Female'
				WHEN UPPER(LEFT(gender, 1)) = 'M' THEN 'Male'
				ELSE 'Others' END

-- =============================================
END
