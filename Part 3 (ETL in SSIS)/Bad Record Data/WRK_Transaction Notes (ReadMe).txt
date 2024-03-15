SELECT [transaction_id]
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
  FROM [KPMG_Sprocket_Stagging].[dbo].[WRK_Transactions]
  WHERE transaction_id IS NULL
  OR demographics_customer_id IS NULL
  OR address_customer_id IS NULL

-- ============================================================================================
-- CustomerAddress attributes has 12 Null Rows.
-- CustomerDemographics attributes has 6454 Null Rows.
-- Transaction with CustomerAddress attributes has 300 Null Rows
-- Transaction with CustomerDemographics attributes has 512 Null Rows
-- CustomerDemographics with CustomerAddress attributes has 17 Null Rows
-- Total WRK Transactions attributes has 7295 Null Rows
-- ============================================================================================