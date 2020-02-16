
# Terraform/Ansible Demo

## Overview
This demo illustrates using Terraform and Ansible together to stand up a simple infrastructure.

In particular we will:
- Stand up an EC2 instance in AWS from scratch, including all the networking needed to make it accessible from the internet
- Installing the NginX web server on the instance
- Viewing the default NginX welcome page in a browser

We'll use Terraform for standing up the infrastructure, and Ansible for installing NginX.

## Prerequisites
- Ansible ([instructions](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))
- Terraform ([instructions](https://learn.hashicorp.com/terraform/getting-started/install.html))
- The AWS CLI ([instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html))
- An AWS account ([instructions](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/))
- An AWS keypair with admin perms in `~/.aws/credentials` ([instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html))
- A SSH keypair in `~/.ssh/id_rsa` ([instructions](https://confluence.atlassian.com/bitbucketserver/creating-ssh-keys-776639788.html))

## Note about AWS costs
Standing up this stack may incur charges on your AWS account. Be sure to tear it down when you're done, so it doesn't add up.

## Stand up the infrastructure using Terraform
This will stand up the following resources in AWS
- A VPC
- An EC2 Key Pair
- An Internet Gateway
- A public subnet
- A route table for the subnet
- Three security groups
- An EC2 instance (running Ubuntu)

```
> cd terraform
> terraform init
> terraform plan
> terraform apply
```

## Note that this will create a Terraform state file
Normally we would configure Terraform to save the state file in S3 so others may access it, but for demo purposes we'll save it locally.
```
> cat terraform.tfstate
```

## View the instance in the AWS CLI
```
> aws ec2 describe-instances
```

## Grab the public IP of the instance
...so we can use it later
```
> ip=`terraform output | grep ip | awk '{ print $3 }'`
```

## Confirm you can SSH to the instance
We'll need SSH to work, because that's how Ansible will connect to install the web server
```
> ssh ubuntu@$ip
```

## Install NginX using Ansible
```
> cd ../ansible
> ansible-playbook -u ubuntu -i "$ip," main.yml
```

## Browse
You can curl on the command line, or paste the IP in your browser
```
> curl $ip
```

## Teardown
```
> cd ../terraform
> terraform destroy

# Optional: remove the local terraform state
> rm -r .terraform terraform.tfstate
```


