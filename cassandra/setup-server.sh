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

# install dependencies for python client -> confluent
apt-get install librdkafka-dev python-dev
pip install confluent-kafka
pip install confluent-kafka[avro]

# start confluent
confluent start

# install cassandra
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
apt-get update
apt-get install cassandra

# start cassandra
service cassandra start

# install stream reactor
wget https://github.com/datamountaineer/stream-reactor/releases/download/v0.2/stream-reactor-release-0.2-3.0.0.tar.gz
tar -xvf stream-reactor-release-0.2-3.0.0.tar.gz
mkdir /opt/confluent/plugins/
mkdir /opt/confluent/plugins/streamreactor
mkdir /opt/confluent/plugins/streamreactor/libs/
mv stream-reactor-release-0.2-3.0.0/kafka-connect-cassandra-0.2-3.0.0-all.jar /opt/confluent/plugins/streamreactor/libs/

wget https://github.com/Landoop/kafka-connect-tools/releases/download/v0.5/kafka-connect-cli-0.5-all.jar
mv kafka-connect-cli-0.5-all.jar /opt/confluent/plugins/streamreactor/libs/

mkdir /opt/confluent/etc/kafka-connect-cassandra
touch /opt/confluent/etc/kafka-connect-cassandra/quickstart-cassandra.properties


name=cassandra-sink-orders
connector.class=com.datamountaineer.streamreactor.connect.cassandra.sink.CassandraSinkConnector
tasks.max=1
topics=orders-topic
connect.cassandra.export.route.query=INSERT INTO orders SELECT * FROM orders-topic
connect.cassandra.contact.points=localhost
connect.cassandra.port=9042
connect.cassandra.key.space=demo
connect.cassandra.username=cassandra
connect.cassandra.password=cassandra

java -jar /opt/confluent/plugins/streamreactor/libs/kafka-connect-cli-0.5-all.jar create cassandra-sink-orders < /opt/confluent/etc/kafka-connect-cassandra/quickstart-cassandra.properties

bin/kafka-avro-console-producer \
 --broker-list localhost:9092 --topic orders-topic \
 --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"id","type":"int"},{"name":"created","type":"string"},{"name":"product","type":"string"},{"name":"price","type":"double"}, {"name":"qty", "type":"int"}]}'


{"id": 1, "created": "2016-05-06 13:53:00", "product": "OP-DAX-P-20150201-95.7", "price": 94.2, "qty":100}
{"id": 2, "created": "2016-05-06 13:54:00", "product": "OP-DAX-C-20150201-100", "price": 99.5, "qty":100}
{"id": 3, "created": "2016-05-06 13:55:00", "product": "FU-DATAMOUNTAINEER-20150201-100", "price": 10000, "qty":100}
{"id": 4, "created": "2016-05-06 13:56:00", "product": "FU-KOSPI-C-20150201-100", "price": 150, "qty":100}


use demo;
SELECT * FROM orders;
