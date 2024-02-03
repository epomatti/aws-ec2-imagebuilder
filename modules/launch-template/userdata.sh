#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Configure the CloudWatch Agent
ssmParameterName=AmazonCloudWatch-linux-TailscaleImageBuilderTest
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:$ssmParameterName -s
