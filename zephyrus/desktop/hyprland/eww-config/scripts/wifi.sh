#!/usr/bin/env bash

nmcli -t -f active,ssid,signal dev wifi | egrep '^yes' | awk -F : '{ printf "{\"essid\": \"%s\", \"signal\": %s}\n", $2, $3 }'
ip monitor link | while read -r line; do
  nmcli -t -f active,ssid,signal dev wifi | egrep '^yes' | awk -F : '{ printf "{\"essid\": \"%s\", \"signal\": %s}\n", $2, $3 }'
done
