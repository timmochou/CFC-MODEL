WITH T1 AS(
SELECT 
t1.period+t1.entity_id AS data_id,
t1.period,
t1.entity_id,
--t2.entity_name,
t1.value,
t1.data_name ,
t2.country_id
FROM TRS_FACT_COUNTRY_REPORT t1
JOIN v_trs_dim_entity t2 ON t2.entity_id = t1.entity_id 
WHERE 1=1
AND t2.language ='en_US'
--AND t1.data_name IN ('${P_COLUMNS}')
AND t1.report_name = '${P_REPORTNAME}'
${if(LEN(P_COUNTRY)=0,"","AND t2.COUNTRY_ID IN ('"+P_COUNTRY+"')")}
${if(LEN(P_ENTITY)=0,"","AND t1.entity_id IN ('"+P_ENTITY+"')")}
${if(LEN(P_PERIOD)=0,"","AND t1.period IN ('"+P_PERIOD+"')")}
${if(ope="A1","AND t1.id = ''","")}
${if(ope="A2","AND CONCAT(t1.period,t1.entity_id) IN ('"+replace(P_ID,",","','")+"')","")}
)
SELECT 
*
FROM T1
PIVOT (MAX(VALUE) FOR DATA_NAME IN ([${P_COLUMNS2}]))as pivotTable
ORDER BY period DESC , entity_id;