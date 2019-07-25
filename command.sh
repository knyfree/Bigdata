datalake@hn0-cgidat:/datalake/java$ javac -cp '/datalake/java/lib/hive-exec-2.1.0.2.6.5.3008-11.jar' '/datalake/java/src/lowercase.java' -d '/datalake/java/bin'
datalake@hn0-cgidat:/datalake/java$ ll /datalake/java/bin/
total 20
drwxrwxr-x 2 datalake datalake 4096 Jun 20 05:05 ./
drwxrwxr-x 7 datalake datalake 4096 Jun 20 05:05 ../
-rw-rw-r-- 1 datalake datalake  656 Jun 20 04:32 hive_UDF.class
-rw-rw-r-- 1 datalake datalake  656 Jun 20 05:10 lowercase.class
-rw-rw-r-- 1 datalake datalake  656 Jun 20 04:53 uppercase.class
datalake@hn0-cgidat:/datalake/java$ jar -cvmf /datalake/java/conf/manifest.txt /datalake/java/UDF_jar/lowercase.jar /datalake/java/bin/lowercase.class
added manifest
adding : datalake/java/bin/lowercase.class(in = 658) (out= 440)(deflated 33%)
datalake@hn0-cgidat:/datalake/java$ ll /datalake/UDF_jar/
total 20
drwxrwxr-x 2 datalake datalake 4096 Jun 20 04:48 ./
drwxrwxr-x 7 datalake datalake 4096 Jun 20 05:10 ../
-rw-rw-r-- 1 datalake datalake  656 Jun 20 01:50 hive_UDF.jar
-rw-rw-r-- 1 datalake datalake  656 Jun 20 05:11 lowercase.jar
-rw-rw-r-- 1 datalake datalake  656 Jun 20 04:53 uppercase.jar
datalake@hn0-cgidat:/datalake/java$


datalake@hn0-cgidat:/datalake/java/bin$ hive

Logging initialized using configuration in file:/etc/hive/2.6.5.3008-11/0/hive-log4j.properties

hive> add jar wasbs://cgidatalake-dev-cluster@cgidatalake.blob.core.windows.net/datalake/java/UDF_jar/hive_UDF.jar;
converting to local wasbs://cgidatalake-dev-cluster@cgidatalake.blob.core.windows.net/datalake/java/UDF_jar/hive_UDF.jar
Added [/tmp/51d6ba15-d29e-47be-a237-0c8053c6eb73_resources/hive_UDF.jar] to class path
Added resources: [wasbs://cgidatalake-dev-cluster@cgidatalake.blob.core.windows.net/datalake/java/UDF_jar/hive_UDF.jar]
hive> create temporary function tolower as 'hive_UDF';
OK
Time taken: 3.708 seconds
hive> select tolower('AAAAAA');
OK
aaaaaa
Time taken: 1.815 seconds, Fetched: 1 row(s)
hive>






datalake@hn0-cgidat:/datalake/source/test$ ll
total 24
drwxrwxr-x 2 datalake datalake 4096 Jun 18 00:24 ./
drwxrwxr-x 7 datalake datalake 4096 Jun 11 00:15 ../
-rw-rw-r-- 1 datalake datalake 1613 Jun 11 00:16 coordinator.xml
-rw-rw-r-- 1 datalake datalake 1154 Jun 11 00:27 job.properties
-rw-rw-r-- 1 datalake datalake   75 Jun 11 00:16 test.sh
-rw-rw-r-- 1 datalake datalake  863 Jun 11 00:16 workflow.xml
datalake@hn0-cgidat:/datalake/source/test$ 
datalake@hn0-cgidat:/datalake/source/test$ hadoop fs -put ./* /datalake/source/test/
put: `/datalake/source/test/coordinator.xml': File exists
put: `/datalake/source/test/job.properties': File exists
put: `/datalake/source/test/test.sh': File exists
put: `/datalake/source/test/workflow.xml': File exists
datalake@hn0-cgidat:/datalake/source/test$ 
datalake@hn0-cgidat:/datalake/source/test$ hadoop fs -put -f ./* /datalake/source/test/
datalake@hn0-cgidat:/datalake/source/test$ 
datalake@hn0-cgidat:/datalake/source/test$ hadoop fs -ls /datalake/source/test/
Found 4 items
-rw-r--r-- 1 datalake supergroup         1613 2019-06-18 00:27 /datalake/source/test/coordinator.xml
-rw-r--r-- 1 datalake supergroup         1154 2019-06-18 00:27 /datalake/source/test/job.properties
-rw-r--r-- 1 datalake supergroup           75 2019-06-18 00:27 /datalake/source/test/test.sh
-rw-r--r-- 1 datalake supergroup          863 2019-06-18 00:27 /datalake/source/test/workflow.xml
datalake@hn0-cgidat:/datalake/source/test$ 
datalake@hn0-cgidat:/datalake/source/test$ oozie job -config ./job.properties -run
job: 0000006-190605071939635-oozie-oozi-C
datalake@hn0-cgidat:/datalake/source/test$ 