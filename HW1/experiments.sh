#!/bin/bash

# creates new folder
mkdir sysbench_data

# goes to new folder

echo "cpu test"

echo "-----------------------------------------------------------" >> sysbench_data/sys_output.txt 

i=0
cat commands.txt | while read command || [[ -n $command ]];
do
    echo "iteration: ${command}"
    echo "iteration: ${command}" >> sysbench_data/sys_output.txt

    # sysbench tst
    $command >> sysbench_data/sys_output.txt &
    # delays 20 miliseconds
    sleep 0.02
    # outputs snapshot of top command to txt file
    top -b -n 1 > sysbench_data/top_out.txt
    # waits until sysbench finishes running
    wait
    # appends contents of top_out.txt to sys_output.txt
    cat sysbench_data/top_out.txt >> sysbench_data/sys_output.txt
    # removes top_out.txt file
    rm sysbench_data/top_out.txt
    # tells user test is finished
    echo "done"

    echo "-----------------------------" >> sysbench_data/sys_output.txt
done

echo "-----------------------------------------------------------" >> sysbench_data/sys_output.txt 