# Service Watchdog

It is a watchdog (bash daemon) for service restart if string is found in specified log file.

## EC2 instance deployment

aws cloudformation create-stack \
--stack-name ServiceWatchdogEC2Instance \
--template-body SW_EC2_instance.yaml \
--parameters ParameterKey=KeyName,ParameterValue=userkey