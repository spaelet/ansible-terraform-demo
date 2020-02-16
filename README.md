
# Terraform/Ansible Demo

## Prerequisites
- Ansible
- Terraform
- The AWS CLI
- A basic network set up in AWS including
  - VPC
  - Public Subnet
  - Internet Gateway
  - Security groups
- An AWS keypair in `~/.aws/credentials`

## Stand up an EC2 instance using Terraform
```
> cd terraform
> terraform init
> terraform plan
> terraform apply
```

## View it in the AWS CLI
```
aws ec2 describe-instances
```

## Grab the public IP
```
> ip=`terraform output | grep ip | awk '{ print $3 }'`
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
