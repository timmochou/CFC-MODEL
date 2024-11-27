-- 國家報表 類別字典
WITH T1 AS (SELECT 'col_income_non_rel' AS DATA_NAME, '收入_非關係人' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_income_non_rel' AS DATA_NAME, 'Revenues-Unrelated Party' AS NAME ,'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_income_rel' AS DATA_NAME, '收入_關係人' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT'col_income_rel' AS DATA_NAME,'Revenues-Related Party' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT'col_income' AS DATA_NAME, '收入' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT'col_income' AS DATA_NAME, 'Revenues' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT'col_pre_tax_income' AS DATA_NAME, '所得稅前損益' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_pre_tax_income' AS DATA_NAME, 'Profit (Loss) before Income Tax' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_tax_paid' AS DATA_NAME, '已納所得稅(現金收付制)' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_tax_paid' AS DATA_NAME, 'Income Tax Paid (on Cash Basis)' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_curr_tax_payable' AS DATA_NAME, '當期應付所得稅' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_curr_tax_payable' AS DATA_NAME, 'Income Tax Accrued-Current Year' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_paid_up_capital' AS DATA_NAME, '實收資本額' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_paid_up_capital' AS DATA_NAME,'Paid-up Capital' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_accu_surplus' AS DATA_NAME, '累積盈餘' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_accu_surplus' AS DATA_NAME, 'Accumulated Surplus' AS NAME, 'en_US' AS LANGUAGE
UNION ALL  
SELECT 'col_num_of_emp' AS DATA_NAME, '員工人數' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_num_of_emp' AS DATA_NAME,'Number of Employees' AS NAME, 'en_US' AS LANGUAGE
UNION ALL
SELECT 'col_tangible_asset' AS DATA_NAME, '有形資產' AS NAME, 'zh_TW' AS LANGUAGE
UNION ALL
SELECT 'col_tangible_asset' AS DATA_NAME, 'Tangible Assets' AS NAME, 'en_US' AS LANGUAGE)
SELECT *　FROM T1
WHERE
LANGUAGE = '${fr_locale}'