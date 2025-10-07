set feedback off heading off
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MON-DD HH24:MI:SS';
select latency_in_mins from (
SELECT group_name,
       TO_DATE (TO_CHAR (src_ins_date, 'YYYY-MON-DD HH24:MI:SS'),
                'YYYY-MON-DD HH24:MI:SS')
           AS src,
       TO_DATE (TO_CHAR (tgt_ins_date, 'YYYY-MON-DD HH24:MI:SS'),
                'YYYY-MON-DD HH24:MI:SS')
           AS tgt,
       ROUND (
             ((  SYSDATE
               - TO_DATE (TO_CHAR (src_ins_date, 'YYYY-MON-DD HH24:MI:SS'),
                          'YYYY-MON-DD HH24:MI:SS')))
           * 24
           * 60)
           latency_in_mins
  FROM ebs.websihp_heartbeat_tbl
 WHERE     group_name || src_ins_date IN
               (  SELECT group_name || MAX (src_ins_date)
                    FROM ebs.websihp_heartbeat_tbl
                GROUP BY group_name)
       AND ROUND (
                 ((  SYSDATE
                   - TO_DATE (
                         TO_CHAR (src_ins_date, 'YYYY-MON-DD HH24:MI:SS'),
                         'YYYY-MON-DD HH24:MI:SS')))
               * 24
               * 60) <=
           5
);
