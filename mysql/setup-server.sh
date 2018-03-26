# please login using root user
sudo su

# update your repository
apt-get update
apt-get upgrade

# install java
apt-get install openjdk-8-jdk openjdk-8-source
sudo ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /opt/jdk
echo '' >> ~/.bashrc
echo 'export JAVA_HOME="/opt/jdk"' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# check python version (using python v3)
python3 --version

# install python if not exist and pip
apt-get install python3
apt-get install python3-pip

# create alias to using key 'python'
echo '' >> ~/.bashrc
echo 'alias python=python3' >> ~/.bashrc
echo 'alias pip=pip3' >> ~/.bashrc
source ~/.bashrc

# install confluent (kafka, kafka connect, zookeeper, avro schema)
wget http://packages.confluent.io/archive/4.0/confluent-oss-4.0.0-2.11.tar.gz
tar xvzf confluent-oss-4.0.0-2.11.tar.gz
mv confluent-4.0.0 /opt/
ln -s /opt/confluent-4.0.0 /opt/confluent
echo 'export CONFLUENT_HOME="/opt/confluent"' >> ~/.bashrc
echo 'export PATH=$CONFLUENT_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# install mysql
apt-get update
apt-get install mysql-server

# load driver mysql
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar xvzf mysql-connector-java-5.1.46.tar.gz
cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46.jar /opt/confluent/share/java/kafka-connect-jdbc/

# start confluent
confluent start
