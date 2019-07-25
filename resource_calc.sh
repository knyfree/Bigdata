#!/bin/sh

echo " <-- 서버별 리소스 >"
NumOfNodes=3     ##  (노드 개수)
NumofCPUCores=4  ##  (CPU 물리 코어 개수)
TotMemSizes=32   ##  (메모리 크기)
NumOfDisk=8      ##  (디스크 개수)
TotServer=5      ##  (전체 서버 대수)

#NumOfNodes=3     ##  (노드 개수)
#NumofCPUCores=4  ##  (CPU 물리 코어 개수)
#TotMemSizes=32   ##  (메모리 크기)
#NumOfDisk=8      ##  (디스크 개수)
#TotServer=5      ##  (전체 서버 대수)

echo "노드 개수 : $NumOfNodes ,     \
CPU 물리 코어 개수 : $NumofCPUCores ,    \
메모리 크기 : $TotMemSizes G ,    \
디스크 개수 : $NumOfDisk ,    \
전체 서버 대수 : $TotServer  "

echo ""
echo "mapreduce.map.cpu.vcores=1"
echo "mapreduce.reduce.cpu.vcores=1"

mapreduce_map_memory_mb=3072
mapreduce_reduce_memory_mb=3072
yarn_app_mapreduce_am_resource_mb=3072
yarn_scheduler_maximum_allocation_mb=28672
yarn_nodemanager_resource_memory_mb=28672

echo ""

echo "컨테이너 할당용 메모리 크기 = 서버 메모리 크기 - (얀을 제외한 다른 소프트웨어들이 사용할 메모리 크기)"

container_mem=`expr ${TotMemSizes} - 10`

echo "노드매니저가 컨테이너 할당에 사용할 메모리 크기 = ${container_mem} G "

echo " --> yarn.nodemanager.resource.memory-mb = `expr ${container_mem} \* 1024`"
echo " NumofCPUCoresPerContainer= MIN( `expr ${NumofCPUCores} - 2`, `expr 2 \* ${NumOfDisk}` ) "

NumofCPUCoresPerContainer=""

if [ "`expr ${NumofCPUCores} - 2`" -gt "`expr 2 \* ${NumOfDisk}`" ]; then
      NumofCPUCoresPerContainer=`expr 2 \* ${NumOfDisk}`
else  NumofCPUCoresPerContainer=`expr ${NumofCPUCores} - 2`
fi

echo " --> NumofCPUCoresPerContainer= $NumofCPUCoresPerContainer"


echo "컨테이너 할당용 CPU 코어 개수 = ${NumofCPUCoresPerContainer}  **노드매니저가 컨테이너 할당에 사용할 CPU 코어 개수 (vCores)"
echo " --> yarn.nodemanager.resource.cpu-vcores = ${NumofCPUCoresPerContainer}"
echo " --> YARN_NODEMANAGER_HEAPSIZE= ( `expr ${container_mem} + 1` ) G  -- yarn-env.sh 수정"

echo ""

echo "mapreduce.map.memory.mb=${mapreduce_map_memory_mb}      속성은 맵 태스크가 요청하는 컨테이너 메모리 크기"
echo "mapreduce.reduce.memory.mb=${mapreduce_reduce_memory_mb}  리듀스 태스크가 요청하는 컨테이너 메모리 크기"
echo "yarn.app.mapreduce.am.resource.mb=${yarn_app_mapreduce_am_resource_mb}  "
echo "yarn.scheduler.maximum-allocation-mb=${yarn_scheduler_maximum_allocation_mb}   ResourceManager가 하나의 컨테이너 할당에 필요한 최
대 메모리 크기"

echo "mapreduce_map_memory_mb + mapreduce.reduce.memory.mb + yarn.app.mapreduce.am.resource.mb < yarn.nodemanager.resource.memory-mb"
#echo "        2G              +            4G              +                  1.5G             <               150G    -- true "

echo ""

mapreduce_map_java_opts_max_heap=`echo "${mapreduce_map_memory_mb}*0.8" | bc`
mapreduce_reduce_java_opts_max_heap=`echo "${mapreduce_reduce_memory_mb}*0.8" | bc`

echo "${mapreduce_map_java_opts_max_heap} M     맵 태스크용 최대 힙 메모리 크기"
echo "${mapreduce_reduce_java_opts_max_heap} M        리듀스 최대 힙 메모리 크기"

echo ""

echo "위 사항을 계산하지 않고 바로 mapreduce.map.java.opts, mapreduce.reduce.java.opts 수정해도 됨"

echo "mapreduce.map.java.opts=-Xmx1638m"
echo "mapreduce.reduce.java.opts=-Xmx3277m"

cnt_mapcontainer=""
echo "MIN( `expr ${container_mem} \* 1024 \/ ${mapreduce_map_memory_mb}`  , ${NumofCPUCoresPerContainer} ) x ${TotServer}"

if [ "`expr ${container_mem} \* 1024 \/ ${mapreduce_map_memory_mb}`"  -gt "${NumofCPUCoresPerContainer}" ]; then
      cnt_mapcontainer=`expr ${NumofCPUCoresPerContainer}`
else  cnt_mapcontainer=`expr ${container_mem} \* 1024 \/ ${mapreduce_map_memory_mb}`
fi

cnt_mapcontainer=`expr ${cnt_mapcontainer} \* ${TotServer}`
echo "--맵 태스크용 컨테이너 개수 : ${cnt_mapcontainer} "

cnt_redcontainer=""
echo "MIN( `expr ${container_mem} \* 1024 \/ ${mapreduce_reduce_memory_mb}`  , ${NumofCPUCoresPerContainer} ) x ${TotServer}"

if [ "`expr ${container_mem} \* 1024 \/ ${mapreduce_reduce_memory_mb}`"  -gt "${NumofCPUCoresPerContainer}" ]; then
      cnt_redcontainer=`expr ${NumofCPUCoresPerContainer}`
else  cnt_redcontainer=`expr ${container_mem} \* 1024 \/ ${mapreduce_reduce_memory_mb}`
fi

cnt_redcontainer=`expr ${cnt_redcontainer} \* ${TotServer}`
echo "--리듀스 태스크용 컨테이너 개수 : ${cnt_redcontainer}"

echo ""

echo "각 서버에서는 ${NumofCPUCoresPerContainer}개의 컨테이너를 실행할 수 있으며, 전체 클러스터에서는 맵 ${cnt_mapcontainer}, 리듀스 ${cnt_redcontainer}개의 컨테이너를 동시에 실행할 수 있습니다."