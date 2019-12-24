# AWS Resources deployed



## Master IAM Roles:


* tlz_organization_account_access_role - This role is created by bootstrap process (phase-1). This role is utilized by shared-services account
* tlz_organization_admin - This is a standard IAM role defined in Master Payer Account. This role has access at the top level of the organization tree to add and or remove Accounts from the AWS Organizations, manage OU structure and manage Service Control Policies(SCP's) and all other activities associated with managing an AWS Organization.

## Standard IAM Roles:
* tlz_security_operations - Security auditor role.


## Service IAM Roles
* tlz_redlock_read_only 
* tlz_awsconfig

## Non-Terraform Resources
* RAM is required to share many resources within the master payer's organization. There is no terraform resource to perform this task so it's done through a shell script running on the local terraform runner.
