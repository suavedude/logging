#!/bin/bash
#v1.1
#2018-04-20 Hims
#########################################################
#                   DELPHIX CORP                        #
#########################################################

#########################################################
#Parameter Intialization

DMIP=0.0.0.0
DMPORT=8282
DMUSER=$username
DMPASS=$password
STATUS=""
JOBSTATUS=""
LOCALAUDITLOGPATH="./Delphix_AUDIT_Log_$(date +%Y%m%d%T).log"
LOCALSYSLOGPATH="./Delphix_SYSTEM_Log_$(date +%Y%m%d%T)"
FILEDOWNLOADIDSTR=""
FILEDOWNLOADIDARR=""
COUNTER=0

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
curl -X GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/audit-logs?action_type=GET_ALL&page_number=1" -o ${LOCALAUDITLOGPATH}

########################################################
##   get System Log ID and download file
STATUS=`curl -X GET --header 'Accept: application/json' --header "Authorization: ${myLoginToken}" "${DMURL}/application-logs?log_level=INFO&page_number=1&page_size=999"`
FILEDOWNLOADIDSTR=`echo "${STATUS}" | jq --raw-output ".responseList[].fileDownloadId"`
FILEDOWNLOADIDARR=$FILEDOWNLOADIDSTR

for FILEDOWNLOADIDARR in $FILEDOWNLOADIDSTR
do
  echo $COUNTER "FILEDOWNLOADIDARR"  $FILEDOWNLOADIDARR
  curl -X GET --header 'Accept: application/octet-stream' --header "Authorization: ${myLoginToken}" "${DMURL}/file-downloads/$FILEDOWNLOADIDARR" -o ${LOCALSYSLOGPATH}_${COUNTER}.log
  COUNTER=$((COUNTER+1))
done
############## E O F ####################################
