## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gitlab_url | The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com. | `string` | `"https://gitlab.com"` | no |
| audience | The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com. | `string` | `"https://gitlab.com"` | no |
| iam\_role\_policy\_arns | List of IAM policy ARNs to attach to the IAM role. | `list(string)` | `[]` | no |
| match\_field | Issuer, the domain of your GitLab instance. Change to sub if you want to use the filter to any project | `string` | n/a | yes |
| match\_value | value | `list` | n/a | yes |

## Optional Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attach\_admin\_policy | Flag to enable/disable the attachment of the AdministratorAccess policy. | `bool` | `false` | no |
| create\_oidc\_provider | Flag to enable/disable the creation of the GitHub OIDC provider. | `bool` | `true` | no |
| enabled | Flag to enable/disable the creation of resources. | `bool` | `true` | no |
| force\_detach\_policies | Flag to force detachment of policies attached to the IAM role. | `string` | `false` | no |
| gitlab\_thumbprint | GitLab OpenID TLS certificate thumbprint. | `string` | `"d89e3bd43d5d909b47a18977aa9d5ce36cee184c"` | no |
| iam\_role\_name | Name of the IAM role to be created. This will be assumable by GitLab. | `string` | `"gitlab_action_role"` | no |
| iam\_role\_path | Path under which to create IAM role. | `string` | `"/"` | no |
| match\_field | Issuer, the domain of your GitLab instance. Change to sub if you want to use the filter to any project | `string` | n/a | yes |
| match\_value | value | `list` | n/a | yes |
| max\_session\_duration | Maximum session duration in seconds. | `number` | `3600` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | ARN of the IAM role. |

