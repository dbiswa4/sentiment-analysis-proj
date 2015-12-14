#!/bin/bash
while true
do
        process_count=`ps -ef | grep -iwc "Main_Trump.py"`
        if [ $process_count -eq 1 ]
        then
                echo "Trump script not running.. Starting it"
                nohup python Main_Trump.py >> Log_Trump.log &
        else
                echo "Trump script is running.."
        fi
        process_count=`ps -ef | grep -iwc "Main_Hillary.py"`
        if [ $process_count -eq 1 ]
        then
                echo "Hillary script not running.. Starting it"
                nohup python Main_Hillary.py >> Log_Hillary.log &
        else
                echo "Hillary script is running.."
        fi
sleep 120s
done
