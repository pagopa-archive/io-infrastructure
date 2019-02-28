## Terraform Setup

### Shared Terraform state

The Terraform state is shared through an Azure
[storage container](https://www.terraform.io/docs/state/remote.html).

The file `infrastructure/$ENVIRONMENT/backend.tf` contains
the name of the remote file, in the Azure Blob storage,
that stores the Terraform state for each environment.

Before running any command involving Terraform you must request access to the
Azure container to the project administrators (or use your own for testing
purposes when deploying to a test resource group).

### Troubleshooting

#### Error locking state: Error acquiring the state lock

It may happen that during a Terraform apply operation, something happens and the
lock acquired by Terraform on the remote state blog doesn't get released.
When this happen you'll get an error like this:

```
Error: Error locking state: Error acquiring the state lock: storage: service returned error: StatusCode=409, ErrorCode=LeaseAlreadyPresent, ErrorMessage=There is already a lease present.
RequestId:f2b85816-001e-00c0-2cc6-a4f222000000
Time:2018-02-13T12:32:43.1850979Z, RequestInitiated=Tue, 13 Feb 2018 12:32:42 GMT, RequestId=f2b85816-001e-00c0-2cc6-a4f222000000, API Version=2016-05-31, QueryParameterName=, QueryParameterValue=
Lock Info:
  ID:        fa16c993-763c-df60-9e37-bb16869ba6c5
  Path:      terraform-storage-container/test.terraform.tfstate
  Operation: OperationTypeApply
  Who:       federico@Ashroid
  Version:   0.11.2
  Created:   2018-02-08 14:04:27.879567437 +0000 UTC
  Info:
```

To solve this issue, you have to manually unlock the lease.

The Terraform documentation says you can use the command `terraform force-unlock`
but at the time of this writing, that command [doesn't work with the Azure backend](https://groups.google.com/forum/#!topic/terraform-tool/we21XjC58pI).

The solution is then to manually unlock the lease on the remote state blob using
the Azure CLI (`az`). For instance, to release the lock on the `test.terraform.tfstate`
blob (remote state for the `test` environment):

```
$ az storage blob lease break \
  --account-name terraformstorageaccount \
  -c terraform-storage-container \
  --blob-name test.terraform.tfstate \
  --lease-break-period 1
```

You can find further explanation about this process in [this article](https://social.msdn.microsoft.com/Forums/azure/en-US/d0df8205-c1f8-4da0-9391-460256092d34/how-to-remove-lease-so-i-can-delete-storage-account?forum=windowsazuredata).
