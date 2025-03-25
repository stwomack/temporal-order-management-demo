#!/bin/bash
validate()
{
  if [ -z "$1" ]
	then
	  echo "You must supply the temporal CLI environment to use to connect to the order management namespace."
	  exit 1
        else
		TEMPORAL_ENV=$1
	fi

        if ! command -v temporal 2>&1 > /dev/null
        then
                echo "Please install the temporal command line onto your path."
                exit 1
        fi

        if [ $(temporal env list | grep ${TEMPORAL_ENV} | wc -l) -eq 1 ]
        then
                echo "environment setup"
        else
                echo "Environment for CLI not setup."
                echo "Using the command line please setup an environment that will allow the temporal"
                echo "command line to connect to your Temporal service and namespace."
                exit 1
        fi

        temporal workflow list --env ${TEMPORAL_ENV} 2>&1 > /dev/null
        if [ $? -eq 0 ]
        then
                echo "Successfully connected to temporal service."
        else
                echo "Failed to connect to the temporal service.  Please check operations from the command line."
                exit 1
        fi

}
validate $1
source ../setcloudenv.sh ${TEMPORAL_ENV}
# donald-nexus-shipping-demo
export TEMPORAL_TASK_QUEUE=shipping
env | grep TEMP
./gradlew :shipping-management:bootRun --args='--spring.profiles.active=tc'
