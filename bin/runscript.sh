#!/bin/bash
echo "Killing the processes"
kill $(ps aux | grep '[p]ython bin/Main_Hillary.py' | awk '{print $2}')
kill $(ps aux | grep '[p]ython bin/Main_Trump.py' | awk '{print $2}')
cd /home/ec2-user/BDAAProject
echo "Starting Hillary Script"
nohup python bin/Main_Hillary.py >> Log_Hillary.log &
echo "Starting Trump Script"
nohup python bin/Main_Trump.py >> Log_Trump.log &


