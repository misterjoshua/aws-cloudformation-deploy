#!/bin/bash

set -e

rsync -av --delete /setup/ /test
touch /test/ready

# Wait for deployment to finish.
WHEN_DONE=/test/done
for i in $(seq 120); do
    if [ -f "$WHEN_DONE" ]; then
        break;
    fi

    echo "Waiting for the deployment to finish."
    sleep 1
done

# Timeout
if [ ! -f "$WHEN_DONE" ]; then
    echo "Timed out"
    exit 1
fi

STACK_NAME=$(cat $WHEN_DONE)

aws cloudformation describe-stack-events --stack-name "$STACK_NAME" >status
STATUS=$(jq <status -r '.StackEvents[0].ResourceStatus')

echo "Status of deploy is $STATUS"
if [ ! "$STATUS" = "UPDATE_COMPLETE" ]; then
    echo "Deploy did not succeed."
fi

echo "It finished"
exit 0