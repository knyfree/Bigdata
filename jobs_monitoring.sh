#!/bin/sh
 
#oozie rest api 를 이용한 모니터링 스크립트
to_date=`date -u +\%Y\%m\%d`
json_coord=oozie_coord_list_${to_date}.json
json_work=oozie_work_list_${to_date}.json
monitoring_shell_path=/home/datalake/oozie_monitoring
 
 
# COORDINATOR
echo "" > "${monitoring_shell_path}/${json_coord}"
curl 'http://hn0-cgidev:11000//oozie/v1/jobs?f/v1/jobs?filter=user%3Ddatalake&jobtype=coord&len=2000' | jq '.coordinatorjobs[] | {c_name: .coordJobName, c_id : .coordJobId, status: .status, user: .user}' >> ${monitoring_shell_path}/${json_coord}
 
# WORFLOW
echo "" > "${monitoring_shell_path}/${json_work}"
curl 'http://hn0-cgidev:11000//oozie/v1/jobs?f/v1/jobs?filter=user%3Ddatalake&len=2000' | jq '.workflows[] | {w_name: .appName, w_id: .id, status: .status, user: .user}' >> ${monitoring_shell_path}/${json_work}
 
echo "-----------------COORDINATOR------------------"
cat ${monitoring_shell_path}/${json_coord} | grep -A2 -B2 KILLED | sed "s/\"//g" | sed "s/}/-----------------------------------------/g"#cat ${monitoring_shell_path}/${json_coord} | grep -A2 -B2 SUCCEED | sed "s/\"//g" | sed "s/}/-----------------------------------------/g"
 
echo "" 
 
echo "-------------------WORKFLOW-------------------"cat "${monitoring_shell_path}/${json_work}" | grep -A2 -B3 KILLED | sed "s/\"//g" | sed "s/{/-----------------------------------------/g" | sed "s/}/-----------------------------------------/g"#cat "${monitoring_shell_path}/${json_work}" | grep -A2 -B3 SUCCEED | sed "s/\"//g" | sed "s/{/-----------------------------------------/g" | sed "s/}/-----------------------------------------/g"
exit 0
