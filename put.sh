#!/bin/sh

path=`pwd`

# HDFS 경로 확인
hdfs_path=wasbs://cgidevdatalake-container@cgidevdatalake.blob.core.windows.netecho $path
target_hdfs=${hdfs_path}${path}

# HDFS에 디렉토리 생성여부 체크
if $(hadoop fs -test -d ${target_hdfs} ) ; then
        echo "HDFS Directory Exists. " 
        hadoop fs -put -f ${path}/* ${target_hdfs}/
else
        echo "HDFS Directory Not Exists. Mkdir path : ${target_hdfs}"
        hadoop fs -mkdir -p ${target_hdfs}        # 위 디렉토리 생성명령어가 잘 처리되었는지 한번더 체크
        if $(hadoop fs -test -d ${target_hdfs} ) ; then
                echo "Mkdir Command Success. HDFS Directory Exists."
                hadoop fs -put -f ${path}/* ${target_hdfs}/
        else                echo "Mkdir Command Failed. Check Your Path or Command."
                exit 9
        fi
fi
# Check HDFS File List
hadoop fs -ls ${target_hdfs}/