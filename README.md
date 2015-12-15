# sentiment-analysis-proj
GROUP 6 - PROJECT REPORT TWITTER SENTIMENT ANALYSIS OF US PRESIDENTIAL ELECTION

##############
Start Services
#############
Start Hadoop Services
--------------------

cd /home/ec2-user/hadoop-2.6.0/sbin

./start-all.sh

Start HBase Services
--------------------

cd /home/ec2-user/hbase-0.98.0-hadoop2/bin

./start-hbase.sh

Start HBase Thrift Server
------------------------

nohup hbase thrift start &


Start Derby db
-------------

cd $DERBY_HOME/bin

nohup startNetworkServer -h 0.0.0.0 &

Start mysql server
-----------------
sudo /sbin/chkconfig mysqld on

mysql -u projects -p

use projects;

show tables;



Verification
------------
Following services should be running.

[ec2-user@ip-172-31-47-93 hive]$ jps
7893 ThriftServer
5710 DataNode
6138 NodeManager
25283 RunJar
6694 NetworkServerControl
26631 Jps
7164 HQuorumPeer
5876 SecondaryNameNode
5582 NameNode
6031 ResourceManager
7269 HMaster
7402 HRegionServer


################
Script Execution
###############
###If we want to manually start the process, we need to run the below scripts in given order. In live project scenarios, it’s automated thru crontab scheduling.

1.	Run below Python scripts to collect the tweets from Twitter and load into HBase table

cd /home/ec2-user/BDAAProject/bin 
python Main_Hillary.py
python Main_Trump.py

2.	Run below Hive scripts to copy the data from HBase table to Hive table
cd /home/ec2-user/BDAAProject/hive
(One time)
hive –f tweets_analytics.hql

Run the below script which will aggregate the data as required and copy the aggregated data in a file.

hive –f tweets_analytics_agg.hql

3.	Run the below script which will aggregate the data as required and copy the aggregated data in a file. The data from the file will be loaded in MySQL table.
perl data_aggs_process.pl


###Automation through crontab scheduling

*/15 * * * * /home/ec2-user/BDAAProject/bin/poll.sh

30 * * * * /home/ec2-user/BDAAProject/bin/data_aggs_process.pl > /home/ec2-user/BDAAProject/log/data_aggs_`date +\%H\%M_\%m\%d\%y`.log 2>&1


