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


