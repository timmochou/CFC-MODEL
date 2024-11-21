-- 1. CAL_INV_CONTROL_LOOP_DATE
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'CAL_INV_CONTROL_LOOP_DATE',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_INV_CONTROL_LOOP_DATE(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-18 15:21:57.054516 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=15, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 2. CAL_RATIO_HOLD
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'CAL_RATIO_HOLD',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_CAL_RATIO_HOLD(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-18 15:00:08.864741 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=15, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 3. CAL_RATIO_HOLD_NONLOWTAX_ADJ
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'CAL_RATIO_HOLD_NONLOWTAX_ADJ',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_CAL_RATIO_HOLD_NONLOWTAX_ADJ(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-26 16:24:40.614515 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=00, 15, 30, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 4. CAL_RATIO_HOLD_NONLOWTAX_ADJS
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'CAL_RATIO_HOLD_NONLOWTAX_ADJS',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_CAL_RATIO_HOLD_NONLOWTAX_ADJ(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-26 15:56:16.614682 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=15, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 5. CAL_RATIO_HOLD_REALIZED_LOSS
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'CAL_RATIO_HOLD_REALIZED_LOSS',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_CAL_RATIO_HOLD_REALIZED_LOSS(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-26 16:23:57.498415 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=00, 15, 30, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 6. GET_CFC_ENTITY_VERSION
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'GET_CFC_ENTITY_VERSION',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN P_CFC_ENTITY_VERSION(); END;',
    start_date => TO_TIMESTAMP_TZ('2024-03-18 15:22:36.422617 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=15, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;


-- 7. REFRESH_MV_TB
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'REFRESH_MV_TB',
    job_type => 'PLSQL_BLOCK',
    job_action => 'dbms_refresh.refresh(''TRSDB.MV_TRS_TB_ACTUAL_ACCOUNT_AMOUNT'')',
    start_date => TO_TIMESTAMP_TZ('2024-03-18 15:19:26.20632 +8:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
    repeat_interval => 'FREQ=HOURLY; BYMINUTE=15, 45',
    comments => 'Job runs every hour at 30 minutes.',
    enabled => TRUE
);
END;
