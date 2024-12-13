SELECT DISTINCT
CURRENCY_CODE,
t2.current_code
FROM TRS_FACT_TRIAL_BALANCE t1
LEFT JOIN V_TRS_DIM_ENTITY_CUR t2 ON t1.ENTITY_CODE = t2.ENTITY_CODE
WHERE 1 = 1
AND PERIOD||'-'||LPAD(MONTH,2,0)= '${P_DATE}'
AND SCENARIO = '${P_VERSION}'