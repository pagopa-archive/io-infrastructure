## Script Tasks

Some services aren't yet supported by Terraform (ie. CosmosDB database and
collections,
[Functions](https://github.com/terraform-providers/terraform-provider-azurerm/issues/131),
[API management](https://docs.microsoft.com/en-us/azure/api-management/)).

These ones are created by NodeJS scripts (`infrastructure/tasks`) that provision
the services through the
[Azure Resource Manager APIs](https://github.com/Azure/azure-sdk-for-node) and
are supposed to be run from command line using the relative npm (or yarn)
script:

| Command                      | Task                                                                                            |
| ---------------------------- | ----------------------------------------------------------------------------------------------- |
| `yarn resources:security:ip` | [Setup IP restrictions to access resources](./infrastructure/tasks/70-ip_security.ts)           |