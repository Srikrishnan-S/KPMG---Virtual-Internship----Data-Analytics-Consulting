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