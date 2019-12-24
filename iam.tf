data "aws_iam_role" "org_access_role" {
  name = "${var.role_name}"
}

data "aws_iam_policy" "organizations_full_access" {
  arn = "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"
}

resource "aws_iam_role_policy_attachment" "add-org-full-access-attach" {
  role       = "${data.aws_iam_role.org_access_role.id}"
  policy_arn = "${data.aws_iam_policy.organizations_full_access.arn}"
}

data "aws_iam_policy_document" "okta_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["${module.account-baseline.okta_provider_arn}"]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "tlz_organization_admin" {
  name               = "tlz_organization_admin"
  description        = "This group has full access (provisioning/removal/modify) on all AWS services within the root account including IAM user administration"
  assume_role_policy = "${data.aws_iam_policy_document.okta_assume_role_policy.json}"
}

module "tlz_organization_admin_okta" {
  source           = "app.terraform.io/blizzard-cloud/tlz_group_membership_manager/okta"
  aws_account_id   = "${var.account_id}"
  okta_hostname    = "${var.okta_provider_domain}"
  tlz_account_type = "${var.account_type}"
  user_emails      = ["${var.users_tlz_organization_admin}"]
  api_token        = "${var.okta_token}"
  role_name        = "tlz_organization_admin"
}

data "aws_iam_policy_document" "orgadmin_denyset" {
  statement {
    effect    = "Deny"
    resources = ["*"]

    actions = [
      "organizations:AttachPolicy",
      "organizations:CreatePolicy",
      "organizations:DeletePolicy",
      "organizations:DetachPolicy",
      "organizations:UpdatePolicy",
      "organizations:DisableAWSServiceAccess",
      "organizations:DisablePolicyType",
      "organizations:EnableAWSServiceAccess",
      "organizations:EnableAllFeatures",
    ]
  }
}

# Admin role policy
resource "aws_iam_policy" "orgadmin_denyset_policy" {
  name        = "tlz_orgadmin_denyset"
  description = "Deny set for orgadmin role"
  policy      = "${data.aws_iam_policy_document.orgadmin_denyset.json}"
}

resource "aws_iam_role_policy_attachment" "org_full_access_attach" {
  role       = "${aws_iam_role.tlz_organization_admin.name}"
  policy_arn = "${data.aws_iam_policy.organizations_full_access.arn}"
}

resource "aws_iam_role_policy_attachment" "orgadmin_denyset_attach" {
  role       = "${aws_iam_role.tlz_organization_admin.name}"
  policy_arn = "${aws_iam_policy.orgadmin_denyset_policy.arn}"
}


module "tlz_billing_admin" {
  source            = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-tlz_billing_admin"
  version           = "~> 0.1.0"
  okta_provider_arn = "${module.account-baseline.okta_provider_arn}"
}


module "tlz_billing_admin_okta" {
  source           = "app.terraform.io/blizzard-cloud/tlz_group_membership_manager/okta"
  aws_account_id   = "${var.account_id}"
  okta_hostname    = "${var.okta_provider_domain}"
  tlz_account_type = "${var.account_type}"
  user_emails      = ["${var.users_tlz_billing_admin}"]
  api_token        = "${var.okta_token}"
  role_name        = "tlz_billing_admin"
}

#TODO: Cirrus-630 needs to hook in with okta to provide actual access. Both SecOps and IR roles
module "tlz_security_ir" {
  source                  = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-policy-securityir"
  version                 = "~> 0.1.0"
  okta_provider_arn       = "${module.account-baseline.okta_provider_arn}"
}