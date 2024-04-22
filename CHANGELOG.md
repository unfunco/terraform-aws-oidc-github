# Changelog

Notable changes to this project are documented in this changelog.  
This project adheres to the [semantic versioning] specification.

## [1.8.0](https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.7.1...v1.8.0) (2024-04-22)


### New features

* Begin automating the release process ([#42](https://github.com/unfunco/terraform-aws-oidc-github/issues/42)) ([c9493af](https://github.com/unfunco/terraform-aws-oidc-github/commit/c9493aff293beb6797da347ca282bd3f0d9913c3))


### Miscellaneous

* Automatically upgrade workflow dependencies ([#48](https://github.com/unfunco/terraform-aws-oidc-github/issues/48)) ([be2be58](https://github.com/unfunco/terraform-aws-oidc-github/commit/be2be58ee1099200738ef947082607056a16ee73))
* Bump aws-actions/configure-aws-credentials from 2 to 4 ([#50](https://github.com/unfunco/terraform-aws-oidc-github/issues/50)) ([0f5075d](https://github.com/unfunco/terraform-aws-oidc-github/commit/0f5075dd79665395e8cc0f82432c8f0e03f9d34d))
* bump github/codeql-action from 2 to 3 ([#49](https://github.com/unfunco/terraform-aws-oidc-github/issues/49)) ([6cbdace](https://github.com/unfunco/terraform-aws-oidc-github/commit/6cbdaceb66b5ebc06ae3ba2660c58f78748f6301))
* Bump slackapi/slack-github-action from 1.18.0 to 1.25.0 ([#51](https://github.com/unfunco/terraform-aws-oidc-github/issues/51)) ([5093c20](https://github.com/unfunco/terraform-aws-oidc-github/commit/5093c2023bf0b148f2c4b769b43f6f3dae3d55ff))
* Bump slackapi/slack-github-action from 1.25.0 to 1.26.0 ([#53](https://github.com/unfunco/terraform-aws-oidc-github/issues/53)) ([5962e07](https://github.com/unfunco/terraform-aws-oidc-github/commit/5962e07265407e8c70c95dd20a917ff1b12aa712))
* Remove known thumbprints ([#52](https://github.com/unfunco/terraform-aws-oidc-github/issues/52)) ([c0b2178](https://github.com/unfunco/terraform-aws-oidc-github/commit/c0b2178bc74e49dcc9c2330651f0e866f25b762c))
* Set the first automated release version ([#44](https://github.com/unfunco/terraform-aws-oidc-github/issues/44)) ([cc3ded5](https://github.com/unfunco/terraform-aws-oidc-github/commit/cc3ded5d0b5bb0cd615ac8202b3d99bbc50735d2))
* Set the previous version in the manifest ([#46](https://github.com/unfunco/terraform-aws-oidc-github/issues/46)) ([cb4b7c9](https://github.com/unfunco/terraform-aws-oidc-github/commit/cb4b7c9ab3bd00ab35541e23417e145c62082802))

## [1.7.1] – 2023-10-29

- Condition the OIDC provider ARN output ([b570d79](https://github.com/unfunco/terraform-aws-oidc-github/commit/b570d7995efa9b542d5cdbe9ae30dea29f23cfcc))

## [1.7.0] – 2023-10-26

- Add the OIDC provider ARN as an output ([11d98e3](https://github.com/unfunco/terraform-aws-oidc-github/commit/11d98e3dea7ca8e41be157d21fe4769c31fe7570))

## [1.6.0] – 2023-09-07

- Allow additional audiences to be specified ([d5f4644](https://github.com/unfunco/terraform-aws-oidc-github/commit/d5f46444ed4018b88d0204df037ac3b4dbca7a03))
- Add IAM role name to outputs ([2ef5c27](https://github.com/unfunco/terraform-aws-oidc-github/commit/2ef5c27980657505c0e00d8665e57fa5c885785b))

## [1.5.2] – 2023-06-29

- Discard the order of thumbprints ([5fae63a](https://github.com/unfunco/terraform-aws-oidc-github/commit/5fae63a23c87a59839453df6b04956babd32734e))

## [1.5.1] – 2023-06-28

- Prevent duplication of thumbprints ([35f725d](https://github.com/unfunco/terraform-aws-oidc-github/commit/35f725d4448b6838afd5b9e95ca793f7d4988665))
- Reduce the number of allowed additional thumbprints ([b89bb89](https://github.com/unfunco/terraform-aws-oidc-github/commit/b89bb89c36746f5dead86b82490ace173adda354))

## [1.5.0] – 2023-06-04

- Add support for organisations using GitHub Enterprise Cloud ([c1d6cc13](https://github.com/unfunco/terraform-aws-oidc-github/commit/c1d6cc13cfd7668784dec11e96f23061b346eae0))

## [1.4.0] – 2023-06-01

- Update the AWS provider version constraint to allow v5 ([4f6b152](https://github.com/unfunco/terraform-aws-oidc-github/commit/4f6b152447a4caff21204d3e00417ca96b8de154))

## [1.3.1] – 2023-03-27

- Ensure the additional_thumbprints variable allows null values ([750f0f6](https://github.com/unfunco/terraform-aws-oidc-github/commit/750f0f6b0296057ff9910cebd2ac2f577b0cdb90))

## [1.3.0] – 2023-03-21

- Added a variable to allow additional thumbprints to be specified ([f3ca314](https://github.com/unfunco/terraform-aws-oidc-github/commit/f3ca3143052eecf59fc08be8dbb288855764414f))

## [1.2.1] – 2023-02-18

- Added an explicit audience claim ([2dc99c4](https://github.com/unfunco/terraform-aws-oidc-github/commit/2dc99c4d7dcf925768948e00555695f229fed150))

## [1.2.0] – 2023-01-31

- Add support for wildcards in GitHub repository names ([b55b33f](https://github.com/unfunco/terraform-aws-oidc-github/commit/b55b33f12c2bd4255d0c2ae6a8a7f4cfa2fdaca9))

## [1.1.1] – 2022-11-15

- Support TLS provider versions >= 3 ([710428f](https://github.com/unfunco/terraform-aws-oidc-github/commit/710428f4b6ef4e7a5b505f46a053a62c15d3e01c))

## [1.1.0] – 2022-10-12

- Use a data source to obtain the GitHub thumbprint ([07c4be3](https://github.com/unfunco/terraform-aws-oidc-github/commit/07c4be3c5569461f00209346dca61d5901ea789f))

## [1.0.0] – 2022-10-12

- Fixed an issue that could cause duplicate client IDs ([1e2a908](https://github.com/unfunco/terraform-aws-oidc-github/commit/1e2a9080933a96aaff681082e0878a38cfe787e2))

## [0.8.0] – 2022-05-17

- Allow the attachment of inline IAM policies to the OIDC role ([6445a81](https://github.com/unfunco/terraform-aws-oidc-github/commit/6445a81934184714cffa032370239a3e1be07380))
- Fixed a null reference issue when enabled is set to false ([7f2bb73](https://github.com/unfunco/terraform-aws-oidc-github/commit/7f2bb7351dbd62d34e4fa441d1949c16684d3c58))

## [0.7.0] – 2022-05-03

- Allow specific branch filtering ([3af1335](https://github.com/unfunco/terraform-aws-oidc-github/commit/3af133545de56f85a40dc76aacbd79f2b9fc8b26))
- Fixed a regression that prevents a wildcard being used for repositories ([80ae598](https://github.com/unfunco/terraform-aws-oidc-github/commit/80ae5981070a173d00c885b7444de23d94e56bef))

## [0.6.1] – 2022-04-28

- Fixed an issue with inconsistent types in locals ([ddaa1ce](https://github.com/unfunco/terraform-aws-oidc-github/commit/ddaa1cee0ede5475c3ba30238875de7e7eddef4c))

## [0.6.0] – 2022-04-09

- Allow multiple organizations to be used in a single module ([d32aa74](https://github.com/unfunco/terraform-aws-oidc-github/commit/d32aa74a2783db98196c7d6b2670dcf3bf6ae2fe))
- Remove unused IAM policy variables ([c26a176](https://github.com/unfunco/terraform-aws-oidc-github/commit/c26a17633c7823b5bdf0f208bea1dd2f48370880))

## [0.5.0] – 2022-03-10

- Allow the use of existing GitHub OIDC providers ([6b40b05](https://github.com/unfunco/terraform-aws-oidc-github/commit/6b40b05b203b9ed7f1d119f4613937446b8c3bcb))

## [0.4.1] – 2022-03-02

- Fixed an incorrect type for the tags variable ([8965bec](https://github.com/unfunco/terraform-aws-oidc-github/commit/8965becb055ca8f117b5d02bfc864133a35444e2))
- Send a Slack notification when the verification workflow fails ([91c1913](https://github.com/unfunco/terraform-aws-oidc-github/commit/91c1913a7e8eed9f9ef892e8d2973ada027e091f))

## [0.4.0] – 2022-01-13

- Allow the thumbprint to be specified as a variable ([4481aef](https://github.com/unfunco/terraform-aws-oidc-github/commit/4481aef9ccb2f4525f84b62f1e4eda4b6d49876f))
- Updated the default thumbprint ([af68a05](https://github.com/unfunco/terraform-aws-oidc-github/commit/af68a05de5b12d39d8f1120085ca4596bbcefa97))

## [0.3.0] – 2021-12-22

- Add an option to attach the AdministratorAccess policy ([ce3fb8e](https://github.com/unfunco/terraform-aws-oidc-github/commit/ce3fb8ee309833d3c2095d5557355fbff9416888))

## [0.2.0] – 2021-12-22

- Add support for multiple repositories ([0216f7b](https://github.com/unfunco/terraform-aws-oidc-github/commit/0216f7b5ffe409943efc9afd22e59278e5105ec9))
- Fix incorrectly referenced output in the complete example ([a78a0ed](https://github.com/unfunco/terraform-aws-oidc-github/commit/a78a0ed898f6429ac20c9fac4c7c85b3ca2d9310))

## [0.1.2] – 2021-12-10

- Add missing permission in the usage instructions ([1252f5d](https://github.com/unfunco/terraform-aws-oidc-github/commit/1252f5d0c4532e91a0f99c725c23202b1b278969))
- Remove unused IAM policy document ([24afc52](https://github.com/unfunco/terraform-aws-oidc-github/commit/24afc5258424f9e525624b3327c26d7db792b406))

## [0.1.1] – 2021-12-10

- Fix default variable value for the IAM role permission boundary ([c96042e](https://github.com/unfunco/terraform-aws-oidc-github/commit/c96042ed07daa1537b11ad89ba2d0b74b6ac887e))
- Format Terraform sources ([d447edb](https://github.com/unfunco/terraform-aws-oidc-github/commit/d447edbab405dba2db1cdb0b1ae375aa7317ff09))

## [0.1.0] – 2021-12-10

- Initial release

[0.1.0]: https://github.com/unfunco/terraform-aws-oidc-github/releases/tag/v0.1.0
[0.1.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.0...v0.1.1
[0.1.2]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.1...v0.1.2
[0.2.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.1.2...v0.2.0
[0.3.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.3.0...v0.4.0
[0.4.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.4.0...v0.4.1
[0.5.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.4.1...v0.5.0
[0.6.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.5.0...v0.6.0
[0.6.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.6.0...v0.6.1
[0.7.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.6.1...v0.7.0
[0.8.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.7.0...v0.8.0
[1.0.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v0.8.0...v1.0.0
[1.1.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.0.0...v1.1.0
[1.1.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.1.0...v1.1.1
[1.2.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.1.1...v1.2.0
[1.2.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.2.0...v1.2.1
[1.3.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.2.1...v1.3.0
[1.3.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.3.0...v1.3.1
[1.4.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.3.1...v1.4.0
[1.5.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.4.0...v1.5.0
[1.5.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.5.0...v1.5.1
[1.5.2]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.5.1...v1.5.2
[1.6.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.5.2...v1.6.0
[1.7.0]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.6.0...v1.7.0
[1.7.1]: https://github.com/unfunco/terraform-aws-oidc-github/compare/v1.7.0...v1.7.1
[semantic versioning]: https://semver.org
