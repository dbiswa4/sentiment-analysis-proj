CREATE EXTERNAL TABLE projects.tweets_analytics(tweet_id string, contestant string, created_at string, sentiment string, source string, text string, user_id string, user_location string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = "tweet_details:contestant,tweet_details:created_at,tweet_details:sentiment,tweet_details:source,tweet_details:text,tweet_details:user.id,tweet_details:user.location")
TBLPROPERTIES("hbase.table.name" = "tweets");
