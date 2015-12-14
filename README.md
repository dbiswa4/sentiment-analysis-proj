# sentiment-analysis-proj
GROUP 6 - PROJECT REPORT TWITTER SENTIMENT ANALYSIS OF US PRESIDENTIAL ELECTION

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


###4.5	Automation through crontab scheduling

*/15 * * * * /home/ec2-user/BDAAProject/bin/poll.sh

30 * * * * /home/ec2-user/BDAAProject/bin/data_aggs_process.pl > /home/ec2-user/BDAAProject/log/data_aggs_`date +\%H\%M_\%m\%d\%y`.log 2>&1


