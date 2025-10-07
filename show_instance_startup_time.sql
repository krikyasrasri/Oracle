-- #############################################################################################
--
-- %Purpose: Show Startup Time of the Oracle Instance (Different for Ora7 and Ora8: V$INSTANCE)
--
-- #############################################################################################
--
-- Instance Startup-Time for Oracle-7
--
SELECT TO_CHAR(TO_DATE(D.Value,'J'),'DD.MM.YYYY')||' '||
       TO_CHAR(TO_DATE(S.Value,'SSSSS'),'HH24:MI:SS')
          Startup_Time
  FROM V$INSTANCE D, V$INSTANCE S
 WHERE D.Key = 'STARTUP TIME - JULIAN'
   AND S.Key = 'STARTUP TIME - SECONDS';
--
-- Instance Startup-Time for Oracle-8
--
SELECT TO_CHAR(startup_time,'DD.MM.YYYY:HH24:MI:SS') Startup_Time
  FROM v$instance;
