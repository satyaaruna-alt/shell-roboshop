#!/bin/bash

SG_ID="sg-05b94ced162e1d820"    # Security group ID  taken from AWS console
AMI_ID="ami-0220d79f3f480ecf5"  # AMI ID taken from AWS console
INSTANCE_TYPE="t3.micro"

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceID' \
    --output text)   

    if [ $instance == 'frontend' ]; then
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].[PublicIpAddress]' \
        --output text)
    else
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].[PrivateIpAddress]' \
        --output text)
    fi

    echo "IP address: $IP"
done