#!/bin/bash
#Script v1.7
# Delphix version 6.0.1.1 +
#Created: 2018-04-20 Hims
#last Edited 2020-05-07 Hims
#########################################################
#                   DELPHIX CORP                        #
#########################################################

#########################################################
#Parameter Intialization

#DMIP=jjh-5351-masking.dc4.delphix.com
DMIP=0.0.0.0
DMPORT=80
DMUSER=******
DMPASS=******
LOCALAUDITLOGPATH="./Delphix_AUDIT_Log_$(date +%Y%m%d%T).log"
LOCALSYSLOGPATH="./Delphix_SYSTEM_Log_$(date +%Y%m%d%T)"

STATUS=""
JOBSTATUS=""
FILEDOWNLOADIDSTR=""
FILEDOWNLOADIDARR=""
COUNTER=1   #page count starts with 1
LOGLEVEL=""
ERRORMESSAGE=""
NUMBERONPAGE=0
CUMULATIVEONPAGE=0
TOTALONPAGE=0

#########################################################
##   Login authetication and autokoen capture
#DMURL="http://${DMIP}:${DMPORT}/masking/api"
DMURL="http://${DMIP}/masking/api"
echo "Authenticating on ${DMURL}"

STATUS=`curl -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{ \"username\": \"${DMUSER}\", \"password\": \"${DMPASS}\" }" "${DMURL}/login"`
#echo ${STATUS} | jq "."
myLoginToken=`echo "${STATUS}" | jq --raw-output '.Authorization'`

if [  $myLoginToken == null ];then
        echo "Authentication FAILED : LoginToken" $myLoginToken
else
        echo "Authentication SUCCESS : LoginToken" $myLoginToken
fi

########################################################
##   get Audit Logs
STATUS=`curl -sX GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/audit-logs?action_type=GET_ALL&page_number=1&page_size=999"`
NUMBERONPAGE=`echo "${STATUS}" | jq --raw-output "._pageInfo.numberOnPage"`
TOTALONPAGE=`echo "${STATUS}" | jq --raw-output "._pageInfo.total"`
echo Intial Current Page Entries ${NUMBERONPAGE} and Total Audit LogEntries: ${TOTALONPAGE}

while [ $CUMULATIVEONPAGE -lt $TOTALONPAGE ]
do
  STATUS=`curl -sX GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/audit-logs?action_type=GET_ALL&page_number=${COUNTER}&page_size=999"`
  NUMBERONPAGE=`echo "${STATUS}" | jq --raw-output "._pageInfo.numberOnPage"`
  CUMULATIVEONPAGE=$(($CUMULATIVEONPAGE+$NUMBERONPAGE))
  curl -sX GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/audit-logs?action_type=GET_ALL&page_number=${COUNTER}&page_size=999" >> ${LOCALAUDITLOGPATH}
  COUNTER=$((COUNTER+1))
  echo CUMULATIVE AUDIT ENTRIES : ${CUMULATIVEONPAGE} TOTAL ENTRIES : ${TOTALONPAGE} PAGE NUMBER : ${COUNTER}
done

########################################################
##   get System Log ID and download file

#Function to generate files
genSysLogFile(){
  echo Counter Number: $COUNTER Log Level: $LOGLEVEL
  FILEDOWNLOADIDSTR=""
  FILEDOWNLOADIDARR=""
  STATUS=`curl -sX GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/application-logs?log_level=${LOGLEVEL}&page_number=1&page_size=999"`
  FILEDOWNLOADIDSTR=`echo "${STATUS}" | jq --raw-output ".responseList[].fileDownloadId"`
  FILEDOWNLOADIDARR=$FILEDOWNLOADIDSTR

  for FILEDOWNLOADIDARR in $FILEDOWNLOADIDSTR
    do
      echo Log Level: ${LOGLEVEL} File Number: $COUNTER File ID: $FILEDOWNLOADIDARR
      curl -sX GET --header 'Accept: application/octet-stream' --header "Authorization: ${myLoginToken}" "${DMURL}/file-downloads/$FILEDOWNLOADIDARR" >> ${LOCALSYSLOGPATH}.${LOGLEVEL}.log
      COUNTER=$((COUNTER+1))
    done
    echo Loglvel $LOGLEVEL file is ${LOCALSYSLOGPATH}.${LOGLEVEL}.log
  } #end of fucntion

## INFO Loglevel
COUNTER=0
LOGLEVEL="INFO"
genSysLogFile $COUNTER $LOGLEVEL

## WARN Loglevel
COUNTER=0
LOGLEVEL="WARN"
genSysLogFile $COUNTER $LOGLEVEL

## ERROR Loglevel
COUNTER=0
LOGLEVEL="ERROR"
genSysLogFile $COUNTER $LOGLEVEL

## DEBUG Loglevel
COUNTER=0
LOGLEVEL="DEBUG"
genSysLogFile $COUNTER $LOGLEVEL

############## E O F ####################################
