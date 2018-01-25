# Kafka Connect - Cassandra #

Please following this to try the confluent (kafka-connect) sink cassandra.

 run setup-server.sh
2. open file connect-avro-distributed.properties in /opt/confluent/etc/schema-registry/
3. change plugin.path into 
```sh
plugin.path = /opt/confluent/plugins/streamreactor/libs
```
4. restart confluent
5. check cassandra plugins in kafka connect using 
```sh
curl http://10.128.0.2:8083/connector-plugins
```
6. in terminal, type `cqlsh`
7. and type 
```sh
CREATE KEYSPACE demo WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor' : 3};
```
8. type `use demo;`
9. type 
```sh
create table orders (id int, created varchar, product varchar, qty int, price float, PRIMARY KEY (id, created))
WITH CLUSTERING ORDER BY (created asc);
```
10. open file cassandra.properties in folder cassandra/
11. copy all contents of the file into file /opt/confluent/etc/kafka-connect-cassandra/quickstart-cassandra.properties
12. in terminal, run 
```sh
java -jar /opt/confluent/plugins/streamreactor/libs/kafka-connect-cli-0.5-all.jar create cassandra-sink-orders < /opt/confluent/etc/kafka-connect-cassandra/quickstart-cassandra.properties
```
13. and then open new terminal, and type

```sh
bin/kafka-avro-console-producer \
 --broker-list localhost:9092 --topic orders-topic \
 --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"id","type":"int"},{"name":"created","type":"string"},{"name":"product","type":"string"},{"name":"price","type":"double"}, {"name":"qty", "type":"int"}]}'
```

14. and then, type this
```sh
{"id": 1, "created": "2016-05-06 13:53:00", "product": "OP-DAX-P-20150201-95.7", "price": 94.2, "qty":100}
{"id": 2, "created": "2016-05-06 13:54:00", "product": "OP-DAX-C-20150201-100", "price": 99.5, "qty":100}
{"id": 3, "created": "2016-05-06 13:55:00", "product": "FU-DATAMOUNTAINEER-20150201-100", "price": 10000, "qty":100}
{"id": 4, "created": "2016-05-06 13:56:00", "product": "FU-KOSPI-C-20150201-100", "price": 150, "qty":100}
```

15. Open new terminal, and type `cqlsh`
16. type `use demo`
17. and the last, type `SELECT * FROM orders`
18. You will see inserted data from kafka. Finish
