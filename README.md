# AWS federation for GitHub Actions

[![CI](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml)
[![Cron / Verify](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/cron.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/cron.yaml)
[![Security](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/security.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/security.yaml)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-purple.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module to configure GitHub Actions as an IAM OIDC identity provider in
AWS. This enables GitHub Actions to access resources within an AWS account
without requiring long-lived credentials to be stored as GitHub secrets.

## 🔨 Getting started

### Requirements

- [Terraform] 1.0+

### Installation and usage

Refer to the [complete example] to view all the available configuration options.
The following snippet shows the minimum required configuration to create a
working OIDC connection between GitHub Actions and AWS.

```terraform
provider "aws" {
  region = var.region
}

module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "1.1.0"

  github_repositories = [
    "org/repo",
    "another-org/another-repo:ref:refs/heads/main",
  ]
}
```

The following demonstrates how to use GitHub Actions once the Terraform module
has been applied to your AWS account. The action receives a JSON Web Token (JWT)
from the GitHub OIDC provider and then requests an access token from AWS.

```yaml
jobs:
  caller-identity:
    name: Check caller identity
    permissions:
      contents: read
      id-token: write
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-region: ${{ secrets.AWS_REGION }}
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/github
      - run: aws sts get-caller-identity
```

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attach\_admin\_policy | Flag to enable/disable the attachment of the AdministratorAccess policy. | `bool` | `false` | no |
| attach\_read\_only\_policy | Flag to enable/disable the attachment of the ReadOnly policy. | `bool` | `true` | no |
| create\_oidc\_provider | Flag to enable/disable the creation of the GitHub OIDC provider. | `bool` | `true` | no |
| enabled | Flag to enable/disable the creation of resources. | `bool` | `true` | no |
| force\_detach\_policies | Flag to force detachment of policies attached to the IAM role. | `bool` | `false` | no |
| github\_repositories | List of GitHub organization/repository names authorized to assume the role. | `list(string)` | n/a | yes |
| iam\_role\_inline\_policies | Inline policies map with policy name as key and json as value. | `map(string)` | `{}` | no |
| iam\_role\_name | Name of the IAM role to be created. This will be assumable by GitHub. | `string` | `"github"` | no |
| iam\_role\_path | Path under which to create IAM role. | `string` | `"/"` | no |
| iam\_role\_permissions\_boundary | ARN of the permissions boundary to be used by the IAM role. | `string` | `""` | no |
| iam\_role\_policy\_arns | List of IAM policy ARNs to attach to the IAM role. | `list(string)` | `[]` | no |
| max\_session\_duration | Maximum session duration in seconds. | `number` | `3600` | no |
| tags | Map of tags to be applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | ARN of the IAM role. |
<!-- END_TF_DOCS -->

## References

- [Configuring OpenID Connect in Amazon Web Services]
- [Creating OpenID Connect (OIDC) identity providers]
- [Obtaining the thumbprint for an OpenID Connect Identity Provider]

## License

© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [Apache License 2.0].

[apache license 2.0]: LICENSE.md
[complete example]: examples/complete
[configuring openid connect in amazon web services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[creating openid connect (oidc) identity providers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[make]: https://www.gnu.org/software/make/
[obtaining the thumbprint for an openid connect identity provider]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
[terraform]: https://www.terraform.io
