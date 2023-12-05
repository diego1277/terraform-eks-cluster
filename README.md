# Terraform EKS cluster module

## Requirements
Binary version ```v1.3.2```

## Providers
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.41.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Resources
| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## How to
Set up default configuration
```
module "cluster" {
  source = "github.com/diego1277/terraform-eks-cluster.git"
  name = "my-cluster-name"
  vpc_id = "my-vpc-id"
  subnets_id = ["my-subnet-id-01","my-subnet-id-02"]
}
```
Enable IRSA
```
module "cluster" {
  source = "github.com/diego1277/terraform-eks-cluster.git"
  name = "my-cluster-name"
  enable_openid_connect = true
  vpc_id = "my-vpc-id"
  subnets_id = ["my-subnet-id-01","my-subnet-id-02"]
}

module "irsa" {
  source = "github.com/diego1277/terraform-kubernetes-addons.git//eks/irsa"
  openid_connect_arn = module.cluster.openid_connect_arn
  openid_connect_url = module.cluster.openid_connect_url
  service_account_name = "my-service-account" 
  namespace = "my-namespace"
  policy_arn = "my-policy-arn"
}
```
Node groups
```
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | additional tags | `map(any)` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | kubernetes version | `string` | `"1.24"` | no |
| <a name="input_enable_openid_connect"></a> [enable\_openid\_connect](#input\_enable\_openid\_connect) | enable openid connect provider | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | cluster name | `string` | n/a | yes |
| <a name="input_subnets_id"></a> [subnets\_id](#input\_subnets\_id) | subnets id | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_cert"></a> [cert](#output\_cert) | cluster certificate |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | cluster endpoint |
| <a name="output_name"></a> [name](#output\_name) | cluster name |
| <a name="output_openid_connect_arn"></a> [openid\_connect\_arn](#output\_openid\_connect\_arn) | openid connect arn |
| <a name="output_openid_connect_url"></a> [openid\_connect\_url](#output\_openid\_connect\_url) | openid connect url |

## Author:
- `Diego Oliveira`                                                                                                 
