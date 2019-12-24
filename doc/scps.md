# Service Control Policies
The Master AWS Account is the root of the Organization and requires enhanced logging.  All child AWS accounts are either created or joined to the Organization under the Master AWS Account.  Organization administrators have the ability to manage AWS Account OU placement and Service Control Policies (SCP) for all accounts within the Organization. This includes but is not limited to add/remove accounts within the Organization, move accounts to different Organizational Unites (OU's), apply account-level Service Control Policies (SCP), etc.  Administrative access in the Master AWS Account grants the ability to assume an IAM Role, which grants access into child AWS accounts. 

Service control policies must be version controlled and follow an InfoSec approved change management process

** NOTE: The root user in an account can always do the following:**

1. Changing the root user's password
1. Creating, updating, or deleting root access keys
1. Enabling or disabling multi-factor authentication on the root user
1. Creating, updating, or deleting x.509 keys for the root user


The following security control policies must be configured and applied at the root level of the organization and require InfoSec approval for modification or exemption: 

- Password policy, all IAM accounts in AWS are considered privileged accounts.
- Enable detailed billing per account.
- Cloudtrail logging enabled and prevent the deletion, update or stopping of CloudTrail
- Enforce MFA for IAM users 
- Prevent the modification of the account contacts & settings via the Billing Portal and My Account Page
- Prevent the AWS account from leaving the organization
- Prevent the use of consumer features (e.g Alexa for Business, WorkMail, Workspaces)

### Use Case

* Cloudtrail logging enabled and prevent the deletion, update or stopping of CloudTrail
* Prevent Turning off GuardDuty
* Prevent turning off AWS Config
* Prevent the AWS account from leaving the organization
* Prevent the use of consumer features (e.g Alexa for Business, WorkMail, Workspaces)
* Enforce Password Policies
* Password policy, all IAM accounts in AWS are considered privileged accounts.
* Enable detailed billing per account.
* Enforce MFA for IAM users 
* Prevent the modification of the account contacts & settings via the * Billing Portal and My Account Page

## TLZ Standards:

### Required SCP

The following SCP includes:

* EnforceCloudTrail 
* EnforceGuardDuty
* Prevent AWS Account from leaving the organization

```json
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

```
### Additional Security

The following SCP's are recommended by AWS, exact or variant to those outlined below.  AWS recommends the organizations' review and strongly consider implementing similar controls.  The ultimate decision is up to the organization, based on their security requirements.

* Prevent Risky S3 
* Prevent Risky EC2
* Prevent Users from Disabling AWS Config or Changing Its Rules
* Prevent Users from Disabling Amazon CloudWatch or Altering Its Configuration
* Prevent Users from Deleting Amazon VPC Flow Logs

```json
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
```

### Prevent Unapproved Services

Blacklist services that are not approved.  This list can be ammended as new services become available. 

```json
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
```



### Allow HIPAA Eligible Services

The following services are HIPAA eligible, accounts with HIPAA requirements will be restricted to the services listed below. 

The source of truth for this list is https://aws.amazon.com/compliance/hipaa-eligible-services-reference/. The list below matches the Aug 22, 2019 version of the page and if there are changes to the list on the page above then scp.md and scps.tf need to be updated to match the new list.

This SCP will be applied to specific HIPAA Organizational Units to enforce this policy on accounts with HIPAA requirements. If an account requires access to a service not listed here, it can either be added to the policy (with approval from infosec and privacy), or the account will need to be in another OU. It is not possible to exempt accounts from this whitelist if they are in the OU (AWS only allows 'Condition' statements for 'Deny' effects).

Also note that while this whitelist will override the inherited 'FullAWSAccess' policy, if the 'FullAWSAccess' policy is also directly attached at the same level as the whitelist then the whitelist becomes ineffective.

```json
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
```