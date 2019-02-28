## Environment Configuration

Make sure you have the following environment variables set up before launching
any npm task to provision Azure resources.

To do that, place a `.env` file in the root of this directory that contains the
following configuration variables (all mandatory):

```bash
# May be `test` or `production`
ENVIRONMENT=test

# Tenant name of the Active Directory B2C
# Ask the project administrator for the value of this variable
TF_VAR_ADB2C_TENANT_ID=XXXXXXXXX.onmicrosoft.com

# Azure service principal credentials (main AD tenant)
ARM_SUBSCRIPTION_ID=XXXXX-XXXX-XXXX-XXXX-dXXXXXXXXX
ARM_CLIENT_ID=XXXXXXX-XXXX-XXXX-XXX-XXXXXXXXX
ARM_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXX=
ARM_TENANT_ID=XXXXXXX-XXXXX-XXXX-XXXX-XXXXXXXXXXX

# -------- Ask the project administrator for
# -------- the values of the following credentials

# Client credentials for dev-portal ADB2C App
TF_VAR_DEV_PORTAL_CLIENT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX
TF_VAR_DEV_PORTAL_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXX

# Client credentials for dev-portal-ext ADB2C App
TF_VAR_DEV_PORTAL_EXT_CLIENT_ID=XXXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX
TF_VAR_DEV_PORTAL_EXT_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXX

# Mail service credentials
TF_VAR_MAILUP_USERNAME=XXXXXXX
TF_VAR_MAILUP_SECRET=XXXXXXX

# Notification HUB credentials for GCM (Android) and APNS (iOS)
TF_VAR_NOTIFICATION_HUB_GCM_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
TF_VAR_NOTIFICATION_HUB_APNS_KEY_ID="XXXXXXXXXXX"
TF_VAR_NOTIFICATION_HUB_APNS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Secret token that is appended to the Webhook URL (API backend)
TF_VAR_WEBHOOK_CHANNEL_URL_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
