#!/bin/bash
read -p "ping adress:" TARGET
fail_count=0
while true; do
  ping_output=$(ping -c 1 "$TARGET" 2>&1)
  if echo "$ping_output" | grep -q "time="; then
    ping_time=$(echo "$ping_output" | grep "time=" | sed -n 's/.*time=\([0-9.]*\) ms.*/\1/p')
    if (( $(echo "$ping_time > 100" | bc -l) )); then
        echo "ping time $ping_time more 100"
      else
        echo "ping good: $ping_time"
      fi
      fail_count=0
  else
    ((fail_count++))
    echo "ping failed ($fail_count from 3)"
    if [ "$fail_count" -ge 3 ]; then
      echo "ping faild 3 times in a row, check your connection"
      break
    fi
  fi
  sleep 1
done
