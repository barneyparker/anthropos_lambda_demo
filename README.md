# Lambda Demo

This repo is the starting point learning how to create and deploy a Lambda
function in AWS.

The aim of the course is to get started quickly, and the repository contains the
boiler-plate files which are needed, but rarely change between projects.

Much of this code could easily be wrapped in Terraform modules to make things
easier, but for the purposes of learning, every resource will be created
manually

## What we will build

A Lambda function in its own right is fairly dull, so to make things more
accessible, we will deploy:

- An AWS API Gateway HTTP API
- A DNS name mapped to the gateway
- A simple `$default` Route
- A Lambda function which returns a __hello world__ HTML response
- An integration between the route and the Lambda function
- A CloudWatch Log Group
- An IAM Role with inline policies to write to the log file

Where practical we will follow best practices to ensure no resource collisions
with other team members etc.

## Branches

Two additional branches are available in the repository where you can find
additional code:

- `finished_code` contains the working code to deploy the Hello World
application
- `extra_credits` contains additional code for some extra challenges in Step 5

## Environment

Please use the AWS Cloud9 service to create an environment in the
`anthro-sandbox` account using the `AnthroposAdministrator` Role in the Ireland
(eu-west-1) region

You can use default setting, but please name your Cloud9 instance using your
name

Once you have created your Cloud9, shout at Barney as he needs to give it extra
permissions ;)

Cloud9 avoids a bunch of tool and dependency issues that we would otherwise need
to configure before starting.

## Preferences

- Click the Cloud9 icon in the top left of the window
- Click `Preferences` in the menu
- Click the `Experimental` tab on the left hand settings menu
- Set `Auto-Save Files` to `On Focus Change`
- Click AWS Settings in the menu
- Set `AWS Managed temporary credentials` to `Off`
- Click `Save` in the Settings menu


## Tools

In order to complete this course you will need the following tools:

### Terraform

Terraform has multiple versions, and includes the use of resource "Providers".

Download Terraform:

```
sudo wget https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip
sudo unzip terraform_0.14.6_linux_amd64.zip
sudo mv terraform /usr/bin/
```

You can confirm Terraform is correctly installed with the following command:

```
terraform --version
```

Which should respond with:

```
Terraform v0.14.6
```

### This Repository

This repository will get you started quicker.  You can obtain a copy with the
following command:

```
git clone https://github.com/barneyparker/anthropos_lambda_demo.git <your_name>
cd <your_name>
```

## Next:

Once you have Terraform and the repository installed on your Cloud9 instance,
please click the following link to begin:

[Step 0 - Getting Started](./docs/0.md)