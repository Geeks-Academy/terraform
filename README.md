# Infrastructure as Code

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Infrastructure deployment](#Infrastructure-deployment)
- [First run](#First-run)
- [Contribution](#Contribution)
- [Acknowledgements](#acknowledgements)


## Introduction

This repository contains our AWS and Azure infrastructure described in Terraform.

## Features

Deploying Geeks Academy AWS infrastructure.


## Requirements
The AWS credentials and Azure Service Principal must be configured on running/deploying host.


## Infrastructure deployment
Most of the infrastructure is defined as a Code with Terraform, so this is the basic tool which you need to install before you will try to deploy the infrastructure. [Here](https://www.terraform.io/downloads.html) you can find the Terraform CLI.

State file is stored on AWS S3 bucket.

### Setting up AWS credentials and Azure Service Principal

* [AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

> NOTE: It is highly recommanded to use role-based configuration rather than storing aws credentials in your on-premis host.

* [Azure](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell)
> NOTE: In the documentation, the process is described with usage of the Azure Cloud Shell, but of course you can use *azure cli* on your localhost. You don't need to create service principal too. Please contact with the DevOps team to get required ID and secret.


## First run

Before first run you have to have your [S3 terraform backend](https://www.terraform.io/docs/backends/types/s3.html) bucket set up and update all ```main.tf``` files in every ```project-*``` directory.

PLAN and APPLY jobs should have been run in following order:

1. project-iam
2. project-core
3. project-apps-*


### Run ```terraform plan```

```terraform PLAN``` job is executed on every pull request and push. Thus, there is no need to run it.

### Run ```terraform apply```

Run ```terraform APPLY``` action with proper input according to [First run](#first-run) order.


## Contribution

If you want to take part in creating this tool join us on [Facebook](https://www.facebook.com/groups/geeksacademy).

## Acknowledgements

* [bwieckow](https://github.com/bwieckow)
* [PiotrWachulec](https://github.com/PiotrWachulec)
* [damklis](https://github.com/damklis)