#!/bin/sh
############################################
# Name: ggs_monitor.sh #
# PURPOSE: TO MONITOR LAG OF GOLDEN GATE #
# NOTE: THIS SCRIPT CALLS ggs.ksh #
# THIS SCRIPT NOTIFY IF LAG IS MORE THEN 30 MIN #
# ONLY FOR FOR EXT AND PMP PROCESS GROUP #
# USAGE: ggs_monitor.ksh <sid> <limit minutes> <GG HOME>
###########################################

mkdir -p /u01/app/ogg/scripts/logs 2>/dev/null
export SCRIPT_DIR=/l
LOGDIR=/u01/app/ogg/scripts/logs
EMAILFile=$LOGDIR/email_file.log
BOX=$(uname -a | awk '{print $2}')
#EMAILLIST=EBSOracleData@intuit.com
EMAILLIST=jaspreet_singh@intuit.com
export LOGFILE=$LOGDIR/webs_gg_monitor_heartbeat_tab.log
export AWS_DEFAULT_REGION=us-west-2
export ORACLE_SID=$1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.1

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$ORACLE_HOME/lib32:/usr/lib:/u01/app/ogg

printf "\n************************************************************" > ${LOGFILE}
printf "\n AWS WEBS PROD GG Monitoring via Heartbeat Table " >> ${LOGFILE}
printf "\n************************************************************\n" >> ${LOGFILE}
DB_USER=`grep USER ${SCRIPT_DIR}/.db_info | awk -F"=" '{print $2}'`
DB_PW=`grep pw ${SCRIPT_DIR}/.db_info | awk -F"=" '{print $2}'`
DB_SERVICE=`grep service ${SCRIPT_DIR}/.db_info | awk -F"=" '{print $2}'`

$ORACLE_HOME/bin/sqlplus -s ${DB_USER}/${DB_PW}@${DB_SERVICE} << EOF >/dev/null
set heading on echo off feedback off termout off 
spool ${LOGDIR}/gg_lag.log
@${SCRIPT_DIR}/gg_lag.sql
spool off
EOF

if [ $? -ne 0 ]; then
printf "\nERROR: connecting to database, please check db is running and env variables are set properly \n" >> ${LOGFILE}
fi

if [ `cat ${LOGDIR}/gg_lag.log | wc -l` -gt 0 ]; then
cat ${LOGDIR}/gg_lag.log >> ${LOGFILE} 
/usr/bin/aws sns publish --topic-arn arn:aws:sns:us-west-2:384043330046:T4I-PROD-DBOPS_AWS-ALERT --subject "CRITICAL:Latency is more than 5 mins on WEBS PROD GG HUB  $(hostname)" --message "`cat ${LOGFILE}`"
else
   echo "All is working!!! "
   echo "All is working!!! " >> ${LOGFILE}
fi



