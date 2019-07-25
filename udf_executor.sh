#!/bin/bash

# Hive UDF 파일명
udf_lib_name="hive-exec-2.1.0.2.6.5.3008-11.jar"

# path
lib_path="/datalake/java/lib"                 # 라이브러리 경로 (추가 라이브러리 여기에 위치)
f_lib=${lib_path}/${udf_lib_name}             # 라이브러리 경로 + 파일명
java_src_path="/datalake/java/src"            # java 파일 경로 (java 파일생성후 아래에 위치해야됨)
java_bin_path="/datalake/java/bin"            # class 파일 경로 (자동으로 class 파일 생성됨)
manifest_path="/datalake/java/conf"           # Runnable jar를 만들기 위해 main() 함수가 어떤 클래스에 있는지 위치를 지정해주는데, mainfest가 그역할
output_path="/datalake/java/UDF_jar"          # Runnable jar가 생성될 경로

f_java_name=$1                                # java 파일명 ex. lowercase.java
java_name=`echo ${f_java_name} | awk -F'.' '{print $1}'`  # java 파일의 확장자를 제외한 파일명만 추출

# javac -cp '참조 jar 위치' 'java파일' 'class 저장 경로' Java 파일을 class 파일로 컴파일
javac -cp "${f_lib}" "${java_src_path}/${f_java_name}" -d "${java_bin_path}/"

# Jar 파일 생성을 위한 manifest 파일생성 (기존에 존재하더라도 엎어침)
echo "Main-Class: ${java_name}" > ${manifest_path}/manifest.txt

# class 파일을 Runnable jar로 생성
jar -cvmf ${manifest_path}/manifest.txt ${output_path}/${java_name}.jar ${java_bin_path}/${java_name}.class

exit 0