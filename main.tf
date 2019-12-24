locals {
  baseline_version = "v0.0.1"
}

# Connect to the core-logging account to get S3 buckets
data "terraform_remote_state" "logging" {
  backend = "remote"

  config {
    organization = "${var.tfe_org_name}"
    hostname     = "${var.tfe_host_name}"

    workspaces {
      name = "${var.tfe_core_logging_workspace_name}"
    }
  }
}

data "aws_organizations_organization" "master" {}

data "template_file" "aws_config" {
  template = "${file("${path.module}/templates/local_exec/aws_config")}"

  vars = {
    region_primary = "${var.region_primary}"
    role_arn       = "${local.assume_role_arn}"
  }
}

resource "local_file" "aws_config" {
  content  = "${data.template_file.aws_config.rendered}"
  filename = "/root/.aws/config"
}

# There is no resource to enable RAM in terraform. Need to do it through a
# local script. This will set up the most recent version of aws cli and all
# aws permissions required to run it.
resource "null_resource" "ram_sharing" {
  provisioner "local-exec" {
    command = "templates/local_exec/enable_ram.sh"
  }

  # ram sharing enabled at org level so re-run if org rebuilt
  triggers = {
    org_id = "${data.aws_organizations_organization.master.id}"
  }

  depends_on = ["local_file.aws_config"]
}

#Account baseline
module "account-baseline" {
  source                 = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws"
  version                = "~> 0.1.0"
  account_name           = "core_master_payer"
  account_type           = "${var.account_type}"
  account_id             = "${var.account_id}"
  okta_provider_domain   = "${var.okta_provider_domain}"
  okta_app_id            = "${var.okta_app_id}"
  region                 = "${var.region_primary}"
  region_secondary       = "${var.region_secondary}"
  role_name              = "${var.role_name}"
  config_logs_bucket     = "${data.terraform_remote_state.logging.s3_config_logs_bucket_name}"
  tfe_host_name          = "${var.tfe_host_name}"
  tfe_org_name           = "${var.tfe_org_name}"
  tfe_avm_workspace_name = "${var.tfe_avm_workspace_name}"
  okta_environment       = "${substr(var.account_type, 0, 3)}"
}
