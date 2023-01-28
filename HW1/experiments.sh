#!/bin/bash

# creates new folder
mkdir sysbench_data


for index in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
do
    # outputs command
    head -$index commands.txt | tail -1

    echo "-----------------------------" >> sysbench_data/"sys_output$((index))".txt

    # first line in new text file = command
    echo "COMMAND: ${command}" >> sysbench_data/"sys_output$((index))".txt

    for trial in 0 1 2 3 4 
    do
        # execute sysbench command in the background
        $(head -$index commands.txt | tail -1) >> sysbench_data/"sys_output$((index))".txt &

        sleep 0.2

        # outputs snapshot of top command to txt file
        top -b -n 1 > sysbench_data/top_out.txt

        # waits until sysbench command finishes running
        wait

        # appends contents of top_out.txt to sys_output.txt
        cat sysbench_data/top_out.txt >> sysbench_data/"sys_output$((index))".txt

        # removes top_out.txt file
        rm sysbench_data/top_out.txt

        # tells user test is finished
        echo "done"

        echo "-----------------------------" >> sysbench_data/"sys_output$((index))".txt

    done
done

rm test_file*