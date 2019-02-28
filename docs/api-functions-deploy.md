## Deploy new API releases

**WARNING**: these instructions should be reviewed and may be obsolete, check out the [deploy instructions](https://github.com/teamdigitale/io-functions#deployment-process) in the io-functions repository.

When you are ready to deploy a new release, you need to synch the source code in
the Git repository to the App Service (or to Azure Functions).

Azure gives you the option to configure continuos deployment from a GitHub
branch, automatically triggering a new deploy through a webhook when changes are
pushed. To do that you must give your Azure subscription access to your GitHub
account in order to set up the webhook:\
https://docs.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment

We chose to not setup this kind of continous deployment, but to provide a script
that, when launched from the command line, will synch the code from the GitHub
repository to Azure services.

To deploy new code to the developer portal web application run:

```
yarn deploy:devapp:sync
```

To deploy new code to Azure Functions run:

```
yarn deploy:functions:sync
```