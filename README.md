# Terraform and Ansible - DevOps Challenge
This project uses **Terraform** to automate the creation and configuration of a reliable infraesctructure in Amazon Web Services. It also uses **Ansible** to configures the servers (EC2 instances) to host and run a nodejs [Chat application](https://kunal-chat-app.herokuapp.com).
## Project Requirements:
- An [AWS](https://aws.amazon.com/) account or IAM user with the necessary permissions to create the infraestructure mentioned in the **Terraform Tasks Section**.
- [AWS CLI](https://aws.amazon.com/es/cli/) tools configured with your AWS account or IAM user.
- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) tools installed (v0.15.3).
- [Ansible CLI](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu) tools installed (v2.9.21).
> **Note**: follow the links above to find install instructions of every required tool.

## Terraform Tasks:
- Create a VPC with 2 public subnets in different availabilty zones.
- Create an Internet Gateway and a Route Table for the VPC created.
- Create an Elastic Load Balancer for 2 Amazon EC2 running the chat app.
- Create a security group for the ELB for HTTP access.
- Creates 2 Amazon EC2 [t2.micro] instances based in an Ubuntu AMI. One in each public subnet.
- Create a security group for the EC2 instances for HTTP and SSH access.
- Create a SSH key to access the EC2 instances.
- Upload a shell script to install nodejs and npm in the EC2 instances.

## Ansible Tasks:
- Run the script to install nodejs and npm.
- Create a directory to download the chat app git repo.
- Download the [Chat App Repo](https://kunal-chat-app.herokuapp.com) from Github.
- Install node packages dependencies for the [Chat App Repo](https://kunal-chat-app.herokuapp.com).
- Install [PM2 package](https://pm2.keymetrics.io/) to manage node servers (EC2 instances).
- Start nodejs in node servers to host the Chat App.
- Configure PM2 to start node servers on every server startup.

# Project Technical Details

## Terraform Variables
| Variable | Description |
| ------ | ------ |
| aws_region | Name of the region where AWS infraestructure will be created. |
| aws_availability_zone_a | Name of the availabilty zone 'A'. |
| aws_availability_zone_b | Name of the availabilty zone 'B'. |
| application | Name of the node application to run. |
| ami | AMI id used to create the EC2 instances. |
| public-ssh-key-path-file | Local path to the public ssh key (.pub) file generated. This is passed with **-var** option when **'terraform apply', 'terraform plan' or 'terraform destroy'** commands are executed. |
| private-ssh-key-path-file | Local path to the private ssh key file generated. This is passed with **-var** option when **'terraform apply', 'terraform plan' or 'terraform destroy'** commands are executed. |

## Project Execution:
>Note: this instructions were tested in Ubuntu 18.04 but could work without major changes in some other linux distributions.
### Clone this [repository](https://github.com/ErickHernandez/Chat-App-using-Socket.io.git) in your preferred folder
```
git clone https://github.com/ErickHernandez/Chat-App-using-Socket.io.git ChatApp
cd ChatApp
```
### Generate a SSH key without passphrase
```
mkdir sshkeys && cd sshkeys
ssh-keygen -f nodekey
```
>***Note***: the console will ask you for a passphrase, just press enter twice.
### Build the required infraestructure with Terraform
```
cd ../terraform
terraform init
terraform apply -var "public-ssh-key-file=../sshkeys/nodekey.pub" -var="private-ssh-key-file=../sshkeys/nodekey"
type 'yes' (without single quoutes) and press enter
```
>***Note***: This process may take 10-15 minutes to create all the infraestructure requiered. When the process finish it will output the ec2 instances public ip's and the ELB dns to access the chat app (after finishing all the steps).
### Add the public ip's in Ansible host file
Copy the public ip's that the previous command printed as output and add them to the Ansible hosts file.
```
sudo nano /etc/ansible/hosts
```
>***Note***: Paste the public ip's one per line below the **[webservers]** tag, in case it doesn't exist then create it.
### Configure your SSH private key in Ansible
Set the generated ssh private key file path to the enviroment variable ANSIBLE_PRIVATE_KEY_FILE
```
export ANSIBLE_PRIVATE_KEY_FILE=<absolute-path-to-the-repo-cloned>/sshkeys/nodekey
```
### Run the Ansible Playbook
This will install nodejs, download the repo with the Chat App and install it's dependencies in the EC2 instances. It also will start the node server.
```
cd ../ansible
ansible-playbook ansible.yaml -u ubuntu
```
> ***Note***: If the EC2 instances are not created yet you could get an error like this:
> ***fatal: [3.238.139.180]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Host key verification failed.", "unreachable": true}***

> In case of that check that the ec2 instances are up and running and then re-run the ansible  command again.
### Test the Chat App website
1. Copy the ELB dns name that the **terraform apply** command printed in the output.
2. Open you web browser and paste the ELB dns name.
### Clean Up AWS Infraestructure Instructions
The following instructions will destroy all the infraescture created by terraform.
```
cd ../terraform
terraform destroy -var "public-ssh-key-file=../sshkeys/nodekey.pub" -var="private-ssh-key-file=../sshkeys/nodekey" 
type 'yes' (without single quoutes) and press enter
```