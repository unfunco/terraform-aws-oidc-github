# AWS federation for GitHub Actions

Terraform module to configure GitHub as an OpenID Connect identity provider for
Amazon Web Services. This will allow GitHub Actions to access resources within
your AWS account without requiring long-lived credentials to be stored as
secrets in GitHub.

## Getting started

### Requirements

* [Make] 3.81+
* [Terraform] 1.0+

### Installation and usage

```terraform
provider "aws" {
  region = var.region
}

module "aws_federation_github" {
  source  = "unfunco/federation-github/aws"
  version = "0.1.0"
  
  github_organisation = "unfunco"
  github_repository   = "terraform-aws-federation-github"
}
```

### Obtaining the thumbprint

```bash
JWKS=$(curl -s https://token.actions.githubusercontent.com/.well-known/openid-configuration | jq -r '.jwks_uri')
echo $JWKS | awk -F[/:] '{print $4}'

openssl s_client -servername token.actions.githubusercontent.com -showcerts -connect token.actions.githubusercontent.com:443

# Paste the last certificate into a file called certificate.crt
openssl x509 -in certificate.crt -fingerprint -noout
```

## References

* [Configuring OpenID Connect in Amazon Web Services]

## License

© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [Apache License 2.0].

[Apache License 2.0]: LICENSE.md
[Configuring OpenID Connect in Amazon Web Services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[Make]: https://www.gnu.org/software/make/
[Terraform]: https://www.terraform.io
