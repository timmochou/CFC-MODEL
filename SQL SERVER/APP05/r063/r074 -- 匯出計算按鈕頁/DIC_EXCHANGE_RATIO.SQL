SELECT DISTINCT
	T1.CURRENCY_CODE,
	T3.CURRENT_CODE,
	FORMAT(T2.AVG_EXCHANGE_RATIO, '#,###.00000') AS AVG_EXCHANGE_RATIO
FROM TRS_FACT_TRIAL_BALANCE T1
LEFT JOIN V_TRS_FACT_EXCHANGE_BANKOFTW T2 ON CONCAT(T1.PERIOD,'-', RIGHT('0' + T1.MONTH,2)) = T2.PERIOD AND T1.CURRENCY_CODE = T2.CURRENCY_ID  AND T2.TARGET_CURRENCY_ID = 'NTD' AND T1.SCENARIO = T2.SCENARIO 
LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.ENTITY_CODE = t3.ENTITY_CODE
WHERE 1 = 1
	--AND t3.CURRENT_CODE = '${P_CFC}'
	AND CONCAT(T1.PERIOD,'-', RIGHT('0' + T1.MONTH,2))= '${P_DATE}'
	AND t1.SCENARIO = '${P_VERSION}'