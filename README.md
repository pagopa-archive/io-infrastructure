# IO-INFRASTRUCTURE

**WARNING: the following instructions may not be up to date, please ask
a project maintainer before attempting to setup or update the
infrastructure.**

The
[infrastructure](https://github.com/teamdigitale/io-infrastructure/tree/master/infrastructure)
drectory contains scripts and Terraform configuration to deploy the
infrastructure on the Azure cloud.

## Prerequisites

* An active [Azure subscription](https://azure.microsoft.com/en-us/free)
* [Git](https://git-scm.com/)
* [NodeJS](https://nodejs.org/it/) >= 0.6.x
* [Terraform](https://terraform.io) >= 0.10.x
* [Yarn](https://yarnpkg.com) >= 1.0.x
* NPM packages: run `yarn install`

All binaries must be in the system path.

## What's in the Infrastructure folder?

* `$ENVIRONMENT/tfvars.json`: read by Terrafom and the automated tasks, contains the name of the Azure resources specific to one enviroment
* `azure.tf`: the main Terraform configuration file; it takes variables value from `tfvars.json`
* `common/tfvars.json`: read by Terraform and the automated tasks, contains values for variables common to all environments; rarely needs to be changed
* `common/config.json`: a configuration file read by the automated tasks (ignored by Terraform); rarely needs to be changed
* `apim/*`: a directory that contains the configuration of the API management resource (ie. portal templates) taken from the [embedded git repository](https://docs.microsoft.com/en-us/azure/api-management/api-management-configuration-repository-git)
* `api-policies`: API policies used by the API management

## How-Tos

### Environment Setup

* [Configuring The Environment](docs/environment-setup.md)
* [Setting Up Terraform](docs/terraform-setup.md)

### Common Tasks

* [Deploying API Function Releases](docs/api-functions-deploy.md)
* [Setup IP restrictions to access resources](docs/scripts-howto.md)

### Other Tasks

* [First time set up of the Azure Active Directory B2C tenant](docs/azure-initial-setup.md)
