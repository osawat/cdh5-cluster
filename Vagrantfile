# -*- mode: ruby -*-
# vi: set ft=ruby :
 
#$master_script = &lt;&lt;SCRIPT
##!/bin/bash
#cat &gt; /etc/hosts &lt;&lt;EOF
#127.0.0.1       localhost
# 
## The following lines are desirable for IPv6 capable hosts
#::1     ip6-localhost ip6-loopback
#fe00::0 ip6-localnet
#ff00::0 ip6-mcastprefix
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
# 
#10.211.55.100   vm-cluster-node1
#10.211.55.101   vm-cluster-node2
#10.211.55.102   vm-cluster-node3
#10.211.55.103   vm-cluster-node4
#10.211.55.104   vm-cluster-node5
#10.211.55.105   vm-cluster-client
#EOF
# 
#apt-get install curl -y
#REPOCM=${REPOCM:-cm4}
#CM_REPO_HOST=${CM_REPO_HOST:-archive.cloudera.com}
#CM_MAJOR_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9]\\).*/\\1/')
#CM_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9][0-9]*\\)/\\1/')
#OS_CODENAME=$(lsb_release -sc)
#OS_DISTID=$(lsb_release -si | tr '[A-Z]' '[a-z]')
#if [ $CM_MAJOR_VERSION -ge 4 ]; then
#  cat &gt; /etc/apt/sources.list.d/cloudera-$REPOCM.list &lt;&lt;EOF
#deb [arch=amd64] http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm $OS_CODENAME-$REPOCM contrib
#deb-src http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm $OS_CODENAME-$REPOCM contrib
#EOF
#curl -s http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm/archive.key &gt; key
#apt-key add key
#rm key
#fi
#apt-get update
#export DEBIAN_FRONTEND=noninteractive
#apt-get -q -y --force-yes install oracle-j2sdk1.6 cloudera-manager-server-db cloudera-manager-server cloudera-manager-daemons
#service cloudera-scm-server-db initdb
#service cloudera-scm-server-db start
#service cloudera-scm-server start
#SCRIPT
# 
#$slave_script = &lt;&lt;SCRIPT
#cat &gt; /etc/hosts &lt;&lt;EOF
#127.0.0.1       localhost
# 
## The following lines are desirable for IPv6 capable hosts
#::1     ip6-localhost ip6-loopback
#fe00::0 ip6-localnet
#ff00::0 ip6-mcastprefix
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
# 
#10.211.55.100   vm-cluster-node1
#10.211.55.101   vm-cluster-node2
#10.211.55.102   vm-cluster-node3
#10.211.55.103   vm-cluster-node4
#10.211.55.104   vm-cluster-node5
#10.211.55.105   vm-cluster-client
#EOF
#SCRIPT
# 
#$client_script = &lt;&lt;SCRIPT
#cat &gt; /etc/hosts &lt;&lt;EOF
#127.0.0.1       localhost
# 
## The following lines are desirable for IPv6 capable hosts
#::1     ip6-localhost ip6-loopback
#fe00::0 ip6-localnet
#ff00::0 ip6-mcastprefix
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
# 
#10.211.55.100   vm-cluster-node1
#10.211.55.101   vm-cluster-node2
#10.211.55.102   vm-cluster-node3
#10.211.55.103   vm-cluster-node4
#10.211.55.104   vm-cluster-node5
#10.211.55.105   vm-cluster-client
#EOF
#SCRIPT

$script = <<SCRIPT
#!/bin/bash
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo '127.0.0.1    localhost localhost.localdomain localhost4 localhost4.localdomain4' > /etc/hosts
echo '192.168.33.10   master' >> /etc/hosts
echo '192.168.33.11   slave1' >> /etc/hosts
echo '192.168.33.12   slave2' >> /etc/hosts
echo '::1         localhost localhost.localdomain localhost6 localhost6.localdomain6' >> /etc/hosts
yum -y install wget
yum -y install vim-enhanced
yum -y install java-1.7.0-openjdk-devel
#curl -O http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-cdh4.tgz
#tar zxf spark-1.2.0-bin-cdh4.tgz
#mv spark-1.2.0-bin-cdh4 spark
echo 'JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64' >> ~/.bashrc
echo 'PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
SCRIPT

$namenode = <<SCRIPT
yum -y install wget
# Hadoop
cd /etc/yum.repos.d/
wget http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo
cd
yum install -y hadoop-yarn-resourcemanager
yum install -y hadoop-hdfs-namenode
yum install -y hadoop-client
yum install -y hadoop-mapreduce-historyserver
yum install -y spark*
cp -r /etc/hadoop/conf.dist/ /etc/hadoop/conf.cluster
alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50
alternatives --set hadoop-conf /etc/hadoop/conf.cluster
# HDFS
cp -f /vagrant/core-site.xml /etc/hadoop/conf.cluster/
cp -f /vagrant/hdfs-site.xml /etc/hadoop/conf.cluster/
mkdir -p /var/lib/hadoop-hdfs/cache/dfs/name
mkdir -p /var/lib/hadoop-hdfs/cache/dfs/data
chown hdfs:hdfs -R /var/lib/hadoop-hdfs/cache/dfs
#su - hdfs
#hdfs namenode -format
#exit
# YARN
cp -f /vagrant/mapred-site.xml /etc/hadoop/conf.cluster/mapred-site.xml
cp -f /vagrant/yarn-site.xml /etc/hadoop/conf.cluster/yarn-site.xml
mkdir -p /var/lib/hadoop-yarn/cache/local
chown yarn:hadoop /var/lib/hadoop-yarn/cache/local
mkdir -p /var/log/hadoop-yarn/containers
chown yarn:hadoop /var/log/hadoop-yarn/containers
SCRIPT

$datanode = <<SCRIPT
yum -y install wget
# Hadoop
cd /etc/yum.repos.d/
wget http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo
cd
yum install -y hadoop-yarn-nodemanager
yum install -y hadoop-hdfs-datanode
yum install -y hadoop-mapreduce
yum install -y spark*
cp -r /etc/hadoop/conf.dist/ /etc/hadoop/conf.cluster
alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50
alternatives --set hadoop-conf /etc/hadoop/conf.cluster
# HDFS
cp -f /vagrant/core-site.xml /etc/hadoop/conf.cluster/
cp -f /vagrant/hdfs-site.xml /etc/hadoop/conf.cluster/
mkdir -p /var/lib/hadoop-hdfs/cache/dfs/name
mkdir -p /var/lib/hadoop-hdfs/cache/dfs/data
chown hdfs:hdfs -R /var/lib/hadoop-hdfs/cache/dfs
# YARN
cp -f /vagrant/mapred-site.xml /etc/hadoop/conf.cluster/mapred-site.xml
cp -f /vagrant/yarn-site.xml /etc/hadoop/conf.cluster/yarn-site.xml
mkdir -p /var/lib/hadoop-yarn/cache/local
chown yarn:hadoop /var/lib/hadoop-yarn/cache/local
mkdir -p /var/log/hadoop-yarn/containers
chown yarn:hadoop /var/log/hadoop-yarn/containers
SCRIPT

Vagrant.configure("2") do |config|

# Define Box Image
  config.vm.box = "CentOS65"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.vm.define :master do |master|
    master.vm.box = "CentOS65"
    master.vm.provider :virtualbox do |v|
      v.name = "master"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    master.vm.network :private_network, ip: "192.168.33.10"
#    master.vm.network "forwarded_port", guest: 8020 , host: 8020
#    master.vm.network "forwarded_port", guest: 8021 , host: 8021
#    master.vm.network "forwarded_port", guest: 7077 , host: 7077
    master.vm.hostname = "master"
    master.vm.provision :shell, :inline => $script
    master.vm.provision :shell, :inline => $namenode
  end

  config.vm.define :slave1 do |slave1|
    slave1.vm.box = "CentOS65"
    slave1.vm.provider :virtualbox do |v|
      v.name = "slave1"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    slave1.vm.network :private_network, ip: "192.168.33.11"
#    slave1.vm.network "forwarded_port", guest: 8020 , host: 8020
#    slave1.vm.network "forwarded_port", guest: 8021 , host: 8021
    slave1.vm.hostname = "slave1"
    slave1.vm.provision :shell, :inline => $script
    slave1.vm.provision :shell, :inline => $datanode
  end
 
  config.vm.define :slave2 do |slave2|
    slave2.vm.box = "CentOS65"
    slave2.vm.provider :virtualbox do |v|
      v.name = "slave2"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    slave2.vm.network :private_network, ip: "192.168.33.12"
#    slave2.vm.network "forwarded_port", guest: 8020 , host: 8020
#    slave2.vm.network "forwarded_port", guest: 8021 , host: 8021
    slave2.vm.hostname = "slave2"
    slave2.vm.provision :shell, :inline => $script
    slave2.vm.provision :shell, :inline => $datanode
  end
 
end
