
# Terraform/Ansible Demo

## Stand up an EC2 instance using Terraform
```
terraform init
terraform plan
terraform apply
```

## Install nginx on it using Ansible
```
ip=`terraform output | grep ip | awk '{ print $3 }'`
ansible-playbook -u ubuntu -i "$ip," main.yml
