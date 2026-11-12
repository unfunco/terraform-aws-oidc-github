// The default provider targets the managing (identity) account, which holds
// the only GitHub OIDC provider. Member accounts are reached by assuming a
// role from the managing account.
provider "aws" {}

provider "aws" {
  alias = "workload"

  assume_role {
    role_arn = format("arn:aws:iam::%s:role/%s", var.workload_account_id, var.workload_admin_role_name)
  }
}

data "aws_iam_policy_document" "assume_workload_role" {
  statement {
    actions   = ["sts:AssumeRole", "sts:TagSession"]
    effect    = "Allow"
    resources = [aws_iam_role.workload.arn]
  }
}

// GitHub Actions authenticates against this role first using OIDC. Its only
// permission is to assume the deployment role in the member account.
module "oidc_github" {
  source = "../.."

  github_subjects = var.github_subjects
  iam_role_inline_policies = {
    "assume-workload-role" = data.aws_iam_policy_document.assume_workload_role.json
  }
  iam_role_name = "GitHubActions"
}

data "aws_iam_policy_document" "workload_trust" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    effect  = "Allow"

    principals {
      identifiers = [module.oidc_github.iam_role_arn]
      type        = "AWS"
    }
  }
}

// The member account has no OIDC provider, its deployment role trusts the
// role in the managing account instead.
resource "aws_iam_role" "workload" {
  provider = aws.workload

  assume_role_policy = data.aws_iam_policy_document.workload_trust.json
  description        = "Assumed by GitHub Actions through the managing account."
  name               = "GitHubActionsDeploy"
}

resource "aws_iam_role_policy_attachment" "workload_read_only" {
  provider = aws.workload

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.workload.name
}
