CREATE SEQUENCE TRSDB.SEQ_TRS_TASK_NUMBER 
INCREMENT BY 1 --一次增加1
MINVALUE 0 --最小為0
MAXVALUE 9999999999999999999999999999 --最大值
NOCYCLE CACHE 50 NOORDER --暫存50
;
	
-- 建立重置sequence的procedure	
CREATE OR REPLACE
procedure P_TRS_RESET_TASK_SEQ AS
  n    NUMBER(10);
  tsql VARCHAR2(100);
begin
    
  EXECUTE IMMEDIATE 'select SEQ_TRS_TASK_NUMBER.nextval from dual'
    INTO n;
  n    := - (n);
  tsql := 'alter sequence SEQ_TRS_TASK_NUMBER increment by ' || n; -- 下一次增加的量(負數)
  EXECUTE IMMEDIATE tsql;
  EXECUTE IMMEDIATE 'select  SEQ_TRS_TASK_NUMBER.nextval from dual' -- 增加完回到0
    INTO n;
  tsql := 'alter sequence SEQ_TRS_TASK_NUMBER increment by 1'; -- 增加的量改回1
  EXECUTE IMMEDIATE tsql;
end;