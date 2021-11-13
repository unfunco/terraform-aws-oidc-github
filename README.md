# AWS federation for GitHub Actions

## Getting started

### Requirements

* [Make]
* [Terraform] 1.0+

### Installation and usage

### Obtaining the thumbprint

```bash
JWKS=$(curl -s https://token.actions.githubusercontent.com/.well-known/openid-configuration | jq -r '.jwks_uri')
echo $JWKS | awk -F[/:] '{print $4}'

openssl s_client -servername token.actions.githubusercontent.com -showcerts -connect token.actions.githubusercontent.com:443

# Paste the last certificate into a file called certificate.crt
openssl x509 -in certificate.crt -fingerprint -noout
```

## License

© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [Apache License 2.0].

[Apache License 2.0]: LICENSE.md
[Make]: https://www.gnu.org/software/make/
[Terraform]: https://www.terraform.io
