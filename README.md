# Private Ethereum on Kubernetes

## TO Deploy
```bash
terraform init
terraform plan
terraform apply
```

## Inputs
* __role\_arn__ - AWS role assumed to deploy cluster.
* __region__ - AWS region to deploy cluster to.
* __deploy\_ethereum__ - bool to determine if you should deploy ethereum to the cluster;
default is false.
* __map\_users__ - Additional users to add to aws\_auth.

## TODO
* Move deployment to Helm.

## Troubleshooting

### Hiccup?
```bash
module.ethereum_cluster.module.eks.null_resource.wait_for_cluster[0]: Creation complete after 1m21s [id=644387047614358437]

Error: fork/exec /Users/jbennett/Documents/code/terraform/ethereum/.terraform/plugins/darwin_amd64/terraform-provider-kubernetes_v1.11.3_x4: no such file or directory



Error: Error running command 'aws eks update-kubeconfig --name Ethereum-LwixD3tN': exit status 255. Output:
An error occurred (ResourceNotFoundException) when calling the DescribeCluster operation: No cluster found for name: Ethereum-LwixD3tN.

```
