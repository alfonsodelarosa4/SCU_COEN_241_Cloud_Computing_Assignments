#!/bin/bash

mkdir sysbench_data

cd sysbench_data

echo "cpu test"
sleep 2
sysbench --test=cpu run > sys_output.txt &
sleep 0.01
top -b -n 1 > top_out.txt
wait
echo "done"