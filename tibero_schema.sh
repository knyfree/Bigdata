#!/bin/bash

cdc_path=wasbs://cgidatalake-dev-cluster@cgidevdatalake.blob.core.windows.net/datalake/data/cdc
dibs_path=wasbs://cgidatalake-dev-cluster@cgidevdatalake.blob.core.windows.net/datalake/data/dibs
TO_DATE=`date -u +\%Y-\%m-\%d`

# 티베로 DB에 Sqoop으로 User의 테이블 정보를 조회해서 파일로 저장
# 쿼리의 내용은 Aggr_Concat로 Array형태로 담아서 Table_Name  |   col1, col2, col3, col4 같은 형태로 변환함
sqoop eval --driver com.tmax.tibero.jdbc.TbDriver --connect jdbc:tibero:thin:@D-distagingdb.carrotins.com:8629:CGISTGDEV --username "cgistg" --password "q1w2e3#stg" --query "SELECT A.TABLE_NAME, Aggr_Concat(A.COLUMN_NAME,',' ORDER BY A.COLUMN_ID) as a FROM ( SELECT TABLE_NAME, COLUMN_NAME, COLUMN_ID FROM USER_TAB_COLUMNS GROUP BY TABLE_NAME, COLUMN_NAME, COLUMN_ID ORDER BY TABLE_NAME, COLUMN_NAME, COLUMN_ID ASC ) A GROUP BY A.TABLE_NAME" > /datalake/ddl/tibero_schema_result.log

echo "" > /datalake/ddl/crt_cdc_table.hql
echo "" > /datalake/ddl/crt_dibs_table.hql
echo "" > /datalake/ddl/dw_insert.hql

while read F ; do
    table_nm=""
    col_nm=""
    #echo ">>>>   $F"
    # 테이블명을 첫번째 딜리미터로 추출, 공백제거, 소문자로 치환
    table_nm=`echo "$F" | awk -F'|' '{print $2}' | grep -v 'TABLE_NAME' | awk '{gsub(/^ +| +$/,"")} {print $0}' | tr '[:upper:]' '[:lower:]'`
    # 컬럼을 두번째 딜리미터로 추출, 공백제거
    col_nm=`echo "$F" | awk -F'|' '{print $3}' | awk '{gsub(/^ +| +$/,"")} {print $0}'


    # 컬럼의 값이 null이 아니라면
    if [ "${col_nm}" != "" ]; then
        echo "not null"
        # 사용자 편의를 위한 구분짓기 위한 공백추가
        echo "" >> /datalake/ddl/crt_cdc_table.hql
        # hive의 형식에 맞게 생성문을 추가
        echo "CREATE EXTERNAL TABLE CDC.${table_nm} (" >> /datalake/ddl/crt_cdc_table.hql
        # col1, col2, col3, col4 의 형태를 hive의 생성문에 맞게 , ->  string , 로 변경하고 각 컬럼별 줄바꿈 추가
        echo "${col_nm} string )" | sed 's/,/ string, /g' | sed -e "s/,/\\
, /g" >> /datalake/ddl/crt_cdc_table.hql
        # Array로 담아왔으므로 딜리미터를 , (comma) 로 지정
        echo "ROW FORMAT DELIMITED FIELDS TERMINATED BY ','" >> /datalake/ddl/crt_cdc_table.hql
        # hive 테이블 경로를 지정 (표준이 바뀌면 변경해줘야함)
        echo "LOCATION '${cdc_path}/${table_nm}';" >> /datalake/ddl/crt_cdc_table.hql
        echo "" >> /datalake/ddl/crt_cdc_table.hql
        # sqoop 명령어를 사용하고 싶다면 아래 주석 해제
        #echo "sqoop import --driver com.tmax.tibero.jdbc.TbDriver --connect jdbc:tibero:thin:@D-distagingdb.carrotins.com:8629:CGISTGDEV --table ${table_nm} --username 'cgistg' --password 'q1w2e3#stg' --target -dir ${cdc_path}/${table_nm} -m 10" >> /datalake/ddl/crt_cdc_table.hql

        echo "CREATE EXTERNAL TABLE DIBS.${table_nm} (" >> /datalake/ddl/crt_dibs_table.hql
        echo "${col_nm} string )" | sed 's/,/ string, /g' | sed -e "s/,/\\
, /g" >> /datalake/ddl/crt_dibs_table.hql
        echo "PARTITIONED BY (LOAD DT STRING)" >> /datalake/ddl/crt_dibs_table.hql
        echo "ROW FORMAT DELIMITED FIELDS TERMINATED BY ','" >> /datalake/ddl/crt_dibs_table.hql
        echo "STORED AS ORC" >> /datalake/ddl/crt_dibs_table.hql
        echo "LOCATION '${dibs_path}/${table_nm}';" >> /datalake/ddl/crt_dibs_table.hql
        echo "" >> /datalake/ddl/crt_dibs_table.hql

        echo "INSERT OVERWRITE TABLE DIBS.${table_nm} PARTITION (LOAD_DT='${TO_DATE}')" >> /datalake/ddl/dw_insert.hql
        echo "SELECT pNVL(${col_nm}) FROM CDC.${table_nm}; " | sed -e "s/,/)\\
, pNVL(/g" >> /datalake/ddl/dw_insert.hql
        echo "" >> /datalake/ddl/dw_insert.hql
    # 컬럼의 값이 null 이면
    else echo "null"
    fi
# 테이블 정보를 조회해서 파일로 저장한 파일을 loop로 읽음
done < /datalake/ddl/tibero_schema_result.log

exit 0