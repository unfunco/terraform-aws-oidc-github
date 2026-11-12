# Multiple AWS accounts

The following example creates the GitHub OIDC provider once, in a managing
(identity) account, and reuses it to deploy into a member account.

An IAM OIDC provider can only be trusted by roles in the same AWS account, so
roles in member accounts can't reference the provider in the managing account
directly. Instead, GitHub Actions uses role chaining:

1. GitHub Actions assumes the `GitHubActions` role in the managing account
   using OIDC. This role's only permission is `sts:AssumeRole` on the member
   account roles.
2. GitHub Actions then assumes the `GitHubActionsDeploy` role in the member
   account. This role trusts the `GitHubActions` role, not the OIDC provider.

Add a role and an `aws` provider alias for each additional member account, and
list every member role in the managing role's inline policy.

```yaml
permissions:
  id-token: write

steps:
  - uses: aws-actions/configure-aws-credentials@v5
    with:
      aws-region: eu-west-1
      role-to-assume: arn:aws:iam::111111111111:role/GitHubActions

  - uses: aws-actions/configure-aws-credentials@v5
    with:
      aws-region: eu-west-1
      role-chaining: true
      role-to-assume: arn:aws:iam::222222222222:role/GitHubActionsDeploy
```

If you'd rather have no cross-account trust, create an OIDC provider in each
account by passing a provider alias to the module, for example
`providers = { aws = aws.workload }`.
