# terraform-azure-vm
This code creates a vm and deploys on azure
## How to run 
1 - install terraform

2 - install azure cli

3 - create or use an azure account

4 - terraform init

5 - terraform plan 

6 - terraform apply

if you didnt get any error terraform will create this resources virtual network,resource group, subnet, network interface and virtual machine.
To connect via ssh, you will need a public ip associated with the network interface and create a Network security group to create a role to open 22 port,
after that you need authentication, you can create in azure portal a sshkey, you will use that key to connect in the vm with this command
```sh 
ssh-copy-id -i ~/.ssh/key.pem -p 22 vmname@ip
```
*azure creates a pem key, like key.pem not the usual rsa*
