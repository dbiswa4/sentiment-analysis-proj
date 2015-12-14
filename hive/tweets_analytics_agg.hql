add jar /home/ec2-user/apache-hive-0.14.0-bin/lib/hive-hbase-handler-0.14.0.jar;
add jar /home/ec2-user/hbase-0.98.0-hadoop2/lib/hbase-common-0.98.0-hadoop2.jar;
add jar /home/ec2-user/hbase-0.98.0-hadoop2/lib/zookeeper-3.4.5.jar;
add jar /home/ec2-user/hbase-0.98.0-hadoop2/lib/guava-12.0.1.jar;
add jar /home/ec2-user/hbase-0.98.0-hadoop2/lib/high-scale-lib-1.1.1.jar;




INSERT OVERWRITE LOCAL DIRECTORY '/home/ec2-user/BDAAProject/output/geo_positive'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
select contestant, LOWER(user_location), substr(created_at, 4, 7), count(*)
from projects.tweets_analytics
where created_at is not null and user_location != 'undefined' and lower(sentiment)='positive'
group by contestant, LOWER(user_location), substr(created_at, 4, 7)
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/ec2-user/BDAAProject/output/geo_negative'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
select contestant, LOWER(user_location), substr(created_at, 4, 7), count(*)
from projects.tweets_analytics
where created_at is not null and user_location != 'undefined' and lower(sentiment)='negative'
group by contestant, LOWER(user_location), substr(created_at, 4, 7)
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/ec2-user/BDAAProject/output/geo_total'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
select contestant, LOWER(user_location), substr(created_at, 4, 7), count(*)
from projects.tweets_analytics
where created_at is not null and user_location != 'undefined'
group by contestant, LOWER(user_location), substr(created_at, 4, 7)
;

INSERT OVERWRITE LOCAL DIRECTORY '/home/ec2-user/BDAAProject/output/temporal'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
select contestant, trim(substr(created_at, 4, 7)), trim(substr(created_at, 11, 3)), LOWER(sentiment), count(*)
from projects.tweets_analytics
where created_at is not null
group by contestant, substr(created_at, 4, 7), substr(created_at, 11, 3), LOWER(sentiment)
;

