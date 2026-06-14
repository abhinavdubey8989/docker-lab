
# Aim
This readme lists down steps for setting up the node from where we would run Ansible & Terraform commands


## Steps for setting up the cordinator EC2 node
- Create an EC2 machine (t2.medium : 4GB memory, 2 vCPU is fine)

- On this machine, install : `ansible`, `terraform`, `aws-cli`
    - The scripts to install these are present in `scripts` dir
    - These scripts assume underlying OS version is ubuntu 24.04 LTS

- Create IAM user & add this user to appropriate group
    - Since the current EC2 (from where ansible & TF need to run, referred to as `workstation-node`), will add/update the AWS resources, it needs to have the correct permissions
    - For giving this EC2 permission, goto `IAM` > `IAM users` > `create user`
    - Give the user-name, then select `Add user to group` & select the appropriate group
    - Note : there are other options too which can be used (eg: `Copy permission from existsing user`, `Attach policy directly`). Here, we assume, there exists a group with appropriate permissions & we are directly adding current user to this group
    - (Optional) Give proper tag to this user
    - Then finally create user & it will show in list of users
    - Select the newly created user (or an existing user) & goto `Security credentials` tab
    - Scroll to `Access keys` section & click `Create access key`, choose use-case as `CLI`
    - Now copy the `Access key` & `Secret access key` to secure place (DO NOT SHARE THIS WITH ANYONE)

- Do aws configure

```
(run CLI : `aws configure`)

AWS Access Key ID [None]: Access key from previous step
AWS Secret Access Key [None]: Secret access key from previous step
Default region name [None]: ap-south-1
Default output format [None]: json
```

- This EC2 can now be used to add/update/delete AWS resources using Ansible & Terraform


## Steps to create IAM user-groups
- Goto `IAM` > `IAM user groups` > `create group`
- Add group name
- Then you can either select permissions from `Attach permissions policies` or add inline policy permission
- Click `create user group`