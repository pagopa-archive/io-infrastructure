## Environment Configuration

Make sure you have the following environment variables set up before launching
any npm task to provision Azure resources.

To do that, place a `.env` file in the root of this directory that contains the
following configuration variables (all mandatory):

```bash
# Service principal azure-cli-2019-03-04-13-38-43
export ARM_SUBSCRIPTION_ID=XXXXXXXXXXXXXXXXX
export ARM_CLIENT_ID=XXXXXXXXXXXXXXXXX
export ARM_CLIENT_SECRET=XXXXXXXXXXXXXXXXX
export ARM_TENANT_ID=XXXXXXXXXXXXXXXXX

# For kubernetes service principal
export TF_VAR_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET

# Old dev portal
export TF_VAR_DEV_PORTAL_EXT_CLIENT_SECRET=XXXXXXXXXXXXXXXXX
export TF_VAR_DEV_PORTAL_EXT_CLIENT_ID=XXXXXXXXXXXXXXXXX

export TF_VAR_NOTIFICATION_HUB_APNS_KEY=XXXXXXXXXXXXXXXXX
export TF_VAR_NOTIFICATION_HUB_APNS_KEY_ID=XXXXXXXXXXXXXXXXX
```
