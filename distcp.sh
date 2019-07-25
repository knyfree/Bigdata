


datalake@hn0-cgidat:~$ hadoop distcp hdfs://quickstart.cloudera:8020/user/access_logs hdfs://quickstart.cloudera:8020/user/destination_access_logs
19/07/02 13:28:07 INFO tools.DistCp: Input Options: DistCpOptions{atomicCommit=false, syncFolder=false, deleteMissing=false, ignoreFailures=false, maxMaps=20, sslConfigurationFile='null', copyStrategy='uniformsize', sourceFileListing=null, sourcePaths=[hdfs://quickstart.cloudera:8020/user/access_logs], targetPath=hdfs://quickstart.cloudera:8020/user/destination_access_logs, targetPathExists=false, preserveRawXattrs=false, filtersFile='null'}
19/07/02 13:28:07 INFO client.AHSProxy: Connecting to Application History server at headnodehost/10.26.3.150:10200
19/07/02 13:28:08 INFO tools.SimpleCopyListing: Paths (files+dirs) cnt = 57; dirCnt = 17
19/07/02 13:28:08 INFO tools.SimpleCopyListing: Build file listing completed.
19/07/02 13:28:08 INFO tools.DistCp: Number of paths in the copy list: 57
19/07/02 13:28:08 INFO tools.DistCp: Number of paths in the copy list: 57
19/07/02 13:28:08 INFO client.AHSProxy: Connecting to Application History server at headnodehost/10.26.3.150:10200
19/07/02 13:28:08 INFO client.RequestHedgingRMFailoverProxyProvider: Looking for the active RM in [rm1, rm2]...
19/07/02 13:28:08 INFO client.RequestHedgingRMFailoverProxyProvider: Found active RM [rm2]
19/07/02 13:28:09 INFO mapreduce.JobSubmitter: number of splits:5
19/07/02 13:28:09 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1449017643353_0001
19/07/02 13:28:10 INFO impl.YarnClientImpl: Submitted application application_1449017643353_0001
19/07/02 13:28:10 INFO mapreduce.Job: The url to track the job: http://hn1-cgidat.hqopqijuxyoezdcry3gyzzqh5e.syx.internal.cloudapp.net:8088/proxy/application_1449017643353_0001/
19/07/02 13:28:10 INFO tools.DistCp: DistCp job-id: job_1449017643353_0001
19/07/02 13:28:10 INFO mapreduce.Job: Running job: job_1449017643353_0001
19/07/02 13:28:20 INFO mapreduce.Job: Job job_1449017643353_0001 running in uber mode : false
19/07/02 13:28:20 INFO mapreduce.Job:  map 0% reduce 0%
19/07/02 13:28:32 INFO mapreduce.Job:  map 50% reduce 0%
19/07/02 13:28:34 INFO mapreduce.Job:  map 100% reduce 0%
19/07/02 13:28:34 INFO mapreduce.Job: Job job_1449017643353_0001 completed successfully
19/07/02 13:28:35 INFO mapreduce.Job: Counters: 34
	File System Counters
		FILE: Number of bytes read=0
		FILE: Number of bytes written=228770
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=39594819
		HDFS: Number of bytes written=39593868
		HDFS: Number of read operations=0
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=0
	Job Counters 
		Launched map tasks=5
		Other local map tasks=5
		Total time spent by all maps in occupied slots (ms)=20530
		Total time spent by all reduces in occupied slots (ms)=0
		Total time spent by all map tasks (ms)=20530
		Total vcore-seconds taken by all map tasks=20530
		Total megabyte-seconds taken by all map tasks=21022720
	Map-Reduce Framework
		Map input records=57
		Map output records=0
		Input split bytes=650
		Spilled Records=0
		Failed Shuffles=0
		Merged Map outputs=0
		GC time elapsed (ms)=1123
		CPU time spent (ms)=42680
		Physical memory (bytes) snapshot=257175552
		Virtual memory (bytes) snapshot=3006455808
		Total committed heap usage (bytes)=121503744
	File Input Format Counters 
		Bytes Read=60720
	File Output Format Counters 
		Bytes Written=0
	org.apache.hadoop.tools.mapred.CopyMapper$Counter
		BYTESCOPIED=39593868
		BYTESEXPECTED=39593868
		COPY=2
        DIR_COPY=17
datalake@hn0-cgidat:~$ 