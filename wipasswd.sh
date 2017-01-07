#!/bin/bash

set -e

ssid=$1

if [ -z "${ssid}" ]; then
  ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk -F": " '/ SSID/ {print $2}')
fi

pass=$(security find-generic-password -s AirPort -w -a ${ssid})

echo "SSID: ${ssid}"
echo "PASS: ${pass}"
