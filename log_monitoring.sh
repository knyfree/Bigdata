#!/bin/bash

#Variable : $1 채널명 $2 로그포맷명 $3 output 테이블명


var_chck=`expr $# % 3`
var_tot=`expr $#`

if [ $var_chck -eq 0 -a $var_tot -gt 1 ]; then
        array=( "$@" )
else
        echo "Check your variable."
        echo '** USE CASE : log_monitoring.sh arg1: 채널명 arg2:로그포맷명 arg3:테이블명 **'
        exit 1
fi

#echo "총 변수값 ${var_tot} ,  변수 내용 : ${array[@]}"

channel=""
file_format=""
out_format=""

count=1

# 3배수갯수만큼 돌기위함
for variable in ${array[@]}
do
        flag=`expr $count % 3`

        #echo $flag
        #echo $variable

        case $flag  in
            1) channel="$variable" file_format="" out_format="" ;;
            2) file_format="$variable" ;;
            0) out_format="$variable"
                zeroSizeFileName=`find /home/sshuser/log/20190424/$channel/ -maxdepth 1 -size 0 -type f -ls | awk '{print $11}'`
                logFileName=`find /home/sshuser/log/20190424/$channel/ -maxdepth 1 -type f -ls | awk '{print $11}'`
#               echo $zeroSizeFileName
#               echo $logFileName
                # 0 사이즈 파일이 존재하지 않는다.
                if [ -z "$zeroSizeFileName" ]; then
                        echo "0 Size File Not Exits."

                        # 로그파일이 존재하지 않는다.
                        if [ -z "$logFileName" ]; then
                                echo "Log File Not Exits."
                                exit 1
                        # 로그파일이 존재한다. - HDFS에 Done 파일 남김
                        else
                                echo "Log File Exits."
                                echo "hadoop fs -touchz /log/touch/${channel}/20190424/${file_format}.done"
                        fi
                # 0 사이즈 파일이 존재한다. error 처리
                else
                        echo "0 Size File Exits."
                        exit 1
                fi
                 ;;

        esac

        let count=count+1

done