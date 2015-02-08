cd /etc/yum.repos.d/
wget http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo
cd
yum install -y hadoop-yarn-resourcemanager
yum install -y hadoop-hdfs-namenode
yum install -y hadoop-client
yum install hadoop-mapreduce-historyserver
cp -r /etc/hadoop/conf.dist/ /etc/hadoop/conf.cluster
alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50
alternatives --set hadoop-conf /etc/hadoop/conf.cluster
