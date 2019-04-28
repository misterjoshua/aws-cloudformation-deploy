#!/bin/bash

set -ex

rsync -av /setup /test
touch /test/ready

# Wait for deployment to finish.
WHEN_DONE=/test/done
for i in $(seq 4); do
    if [ -f "$WHEN_DONE" ]; then
        break;
    fi

    echo "Waiting for the deployment to finish."
    sleep 5
done

# Timeout
if [ ! -f "$WHEN_DONE" ]; then
    echo "Timed out"
    exit 1
fi

echo "It finished"
exit 0