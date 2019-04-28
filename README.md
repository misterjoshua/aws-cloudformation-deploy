<img src="https://img.shields.io/docker/cloud/automated/wheatstalk/aws-cloudformation-deploy.svg" /> <img src="https://img.shields.io/docker/cloud/build/wheatstalk/aws-cloudformation-deploy.svg" />

# Supported tags and respective `Dockerfile` links

## Simple Tags
* [`1`, `latest` *(Dockerfile)*](https://github.com/misterjoshua/aws-cloudformation-deploy/blob/master/Dockerfile)

# What is this repository?
This repository implements a CloudFormation deployment pipe for Bitbucket Pipelines. With this pipe you can deploy a CloudFormation template into a stack from a CI/CD pipeline hosted in Bitbucket Pipelines.

An example of how to use this pipe in a Bitbucket Pipeline step:

```
script:
  - pipe: wheatstalk/aws-cloudformation-deploy:1
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID # using one of my repository variables
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION: 'us-east-1'
      DEPLOY_TEMPLATE: 'yourtemplate.yaml'
      STACK_NAME: 'MyStackName'
```

# What is AWS CloudFormation?
[AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) is a service that helps you model and set up your Amazon Web Services resources so that you can spend less time managing those resources and more time focusing on your applications that run in AWS. You create a template that describes all the AWS resources that you want (like Amazon EC2 instances or Amazon RDS DB instances), and AWS CloudFormation takes care of provisioning and configuring those resources for you.

# What is Bitbucket Pipelines?
[Bitbucket Pipelines](https://confluence.atlassian.com/bitbucket/get-started-with-bitbucket-pipelines-792298921.html) is an integrated CI/CD service, built into Bitbucket. It allows you to automatically build, test and even deploy your code, based on a configuration file in your repository.

## What are "Pipes" in Bitbucket Pipelines?
[Pipes simplify configuring your pipeline.](https://confluence.atlassian.com/bitbucket/pipes-958765631.html) They are extra powerful for actions that normally take several lines of code, especially when you want to work with third party tools. You just paste the pipe, supply a few key pieces of information, and the rest is done for you.

# How to use this image
## Put the template into a build step
```
script:
  - pipe: wheatstalk/aws-cloudformation-deploy:1
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID # using one of my repository variables
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION: 'us-east-1'
      DEPLOY_TEMPLATE: 'yourtemplate.yaml'
      STACK_NAME: 'MyStackName'
```

## Use Template Parameters
To enter CloudFormation parameters, provide variables named `PARAM_MyParameterName` and the pipe will provide `MyParameterName` as a parameter override to the stack.

```
script:
  - pipe: wheatstalk/aws-cloudformation-deploy:1
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID # using one of my repository variables
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION: 'us-east-1'
      DEPLOY_TEMPLATE: 'yourtemplate.yaml'
      STACK_NAME: 'MyStackName'
      PARAM_MyParamName: 'MyParamValue'
      PARAM_MyOtherParamName: 'MyOtherParamValue'
```

## Nested Stacks
To deploy nested stacks, provide the `PACKAGE_BUCKET` variable with the name of an S3 bucket that can hold the intermediary files. The pipe will automatically run `aws cloudformation package` for you and deploy the output.

```
script:
  - pipe: wheatstalk/aws-cloudformation-deploy:1
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID # using one of my repository variables
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION: 'us-east-1'
      DEPLOY_TEMPLATE: 'yourtemplate.yaml'
      STACK_NAME: 'MyStackName'
      PACKAGE_BUCKET: 'my-s3-bucket'
```

# License
This repository's source is licensed under the [Apache License 2.0](https://github.com/misterjoshua/aws-cloudformation-deploy/blob/master/LICENSE).

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.