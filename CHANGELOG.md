# Changelog

Notable changes to this project are documented in this changelog.  
This project adheres to the [semantic versioning] specification.

## [0.5.0] – 2022-03-10

* Allow the use of existing GitHub OIDC providers ([6b40b05](https://github.com/unfunco/terraform-aws-oidc-github/commit/6b40b05b203b9ed7f1d119f4613937446b8c3bcb))

## [0.4.1] – 2022-03-02

* Fixed an incorrect type for the tags variable ([8965bec](https://github.com/unfunco/terraform-aws-oidc-github/commit/8965becb055ca8f117b5d02bfc864133a35444e2))
* Send a Slack notification when the verification workflow fails ([91c1913](https://github.com/unfunco/terraform-aws-oidc-github/commit/91c1913a7e8eed9f9ef892e8d2973ada027e091f))

## [0.4.0] – 2022-01-13

* Allow the thumbprint to be specified as a variable ([4481aef](https://github.com/unfunco/terraform-aws-oidc-github/commit/4481aef9ccb2f4525f84b62f1e4eda4b6d49876f))
* Updated the default thumbprint ([af68a05](https://github.com/unfunco/terraform-aws-oidc-github/commit/af68a05de5b12d39d8f1120085ca4596bbcefa97))

## [0.3.0] – 2021-12-22

* Add an option to attach the AdministratorAccess policy ([ce3fb8e](https://github.com/unfunco/terraform-aws-oidc-github/commit/ce3fb8ee309833d3c2095d5557355fbff9416888))

## [0.2.0] – 2021-12-22

* Add support for multiple repositories ([0216f7b](https://github.com/unfunco/terraform-aws-oidc-github/commit/0216f7b5ffe409943efc9afd22e59278e5105ec9))
* Fix incorrectly referenced output in the complete example ([a78a0ed](https://github.com/unfunco/terraform-aws-oidc-github/commit/a78a0ed898f6429ac20c9fac4c7c85b3ca2d9310))

## [0.1.2] – 2021-12-10

* Add missing permission in the usage instructions ([1252f5d](https://github.com/unfunco/terraform-aws-oidc-github/commit/1252f5d0c4532e91a0f99c725c23202b1b278969))
* Remove unused IAM policy document ([24afc52](https://github.com/unfunco/terraform-aws-oidc-github/commit/24afc5258424f9e525624b3327c26d7db792b406))

## [0.1.1] – 2021-12-10

* Fix default variable value for the IAM role permission boundary ([c96042e](https://github.com/unfunco/terraform-aws-oidc-github/commit/c96042ed07daa1537b11ad89ba2d0b74b6ac887e))
* Format Terraform sources ([d447edb](https://github.com/unfunco/terraform-aws-oidc-github/commit/d447edbab405dba2db1cdb0b1ae375aa7317ff09))

## [0.1.0] – 2021-12-10

* Initial release

[0.1.0]: https://github.com/unfunco/terraform-aws-oidc-github/releases/tag/v0.1.0
[0.1.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.0...v0.1.1
[0.1.2]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.1...v0.1.2
[0.2.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.2...v0.2.0
[0.3.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.3.0...v0.4.0
[0.4.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.4.0...v0.4.1
[0.5.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.4.1...v0.5.0
[Semantic versioning]: https://semver.org
