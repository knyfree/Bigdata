#!/bin/sh

#sql 파일 초기화

to_date=`date -u +\%Y\%m\%d`
output_sql=/home/datalake/hive_schema_${to_date}.sql


to_date=`date -u +\%Y\%m\%d`
output_sql=/home/datalake/hive_schema_${to_date}.sql

echo "" > ${output_sql}

# 데이터베이스 loop
for d in `hive -e "show databases"`;
do
  #데이터베이스명 대문자로 변경
  #d=echo "$d" | tr '[:lower:]' '[:upper:]'

  echo "create database $d; use $d;" >> ${output_sql} ;
        # 테이블 loop
        for t in `hive --database $d -e "show tables"` ;
        # 테이블 ddl 조회
        do
                #테이블명 대문자로 변경
                #t=echo "$t" | tr '[:lower:]' '[:upper:]'
                #hive session 연결 및 table 정보 조회
                ddl=`hive --database $d -e "show create table $t"`;
                #table 정보 정제 작업
                ddl=$(printf "$ddl" | sed "s/TABLE \`/TABLE ${d}./g")
                ddl=$(printf "$ddl" | sed 's/`//g')
                #테이블 구분                                                           이블을 조회하고자 할때 사용
                echo " " >> ${output_sql}                                             t ;" >> ${output_sql} ;
                #테이블 정보 입력
                echo "$ddl" >> ${output_sql} ;
                #파티션 정보 및 테이블프로퍼티 입력 모든 테이블이 아니라 조건에 따른 
테이블을 조회하고자 할때 사용
                #echo "$ddl" | grep -q "PARTITIONED\s*BY" && echo "MSCK REPAIR TABLE $
t ;" >> ${output_sql} ;
                #실행을 위해 쿼리 구분
                echo ";" >> ${output_sql}
        done;
done