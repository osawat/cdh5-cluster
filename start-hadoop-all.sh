sudo service hadoop-hdfs-namenode start
for node in 1 2
do
  sudo ssh slave${node} command service hadoop-hdfs-datanode start 
done
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-mapreduce-historyserver start
for node in 1 2
do
  sudo ssh slave${node} command service hadoop-yarn-nodemanager start
done
