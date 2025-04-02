docker exec -it cassandra bash

docker cp /home/dell/Documents/Documents/Learn_in_home/LongDE/DE/Class_4_Realtime_data_pipeline/Cassandra/tracking-LongTH.csv cassandra:/

docker exec -it cassandra bash -c "cqlsh -u cassandra -p cassandra"

CREATE KEYSPACE bedan
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
CREATE TABLE bedan.tracking ( create_time timeuuid PRIMARY KEY , bid int, bn text , campaign_id int, cd int, custom_track text, de text ,dl text,dt text,ed text,ev int,group_id int,id int,job_id int,md text,publisher_id int ,rl text,sr text ,ts timestamp ,tz int,ua text,uid text,utm_campaign text,utm_content text,utm_medium text, utm_source text,utm_term text,v text,vp text );


docker exec -it cassandra bash -c "cd bitnami/cassandra/ && cqlsh -u cassandra -p cassandra"


COPY bedan.tracking (create_time, bid, bn, campaign_id, cd, custom_track, de, dl, dt, ed, ev, group_id, id, job_id, md, publisher_id, rl, sr, ts, tz, ua, uid, utm_campaign, utm_content, utm_medium, utm_source, utm_term, v, vp) FROM '/tracking-LongTH.csv' WITH HEADER = TRUE AND DELIMITER = ',';



docker cp /home/dell/Documents/Documents/Learn_in_home/LongDE/DE/Class_4_Realtime_data_pipeline/Cassandra/search.csv cassandra:/


docker cp /home/dell/Downloads/mysql-connector-j-9.2.0/spark-cassandra-connector-assembly_2.12-3.1.0.jar zeppelin:/opt/bitnami/spark/jars
docker cp /home/dell/Downloads/spark-cassandra-connector-assembly_2.12-3.1.0.jar zeppelin:/opt/zeppelin/interpreter/spark/dep/
docker cp /home/dell/Downloads/mysql-connector-j-9.2.0/mysql-connector-j-9.2.0.jar zeppelin:/opt/zeppelin/interpreter/spark/dep/

    /opt/zeppelin/interpreter/spark/dep/spark-cassandra-connector-assembly_2.12-3.1.0.jar
/opt/zeppelin/interpreter/spark/dep/mysql-connector-j-9.2.0.jar


https://downloads.datastax.com/kafka/kafka-connect-cassandra-sink.tar.gz

kafka-console-consumer --bootstrap-server broker:9092 --topic gen_data --from-beginning
connect-standalone /etc/kafka/connect-standalone.properties /etc/kafka/cassandra-sink-standalone.properties.sample

name=cassandra-sink
connector.class=com.datastax.oss.kafka.sink.CassandraSinkConnector
topics=data_gen
tasks.max=1
contactPoints=cassandra
loadBalancing.localDc=datacenter1
keyspace=bedan
table=tracking
mapping=id=key, message=value.message, timestamp=value.timestamp

auth.provider=DsePlainTextAuthProvider
auth.username=my_cassandra_user
auth.password=my_cassandra_password

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
    "name": "cassandra-sink2",
    "config": {
        "connector.class": "com.datastax.oss.kafka.sink.CassandraSinkConnector",
        "tasks.max": "1",
        "topics": "gen_data4",
        "contactPoints": "172.18.0.6",
        "loadBalancing.localDc": "datacenter1",
        "port": "9042",
        "auth.provider": "PLAIN",
        "auth.username": "cassandra",
        "auth.password": "cassandra",
        "topic.gen_data4.bedan.tracking.mapping": "bid=value.bid,campaign_id=value.campaign_id,create_time=value.create_time,custom_track=value.custom_track,group_id=value.group_id,job_id=value.job_id,publisher_id=value.publisher_id,ts=value.ts",
        "topic.gen_data4.bedan.tracking.ttlTimeUnit": "SECONDS",
        "topic.gen_data4.bedan.tracking.timestampTimeUnit": "MICROSECONDS",
        "ssl.provider": "None"
    }
}'
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
    "name": "cassandra-sink2",
    "config": {
        "connector.class": "com.datastax.oss.kafka.sink.CassandraSinkConnector",
        "tasks.max": "1",
        "topics": "gen_data4",
        "contactPoints": "172.18.0.6",
        "loadBalancing.localDc": "datacenter1",
        "port": "9042",
        "auth.provider": "PLAIN",
        "auth.username": "cassandra",
        "auth.password": "cassandra",
        "topic.gen_data4.bedan.tracking.mapping": "bid=value.bid,campaign_id=value.campaign_id,create_time=value.create_time,custom_track=value.custom_track,group_id=value.group_id,job_id=value.job_id,publisher_id=value.publisher_id,ts=value.ts",
        "topic.gen_data4.bedan.tracking.ttlTimeUnit": "SECONDS",
        "topic.gen_data4.bedan.tracking.timestampTimeUnit": "MICROSECONDS",
        "ssl.provider": "None",
        
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "false",
        "value.converter.schemas.enable": "false"
    }
}'


# list cac connector plugin hien co
curl -s http://localhost:8083/connector-plugins | jq
# xem cac connector duoc tao
curl -s http://localhost:8083/connectors | jq .

#  Xem trạng thái của một Connector cụ thể
curl -s http://localhost:8083/connectors/<connector-name>/status | jq .
# ex
curl -s http://localhost:8083/connectors/cassandra-sink/status | jq .
curl -s http://localhost:8083/connectors/sink/status | jq .

# Cách 1: Restart Connector (Cách đơn giản nhất)
curl -X POST http://localhost:8083/connectors/<connector-name>/restart
curl -X POST http://localhost:8083/connectors/sink/restart

# xoa 1 connector
curl -X DELETE http://localhost:8083/connectors/cassandra-sink


curl -s "http://localhost:8083/connectors/cassandra-sink/status" | \ jq '.tasks[0l.state'



nano /usr/share/confluent-hub-components/kafka-connect-cassandra-sink-1.4.0/conf/cassandra-sink-standalone.properties
