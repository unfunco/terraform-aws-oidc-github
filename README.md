# AWS GitHub Actions OIDC Terraform Module

[![CI](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml)
[![Security](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/security.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/security.yaml)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-purple.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module to configure GitHub Actions as an OpenID Connect (OIDC)
identity provider in AWS, allowing GitHub Actions to obtain short-lived
credentials by assuming IAM roles directly, and enabling secure authentication
between GitHub Actions workflows and AWS resources.

## 🔨 Getting started

### Requirements

- [AWS Provider] 4.0+
- [TLS Provider] 3.0+
- [Terraform] 1.0+

### Installation and usage

Refer to the [complete example] to view all the available configuration options.
The following snippet shows the minimum required configuration to create a
working OIDC connection between GitHub Actions and AWS.

```terraform
module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "1.8.1"

  github_repositories = [
    "org/repo",
    "another-org/another-repo:ref:refs/heads/main",
  ]
}
```

The following demonstrates how to use GitHub Actions once the Terraform module
has been applied to your AWS account. The action receives a JSON Web Token (JWT)
from the GitHub OIDC provider and then requests an access token from AWS.

<!-- prettier-ignore -->
```yaml
jobs:
  caller-identity:
    name: Check caller identity
    permissions:
      contents: read
      id-token: write
    runs-on: ubuntu-latest
    steps:
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-region: ${{ env.AWS_REGION }}
        role-to-assume: arn:aws:iam::${{ env.AWS_ACCOUNT_ID }}:role/GitHubActions
    - run: aws sts get-caller-identity
```

#### Enterprise Cloud

Organisations using GitHub Enterprise Cloud can further improve their security
posture by setting the `enterprise_slug` variable. This configuration ensures
that the organisation will receive OIDC tokens from a unique URL, after this is
applied, the JWT will contain an updated `iss` claim.

<!-- BEGIN_TF_DOCS -->

## Resources

| Name                                                                                                                                                 | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider)    | resource    |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                          | resource    |
| [aws_iam_role_policy.inline_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                   | resource    |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)       | resource    |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_role_policy_attachment.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)   | resource    |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                                       | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate)                                 | data source |

## Inputs

| Name                            | Description                                                                   | Type           | Default           | Required |
| ------------------------------- | ----------------------------------------------------------------------------- | -------------- | ----------------- | :------: |
| additional_audiences            | List of additional OIDC audiences allowed to assume the role.                 | `list(string)` | `null`            |    no    |
| additional_thumbprints          | A list of additional thumbprints for the OIDC provider.                       | `list(string)` | `[]`              |    no    |
| attach_read_only_policy         | Flag to enable/disable the attachment of the ReadOnly policy.                 | `bool`         | `false`           |    no    |
| create_oidc_provider            | Flag to enable/disable the creation of the GitHub OIDC provider.              | `bool`         | `true`            |    no    |
| dangerously_attach_admin_policy | Flag to enable/disable the attachment of the AdministratorAccess policy.      | `bool`         | `false`           |    no    |
| enterprise_slug                 | Enterprise slug for GitHub Enterprise Cloud customers.                        | `string`       | `""`              |    no    |
| force_detach_policies           | Flag to force detachment of policies attached to the IAM role.                | `bool`         | `false`           |    no    |
| github_repositories             | A list of GitHub organization/repository names authorized to assume the role. | `list(string)` | n/a               |   yes    |
| iam_role_inline_policies        | Inline policies map with policy name as key and json as value.                | `map(string)`  | `{}`              |    no    |
| iam_role_name                   | The name of the IAM role to be created and made assumable by GitHub Actions.  | `string`       | `"GitHubActions"` |    no    |
| iam_role_path                   | The path under which to create IAM role.                                      | `string`       | `"/"`             |    no    |
| iam_role_permissions_boundary   | The ARN of the permissions boundary to be used by the IAM role.               | `string`       | `""`              |    no    |
| iam_role_policy_arns            | A list of IAM policy ARNs to attach to the IAM role.                          | `list(string)` | `[]`              |    no    |
| max_session_duration            | The maximum session duration in seconds.                                      | `number`       | `3600`            |    no    |
| tags                            | A map of tags to be applied to all applicable resources.                      | `map(string)`  | `{}`              |    no    |

## Outputs

| Name              | Description                   |
| ----------------- | ----------------------------- |
| iam_role_arn      | The ARN of the IAM role.      |
| iam_role_name     | The name of the IAM role.     |
| oidc_provider_arn | The ARN of the OIDC provider. |

<!-- END_TF_DOCS -->

## References

- [Configuring OpenID Connect in Amazon Web Services]
- [Creating OpenID Connect (OIDC) identity providers]
- [Obtaining the thumbprint for an OpenID Connect Identity Provider]
- [GitHub Actions – Update on OIDC integration with AWS]

## License

© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [MIT License].

[aws provider]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
[complete example]: examples/complete
[configuring openid connect in amazon web services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[creating openid connect (oidc) identity providers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[make]: https://www.gnu.org/software/make/
[mit license]: LICENSE.md
[obtaining the thumbprint for an openid connect identity provider]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
[terraform]: https://www.terraform.io
[tls provider]: https://registry.terraform.io/providers/hashicorp/tls/latest/docs
[github actions – update on oidc integration with aws]: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
