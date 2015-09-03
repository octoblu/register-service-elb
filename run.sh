#!/bin/bash

INSTANCE_ID=$(aws ec2 describe-instances --filter "Name=private-dns-name,Values=${INSTANCE_HOSTNAME}" | jq -r '.Reservations[].Instances[].InstanceId')

if [ -z "${INSTANCE_ID}" ]; then
  echo "Unable to find instance ${INSTANCE_HOSTNAME}, exiting."
  exit 1
fi

aws elb register-instances-with-load-balancer \
  --load-balancer-name service-cluster \
  --instances ${INSTANCE_ID}
