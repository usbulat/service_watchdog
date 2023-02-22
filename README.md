# Service Watchdog

It is a watchdog (bash daemon) for service restart if string is found in specified log file.

## EC2 instance deployment

Change ParameterValue for each ParameterKey according to your environment.
```
aws cloudformation create-stack \
--stack-name ServiceWatchdogEC2Instance \
--template-body file://SW_EC2_instance.yaml \
--parameters ParameterKey=KeyName,ParameterValue=userkey \
             ParameterKey=VpcID,ParameterValue=vpcid
             ParameterKey=SubnetID,ParameterValue=subnetid
             ParameterKey=AvailabilityZone,ParameterValue=availabilityzone
```