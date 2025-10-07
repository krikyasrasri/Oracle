set verify off
set feed off
set pagesize 0
set lines 150
set serveroutput on
alter session set time_zone = 'America/Los_Angeles';
--
DECLARE
--
v_Group_Name       VARCHAR2(8);
v_Current_Time     TIMESTAMP;
v_Statement        VARCHAR2(4000);
--
BEGIN
--
select current_timestamp AT TIME ZONE 'America/Los_Angeles' into v_Current_Time from dual;
--
-- Create insert statements
--
   v_Statement := 'insert into ebs.websaws_heartbeat_tbl (group_name, src_ins_date) values ' || '(' || CHR(39) || 'E1WBSPRD'|| CHR(39) || ', :1 )'   ;
   EXECUTE IMMEDIATE v_Statement using v_Current_Time;

--

v_Statement := 'commit';
EXECUTE IMMEDIATE v_Statement;

--

EXCEPTION

WHEN OTHERS THEN
   v_Statement := 'commit';
   EXECUTE IMMEDIATE v_Statement;

END;
/

