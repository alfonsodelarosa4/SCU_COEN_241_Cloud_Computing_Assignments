#!/bin/bash

# creates new folder
mkdir sysbench_data

# goes to new folder
cd sysbench_data

# outputs current test to user
echo "cpu test"
sleep 1
# sysbench tst
sysbench --test=cpu run > sys_output.txt &
# delays 20 miliseconds
sleep 0.02
# outputs snapshot of top command to txt file
top -b -n 1 > top_out.txt
# waits until sysbench finishes running
wait
# appends contents of top_out.txt to sys_output.txt
cat top_out.txt >> sys_output.txt
# removes top_out.txt file
rm top_out.txt
# tells user test is finished
echo "done"