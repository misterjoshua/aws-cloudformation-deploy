#!/bin/bash

function deploy_stack() {
    # Simple validation
    if [ -z "$DEPLOY_TEMPLATE" ]; then
        echo "Please provide DEPLOY_TEMPLATE"
        exit 1
    fi

    if [ ! -f "$DEPLOY_TEMPLATE" ]; then
        echo "The template file $DEPLOY_TEMPLATE does not exist."
        exit 1
    fi

    # If the template parameters aren't given directly
    if [ -z "$DEPLOY_PARAMETERS" ]; then
        # Grab template parameters from environment variables following this convention:
        # PARAM_paramNameHere
        # PARAM_OtherParam
        DEPLOY_PARAMETERS=$(printenv | awk '/^PARAM_/ { gsub(/^PARAM_/, ""); print $1 }')
    fi

    # Add template parameters if available.
    if [ ! -z "$DEPLOY_PARAMETERS" ]; then
        DEPLOY_PARAMETERS_OPT="--template-parameters $DEPLOY_PARAMETERS"
    fi
    # Add tags if available.
    if [ ! -z "$DEPLOY_TAGS" ]; then
        DEPLOY_TAGS_OPT="--tags $DEPLOY_TAGS"
    fi

    # Package the cloudformation
    if [ ! -z "$PACKAGE_BUCKET" ]; then
        echo "Packaging $DEPLOY_TEMPLATE using s3://$PACKAGE_BUCKET"
        aws cloudformation package \
            --template-file "$DEPLOY_TEMPLATE" \
            --s3-bucket "$PACKAGE_BUCKET" \
            --output-template-file "/tmp/package"
        DEPLOY_TEMPLATE="/tmp/package"
    else

    echo "Deploying $STACK_NAME from $DEPLOY_TEMPLATE"
    echo "Template parameters:"
    echo -e "$DEPLOY_PARAMETERS"

    aws cloudformation deploy \
        --stack-name "$STACK_NAME" \
        --template-file "$DEPLOY_TEMPLATE" \
        $DEPLOY_PARAMETERS_OPT \
        $DEPLOY_TAGS_OPT \
        $OPTS
}

function delete_stack() {
    echo "Deleting $STACK_NAME"
    aws cloudformation delete-stack --stack-name "$STACK_NAME"
}

#============================
# Script begins
#============================

if [ ! -z "$DEBUG" ]; then
    set -ex
else
    set -e
fi

# Pipeline inputs
export ACTION=${ACTION:=deploy}
export STACK_NAME=${STACK_NAME:=MyStackName}
export OPTS=${OPTS:=--no-fail-on-empty-changeset}
export PACKAGE_BUCKET=${PACKAGE_BUCKET}

# Deployment options
export DEPLOY_TEMPLATE=${DEPLOY_TEMPLATE}
export DEPLOY_PARAMETERS=${DEPLOY_PARAMETERS}
export DEPLOY_TAGS=${DEPLOY_TAGS}

# Wait for a file to exist before proceeding.
if [ ! -z "$WAIT_FOR" ]; then
    echo "Waiting for $WAIT_FOR to be available."
    while [ ! -f "$WAIT_FOR" ]; do sleep 1; done
fi

case "$ACTION" in
    deploy) deploy_stack ;;
    delete) delete_stack ;;
esac