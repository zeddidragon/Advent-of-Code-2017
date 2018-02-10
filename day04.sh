#!/bin/bash

seed=yzbqklnj
pids=""
threads=8

for i in $(seq $threads); do
  n=$(expr $i - 1)
  yes | awk -v seed=$seed -v n=$n -v step=$threads -f day04.awk &
  pids="$pids $!"
done

wait -n $pids
