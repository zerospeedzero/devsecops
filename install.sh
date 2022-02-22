#!/usr/bin/bash
echo "What is your OpenShift project?"
read project

oc project $project 2>&1 > /dev/null
if [ $? -ne 0 ];
then
        echo "Project $project is not found"
        exit
fi

echo "Deploy Robot-shop application under project $project"

cd /home/user/devsecops
for i in `ls |egrep -v 'README|pic|install'`
do
    oc apply -f $i -n $project
done
