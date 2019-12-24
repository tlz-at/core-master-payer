##############
#    SCPs    #
##############

# SCPs are consolidated as there is a limitation of 5 SCPs in the master_payer
resource "aws_organizations_policy" "required" {
  name = "tlz_required"

  content = <<CONTENT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StandardPolicies",
            "Effect": "Deny",
            "Action": [
                "cloudtrail:DeleteTrail",
                "cloudtrail:UpdateTrail",
                "cloudtrail:StopLogging",
                "guardduty:ArchiveFindings",
                "guardduty:DeclineInvitations",
                "guardduty:DeleteDetector",
                "guardduty:DeleteIPSet",
                "guardduty:DeleteInvitations",
                "guardduty:DeleteMembers",
                "guardduty:DeleteThreatIntelSet",
                "guardduty:DisassociateFromMasterAccount",
                "guardduty:DisassociateMembers",
                "guardduty:StopMonitoringMembers",
                "organizations:LeaveOrganization"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
CONTENT
}

resource "aws_organizations_policy" "additional_security" {
  name = "tlz_additional_security"

  content = <<CONTENT
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AdditionalSecurity",
			"Effect": "Deny",
			"Action": [
				"s3:PutBucketAcl",
				"s3:PutObjectAcl",
				"s3:PutObjectVersionAcl",
				"ec2:AcceptVpcPeeringConnection",
				"ec2:AssignIpv6Addresses",
				"ec2:AttachClassicLinkVpc",
				"ec2:CreateVpcPeeringConnection",
				"ec2:DeleteFlowLogs",
				"ec2:EnableVpcClassicLink",
				"ec2:EnableVpcClassicLinkDnsSupport",
				"config:DeleteConfigRule",
				"config:DeleteConfigurationRecorder",
				"config:DeleteDeliveryChannel",
				"config:StopConfigurationRecorder",
				"cloudwatch:DeleteAlarms",
				"cloudwatch:DeleteDashboards",
				"cloudwatch:DisableAlarmActions",
				"cloudwatch:PutDashboard",
				"cloudwatch:PutMetricAlarm",
				"cloudwatch:SetAlarmState",
				"logs:DeleteLogGroup",
				"logs:DeleteLogStream"
			],
			"Resource": [
				"*"
			]
		}
	]
}
CONTENT
}

resource "aws_organizations_policy" "unapproved_services" {
  name = "tlz_unapproved_services"

  content = <<CONTENT
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "UnapprovedServices",
			"Effect": "Deny",
			"Action": [
				"lightsail:*",
				"gamelift:*",
				"devicefarm:*",
				"elastictranscoder:*",
				"mechanicalturk:*",
				"chime:*",
				"workmail:*",
				"media:*",
				"workdocs:*"
			],
			"Resource": [
				"*"
			]
		}
	]
}
CONTENT
}

resource "aws_organizations_policy" "HIPAA_eligible_services" {
  name = "tlz_HIPAA_eligible_services"

  content = <<CONTENT
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "HIPAAEligibleServices",
			"Effect": "Allow",
			"Action": [
				"acm:*",
				"acm-pca:*",
				"amplify:*",
				"apigateway:*",
				"appstream:*",
				"appsync:*",
				"athena:*",
				"autoscaling:*",
				"autoscaling-plans:*",
				"backup:*",
				"batch:*",
				"chime:*",
				"cloudformation:*",
				"cloudfront:*",
				"cloudhsm:*",
				"cloudtrail:*",
				"cloudwatch:*",
				"codebuild:*",
				"codecommit:*",
				"codedeploy:*",
				"codepipeline:*",
				"cognito-identity:*",
				"cognito-idp:*",
				"cognito-sync:*",
				"comprehendmedical:*",
				"config:*",
				"connect:*",
				"datasync:*",
				"directconnect:*",
				"dms:*",
				"docdb:*",
				"ds:*",
				"dynamodb:*",
				"ec2:*",
				"ecr:*",
				"ecs:*",
				"elasticfilesystem:*",
				"eks:*",
				"elasticache:*",
				"elasticbeanstalk:*",
				"elb:*",
				"elasticmapreduce:*",
				"es:*",
				"firehose:*",
				"fms:*",
				"forecast:*",
				"freertos:*",
				"fsx:*",
				"glacier:*",
				"globalaccelerator:*",
				"glue:*",
				"greengrass:*",
				"guardduty:*",
				"importexport:*",
				"inspector:*",
				"iot:*",
				"kafka:*",
				"kinesis:*",
				"kinesisanalytics:*",
				"kinesisvideo:*",
				"kms:*",
				"lambda:*",
				"macie:*",
				"mediaconnect:*",
				"mediaconvert:*",
				"medialive:*",
				"mq:*",
				"neptune:*",
				"opsworks:*",
				"organizations:*",
				"personalize:*",
				"personalize-events:*",
				"personalize-runtime:*",
				"polly:*",
				"quicksight:*",
				"rds:*",
				"rds-data:*",
				"redshift:*",
				"rekognition:*",
				"robomaker:*",
				"route53:*",
				"route53domains:*",
				"route53resolver:*",
				"sagemaker:*",
				"sagemaker-runtime:*",
				"secretsmanager:*",
				"securityhub:*",
				"serverlessrepo:*",
				"servicecatalog:*",
				"ses:*",
				"shield:*",
				"sms:*",
				"snowball:*",
				"sns:*",
				"sqs:*",
				"ssm:*",
				"stepfunctions:*",
				"storagegateway:*",
				"swf:*",
				"transcribe:*",
				"transfer:*",
				"translate:*",
				"waf:*",
				"waf-regional:*",
				"workdocs:*",
				"worklink:*",
				"workspaces:*",
				"xray:*",
				"s3:*",
				"iam:*",
				"sts:*"
			],
			"Resource": [
				"*"
			]
		}
	]
}
CONTENT
}

data "aws_organizations_organization" "org" {
}

resource "aws_organizations_policy_attachment" "required" {
  policy_id = "${aws_organizations_policy.required.id}"
  target_id = "${data.aws_organizations_organization.org.roots.0.id}"
}

resource "aws_organizations_policy_attachment" "additional_security" {
  policy_id = "${aws_organizations_policy.additional_security.id}"
  target_id = "${data.aws_organizations_organization.org.roots.0.id}"
}

resource "aws_organizations_policy_attachment" "unapproved_services" {
  policy_id = "${aws_organizations_policy.unapproved_services.id}"
  target_id = "${data.aws_organizations_organization.org.roots.0.id}"
}

/* This is where we would apply the HIPAA SCP to the HIPAA OUs, leaving it out for now as the OU strategy/creation will be a separate card
resource "aws_organizations_policy_attachment" "HIPAA_eligible_services" {
  policy_id = "${aws_organizations_policy.HIPAA_eligible_services.id}"
  target_id = "${data.aws_organizations_organization.org.roots.0.id}"
}
*/