sudo service hadoop-hdfs-namenode stop
for node in 1 2
do
  sudo ssh slave${node} command service hadoop-hdfs-datanode stop 
done
sudo service hadoop-yarn-resourcemanager stop
sudo service hadoop-mapreduce-historyserver stop
for node in 1 2
do
  sudo ssh slave${node} command service hadoop-yarn-nodemanager stop
done
