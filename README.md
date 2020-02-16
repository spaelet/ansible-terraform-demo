
# Terraform/Ansible Demo

## Overview
This demo will walk you through standing up an EC2 instance in AWS from scratch (including all the networking needed to make it accessible from the internet), installing the NginX web server, and viewing the default welcome page in a browser.

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
This will stand up the following resources
- A VPC
- An Internet Gateway
- A public subnet
- A routing table for the subnet
- Three security groups
- An EC2 instance (running Ubuntu)

```
> cd terraform
> terraform init
> terraform plan
> terraform apply
```

## Note that this will create a terraform state file
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
```
> curl $ip
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Teardown
```
> terraform destroy
```

Optional: remove the local terraform state
```
> rm -r .terraform terraform.tfstate
```


