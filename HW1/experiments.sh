#!/bin/bash

# This is a bash script used COEN 241 Homework 1
# Alfonso De La Rosa
# This bash script will be used for two virtual technologies
# docker and QEMU

# the commands.txt file with sysbench commands will be required for this experiment
# In addition, every four adjacent commands are test cases of an experiment.

# creates new folder
mkdir sysbench_data

# iterate through each test case of an experiment
for index in 1 2 3 4 5 6 7 8 9 10 11 12 13 14
do
    # outputs the sysbench command of that experiment
    head -$index commands.txt | tail -1

    # add line seperator to text file
    echo "-----------------------------" >> sysbench_data/"sys_output$((index))".txt

    # first line in new text file = command
    echo "COMMAND: $(head -$index commands.txt | tail -1)" >> sysbench_data/"sys_output$((index))".txt

    # since the last 2 test cases read GB of data, 
    # these commands create the GB of data to read
    if ((index == 13)); then
        sysbench --test=fileio --file-total-size=2G --file-test-mode=seqrd prepare
    elif ((index == 14)); then
        sysbench --test=fileio --file-total-size=4G --file-test-mode=seqrd prepare
    fi
    # executes each testcase of an experiment five times
    for trial in 0 1 2 3 4 
    do          
        
        # execute sysbench command in the background and append results to a separate text file
        $(head -$index commands.txt | tail -1) >> sysbench_data/"sys_output$((index))".txt &

        # delay a few milisecond, so that the sysbench process appears in the running proccessses
        sleep 0.004s

        # outputs snapshot of top command to txt file
        top -b -n 1 > sysbench_data/top_out.txt

        # waits until sysbench command finishes running
        wait

        # appends contents of top_out.txt to sys_output.txt
        cat sysbench_data/top_out.txt >> sysbench_data/"sys_output$((index))".txt

        # removes top_out.txt file
        rm sysbench_data/top_out.txt

        # tells user trial of test case is finished
        echo "done"

        echo "-----------------------------" >> sysbench_data/"sys_output$((index))".txt

    done
    # since the last two test cases finished reading GB of data,
    # those files of data will be deleted not to take up space
    if ((index == 13)); then
        sysbench --test=fileio --file-total-size=2G --file-test-mode=seqrd cleanup
    elif ((index == 14)); then
        sysbench --test=fileio --file-total-size=4G --file-test-mode=seqrd cleanup
    fi     
done

# removes all test files
rm test_file*