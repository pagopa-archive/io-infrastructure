## First time setup of an Azure environment

**NOTE: you should probably not need this unless you're setting up a new Azure environment from scratch.**

### Environments

For each of the two different environments (`test` or `production`)
a directory in `env` contains the relative configuration.

The configuration consists in a JSON file (`tfvars.json`) with the name of the Azure services
that need to be provisioned (ie. web applications, databases) in a specific
[resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
(one for each environment).

The automated setup tools (discussed below) take the value from the
`ENVIRONMENT` environment variable, that **must be set** at the beginning of the
whole procedure.

ie:

```
ENVIRONMENT=test
```

### First time set up an Azure Active Directory B2C tenant

#### Step 1 - Add an Azure Active Directory B2C resource

To authenticate Digital Citizenship API users (through the developer portal) we
use an
[Active Directory B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-overview)
(ADB2C) tenant.

As it's actually not possible to create (and manage) an ADB2C tenant
programmatically, it must be manually created. See the get started guide:

https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-get-started

The ADB2C tenant _must_ exists _before_ running any task illustrated below.

Once created, before going on with the installation procedure, put the tenant
name in `TF_VAR_ADB2C_TENANT_ID` environment variable:

```
ADB2C_TENANT_ID=<yourtenant>.onmicrosoft.com
```

#### Step 2 - Add custom users attributes in ADB2C

During user sign-in to the Digital Citizenship API we collect some custom
attributes relative to the user account.

Go to the ADB2C blade in the Azure portal, then select "User attributes" and add
the following custom attributes (type is always "String"):

1.  Organization
1.  Department
1.  Service

#### Step 3 - Add and configure an ADB2C Sign-in / Sign-up policy

For users to be able to sign-in and sign-up through ADB2C you need to
[create a Sign-in / Sign-up Policy](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-policies).

Go the Azure ADB2C blade in the Azure portal -> "Sign-up or Sign-in policies" ->
"Add".

Policy Name:

* SignUpIn

Identity Providers:

* Email signup

Sign-up attributes:

* Department
* Display Name
* Given Name
* Organization
* Service
* Surname

Application claims:

* Department
* Display Name
* Given Name
* Organization
* Service
* Surname
* Email Addresses
* Identity Provider
* User is new
* User's Object ID

Multifactor authentication:

* On

Page UI customization:

* Set up for every page the following custom page URI:\
  https://teamdigitale.github.io/digital-citizenship-onboarding/unified.html
* Save the policy
* Customize the "Multifactor authentication page"
* Open "Local account sign-up page"
  * Mark all fields as required (optional = no)
  * Reorder fields and rename labels at wish

#### Step 4 - Add the Developer Portal Applications in the Azure ADB2C tenant

Finally, you need to register (create) the Developer Portal ADB2C Applications:

[instructions on how to create an ADB2C application](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-app-registration)

1.  Register an ADB2C Application `dev-portal-app`

Set the return URL of this application to:\
`https://${apim}.portal.azure-api.net/signin-aad`

(replace `${APIM}` with the value of `config.azurerm_apim` in your tfvars.json
file)

Generate an application key, then set the two environment variables:

```
TF_VAR_DEV_PORTAL_CLIENT_ID=<Application Id>
TF_VAR_DEV_PORTAL_CLIENT_SECRET=<Application Key>
```

2.  Register an ADB2C Application `dev-portal-ext`

Set the return URL of this application to:\
https://`${PORTAL}`.azurewebsites.net/auth/openid/return

(replace `${PORTAL}` with the value of `config.azurerm_app_service_portal` in
your tfvars.json file)

Generate an application key, then set the two environment variables:

```
TF_VAR_DEV_PORTAL_EXT_CLIENT_ID=<Application Id>
TF_VAR_DEV_PORTAL_EXT_CLIENT_SECRET=<Application Key>
```

### Steps to create and configure Azure resources

1.  Ask the Azure subscription administrator for the credentials of the
    [Active Directory Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-application-objects)
    used to let Terraform and the automated setup tools authenticate to Azure.

Set up the following enviroment variables:

```
ARM_SUBSCRIPTION_ID=<subscription Id>
ARM_CLIENT_ID=<service principal client (app) Id>
ARM_CLIENT_SECRET=<service principal client secret (key)>
TF_VAR_ARM_CLIENT_SECRET=<same value as ARM_CLIENT_SECRET>
ARM_TENANT_ID=<Active Directory domain Id>
```

2.  Check your [enviroment configuration](#example-environment-configuration)
    then run:

```
yarn infrastructure:deploy
```

Running the above command will deploy the following services to an Azure
resource group:

* [App service plan](https://azure.microsoft.com/en-us/pricing/details/app-service/plans/)
* [Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
  app (configured)
* [CosmosDB database](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)
  (and collections)
* [Storage account](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)
* [Storage queues](https://azure.microsoft.com/en-us/services/storage/queues/)
  (for emails and messages)
* [Blob storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
* [API management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
  (with configuration)
* [Application insights](https://azure.microsoft.com/it-it/services/application-insights/)
* [Log analytics](https://azure.microsoft.com/en-au/services/log-analytics/)
* [EventHub](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Web App service](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview)

### Finishing the installation

Some tasks cannot be carried out programmatically and require a manual
intervention by the Azure subscription administrator through the Azure portal
interface.

#### Activate "Managed Service Identity" for the onboarding Web App Service

**NOTE**: we are in the process of migrating to [a new dev portal](https://github.com/teamdigitale/io-messages-web).

To ease the onboarding of new developers (API users) we use a dedicated
[Application](https://github.com/teamdigitale/digital-citizenship-onboarding)
that starts some automated tasks once the user sign-in into the developer
portal.

This web application exposes an HTTP endpoint that triggers some actions on the
authenticated user's account (ie. create a subscription to use the Digital
Citizenship API). These actions are triggered when the logged-in user clicks on
a call-to-action button that redirects her browser to the exposed endpoint.

To give the needed permissions (manage API management users account) to the
onboarding Web App we use
[Managed Service Identity](https://docs.microsoft.com/en-us/azure/active-directory/msi-overview).
In this way we can manage developer portal users directly from the Web
application without hardcoding any client credential into the App Service
settings.

To activate Managed Service Identity and assign the needed role to the App
Service:

1.  Navigate to the Azure Portal App Service blade (for the Web App Service
    ${config.azurerm_app_service_portal}) -> Managed Service Identity -> Register
    with Azure Active Directory -> set the value to 'On'.

1.  Navigate to the Azure Portal API management blade -> Access Control (IAM) ->
    Add the registered Web application as a "Contributor".

1.  Restart the Web App Service.
