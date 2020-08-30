# Infrastructure as Code

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [First run](#First-run)
- [Contribution](#Contribution)
- [Acknowledgements](#acknowledgements)


## Introduction

This repository contains our AWS cloud infrastructure described in Terraform.

## Features

Deploying Programmers-Only AWS infrastructure.


## Requirements
The AWS credentials must be configured on running/deploying host.

### Setting up AWS credentials

[AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

> NOTE: It is highly recommanded to use role-based configuration rather than storing aws credentials in your on-premis host.


## First run

Before first run you have to have your [S3 terraform backend](https://www.terraform.io/docs/backends/types/s3.html) bucket set up and update all ```main.tf``` files in every ```project-*``` directory.

PLAN and APPLY jobs should have been run in following order:

1. project-iam
2. project-core
3. project-apps


### Run ```terraform plan```

```terraform PLAN``` job is executed on every pull request and push. Thus, there is no need to run it.

### Run ```terraform apply```

Run ```terraform APPLY``` action with proper input according to [First run](#first-run) order.


## Contribution

If you want to take part in creating this tool join us on [Facebook](https://www.facebook.com/groups/programmersonlyapp/).

## Acknowledgements

* [bwieckow](https://github.com/bwieckow)
* [Aleks J](https://github.com/Cosikowy)
* [damklis](https://github.com/damklis)
* [Kubuś Bagiński](https://github.com/kubusiek)