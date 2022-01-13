# AWS federation for GitHub Actions

Terraform module to configure GitHub Actions as an IAM OIDC identity provider in
AWS. This enables GitHub Actions to access resources within an AWS account
without requiring long-lived credentials to be stored as GitHub secrets.

## 🔨 Getting started

### Requirements

* [Terraform] 1.0+

### Installation and usage

Refer to the [complete example] to view all the available configuration options.
The following snippet shows the minimum required configuration to create a
working OIDC connection between GitHub Actions and AWS.

```terraform
provider "aws" {
  region = var.region
}

module "aws_oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "0.4.0"

  github_organisation = "honestempire"
  github_repositories = ["example-repo", "another-repo"]
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
      uses: actions/checkout@v2
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@master
      with:
        aws-region: ${{ secrets.AWS_REGION }}
        role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/github
    - run: aws sts get-caller-identity
```

### Inputs

#### Required

| Name                  | Type           | Description                      |
|-----------------------|----------------|----------------------------------|
| `github_organisation` | `string`       | GitHub organisation name.        |
| `github_repositories` | `list(string)` | List of GitHub repository names. |

#### Optional

| Name                            | Default       | Description                                             |
|---------------------------------|---------------|---------------------------------------------------------|
| `attach_admin_policy`           | `false`       | Flag to attach/detach the AdministratorAccess policy.   |
| `attach_read_only_policy`       | `true`        | Flag to attach/detach the ReadOnly policy.              |
| `enabled`                       | `true`        | Flag to enable/disable creation of resources.           |
| `force_detach_policies`         | `false`       | Flag to force detach policies attached to the IAM role. |
| `github_thumbprint`             | `"6938fd4d…"` | GitHub OpenID TLS certificate thumbprint.               |
| `iam_policy_name`               | `"github"`    | Name of the IAM policy to be assumed by GitHub.         |
| `iam_policy_path`               | `"/"`         | Path to the IAM policy.                                 |
| `iam_role_name`                 | `"github"`    | Name of the IAM role.                                   |
| `iam_role_path`                 | `"/"`         | Path to the IAM role.                                   |
| `iam_role_permissions_boundary` | `""`          | Permissions boundary to be used by the IAM role.        |
| `iam_role_policy_arns`          | `[]`          | List of IAM policy ARNs to be attached to the IAM role. |
| `managed_policy_arns`           | `[]`          | List of managed policy ARNs to apply to the IAM role.   |
| `max_session_duration`          | `3600`        | Maximum session duration in seconds.                    |
| `tags`                          | `{}`          | Map of tags to be applied to all resources.             |

### Outputs

| Name           | Type     | Description          |
|----------------|----------|----------------------|
| `iam_role_arn` | `string` | ARN of the IAM role. |

## References

* [Configuring OpenID Connect in Amazon Web Services]
* [Creating OpenID Connect (OIDC) identity providers]
* [Obtaining the thumbprint for an OpenID Connect Identity Provider]

## License

© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [Apache License 2.0].

[Apache License 2.0]: LICENSE.md
[Complete example]: examples/complete
[Configuring OpenID Connect in Amazon Web Services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[Creating OpenID Connect (OIDC) identity providers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[Make]: https://www.gnu.org/software/make/
[Obtaining the thumbprint for an OpenID Connect Identity Provider]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
[Terraform]: https://www.terraform.io
