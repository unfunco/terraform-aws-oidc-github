# AWS GitHub Actions OIDC Terraform Module

[![CI](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml/badge.svg)](https://github.com/unfunco/terraform-aws-oidc-github/actions/workflows/ci.yaml)
[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-unfunco%2Foidc--github-blue?logo=terraform)](https://registry.terraform.io/modules/unfunco/oidc-github/aws)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE.md)

Terraform module to configure GitHub Actions as an OpenID Connect (OIDC)
identity provider in AWS, allowing GitHub Actions to obtain short-lived
credentials by assuming IAM roles directly, and enabling secure authentication
between GitHub Actions workflows and AWS resources.

## 🔨 Getting started

### Requirements

- [Terraform] 1.0+

### Installation and usage

The following snippet shows the minimum required configuration to create a
working OIDC connection between GitHub Actions and AWS.

<!-- x-release-please-start-version -->

```terraform
module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "2.0.2"

  github_repositories = ["org/repo"]
}
```

<!-- x-release-please-end -->

By default, it will only allow the `main` branch of the specified repository to
assume the IAM role, you can set the `default_branch_name` variable to `master`
if necessary, or specify `*` to allow all branches to assume the role. To allow
specific branches or tags, you can include an explicit ref:

```terraform
github_repositories = [
  "org/repo:ref:refs/heads/main",
  "org/repo:ref:refs/heads/release/*",
  "org/repo:ref:refs/tags/v*",
]
```

To attach additional AWS managed policies to the IAM role, provide the policy
name or path after `policy/` and the module will generate the correct ARN for
the active AWS partition:

```terraform
iam_role_policy_names = [
  "ReadOnlyAccess",
  "service-role/AWSLambdaBasicExecutionRole",
]
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

Setting `enterprise_slug` in AWS is only one side of the configuration. An
enterprise administrator must also enable the custom issuer policy in GitHub so
that Actions will issue tokens from the enterprise-scoped URL:

```sh
gh auth refresh -h github.com -s admin:enterprise

gh api \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  /enterprises/ENTERPRISE/actions/oidc/customization/issuer \
  --input - <<< '{"include_enterprise_slug":true}'
```

A successful request returns `204 No Content`, so `gh api` will exit without a
response body. Add `-i` if you want to see the HTTP status line.

To validate the change end-to-end, rerun a workflow that requests an OIDC token
and confirm that your cloud provider sees the enterprise-scoped issuer (for
example `token.actions.githubusercontent.com/ENTERPRISE`) or that
`aws-actions/configure-aws-credentials` now succeeds against the
enterprise-scoped IAM OIDC provider.

<!-- BEGIN_TF_DOCS -->

### Resources

| Name                                                                                                                                                 | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider)    | resource    |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                          | resource    |
| [aws_iam_role_policy.inline_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                   | resource    |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)       | resource    |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                                       | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate)                                 | data source |

### Inputs

| Name                            | Description                                                                                                                                                            | Type           | Default                                  | Required |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------- | :------: |
| additional_audiences            | Additional OIDC audiences allowed to assume the role.                                                                                                                  | `list(string)` | `null`                                   |    no    |
| additional_thumbprints          | Additional thumbprints for the OIDC provider.                                                                                                                          | `list(string)` | `[]`                                     |    no    |
| create                          | Enable/disable the creation of all resources.                                                                                                                          | `bool`         | `true`                                   |    no    |
| create_iam_role                 | Enable/disable creation of the IAM role.                                                                                                                               | `bool`         | `true`                                   |    no    |
| create_oidc_provider            | Enable/disable the creation of the GitHub OIDC provider.                                                                                                               | `bool`         | `true`                                   |    no    |
| dangerously_attach_admin_policy | Enable/disable the attachment of the AdministratorAccess policy.                                                                                                       | `bool`         | `false`                                  |    no    |
| default_branch_name             | Default branch name for repositories without an explicit ref. Use '\*' to allow all refs (less secure).                                                                | `string`       | `"main"`                                 |    no    |
| enterprise_slug                 | Enterprise slug for GitHub Enterprise Cloud customers.                                                                                                                 | `string`       | `""`                                     |    no    |
| github_repositories             | GitHub organization/repository names authorized to assume the role.                                                                                                    | `list(string)` | `[]`                                     |    no    |
| iam_role_description            | Description of the IAM role to be created.                                                                                                                             | `string`       | `"Assumed by the GitHub OIDC provider."` |    no    |
| iam_role_force_detach_policies  | Force detachment of policies attached to the IAM role.                                                                                                                 | `bool`         | `false`                                  |    no    |
| iam_role_inline_policies        | Inline policies map with policy name as key and json as value.                                                                                                         | `map(string)`  | `{}`                                     |    no    |
| iam_role_max_session_duration   | The maximum session duration in seconds.                                                                                                                               | `number`       | `3600`                                   |    no    |
| iam_role_name                   | The name of the IAM role to be created and made assumable by GitHub Actions.                                                                                           | `string`       | `"GitHubActions"`                        |    no    |
| iam_role_path                   | The path under which to create IAM role.                                                                                                                               | `string`       | `"/"`                                    |    no    |
| iam_role_permissions_boundary   | The ARN of the permissions boundary to be used by the IAM role.                                                                                                        | `string`       | `""`                                     |    no    |
| iam_role_policy_names           | AWS managed IAM policy names to attach to the IAM role. Provide the value after `policy/`, for example `ReadOnlyAccess` or `service-role/AWSLambdaBasicExecutionRole`. | `list(string)` | `[]`                                     |    no    |
| iam_role_tags                   | Additional tags to be applied to the IAM role.                                                                                                                         | `map(string)`  | `{}`                                     |    no    |
| oidc_provider_tags              | Tags to be applied to the OIDC provider.                                                                                                                               | `map(string)`  | `{}`                                     |    no    |
| tags                            | Tags to be applied to all applicable resources.                                                                                                                        | `map(string)`  | `{}`                                     |    no    |

### Outputs

| Name               | Description                                                             |
| ------------------ | ----------------------------------------------------------------------- |
| assume_role_policy | The assume role policy document that can be attached to your IAM roles. |
| iam_role_arn       | The ARN of the IAM role.                                                |
| iam_role_name      | The name of the IAM role.                                               |
| oidc_provider_arn  | The ARN of the OIDC provider.                                           |
| oidc_provider_url  | The URL of the OIDC provider.                                           |

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
[configuring openid connect in amazon web services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[creating openid connect (oidc) identity providers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[github actions – update on oidc integration with aws]: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
[make]: https://www.gnu.org/software/make/
[mit license]: LICENSE.md
[obtaining the thumbprint for an openid connect identity provider]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
[terraform]: https://www.terraform.io
[tls provider]: https://registry.terraform.io/providers/hashicorp/tls/latest/docs
