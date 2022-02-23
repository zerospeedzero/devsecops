#!/bin/sh
for i in `oc get pod | awk '{print $1}' | grep -v NAME`
do
oc delete pod $i --force --grace-period 0
done