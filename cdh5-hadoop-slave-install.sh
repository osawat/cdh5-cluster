cd /etc/yum.repos.d/
wget http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo
cd
yum install -y hadoop-yarn-nodemanager
yum install -y hadoop-hdfs-datanode
yum install -y hadoop-mapreduce
cp -r /etc/hadoop/conf.dist/ /etc/hadoop/conf.cluster
alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50
alternatives --set hadoop-conf /etc/hadoop/conf.cluster
