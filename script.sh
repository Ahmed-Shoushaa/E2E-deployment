cd ./Terraform
echo "
############################################
        ___        ____  ____   _    _   ___
||  || ||    ||   ||    ||  || ||\  /|| ||
||  || | ==  ||   ||    ||  || || \/ || | ==
||/\|| ||__  ||__ ||___ ||__|| ||    || ||__
                    
############################################
"
echo "This script will"
echo "run terraform scripts which is integrated with ansible scripts to:"
echo "1- Create ECR repository with names app and db"
echo "2- Create EC2 instance configured with Jenkins master and have plugins installed with default username and password (admin)"
echo "3- Create EkS cluster with 2 nodes"
echo "----------------------------------"
echo "Prerequisites: 1- terraform and ansible installed on your device"
echo "               2- AWS credentials to add infrastructure to your account"
echo "               3- AWS Key Pair "
echo "--------------------------------------------------------------------"
echo "PLEASE ENTER YOUR AWS CREDENTIALS"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
read -p "Enter your AWS access key ID: " aws_access_key_id
read -p "Enter your AWS secret access key: " aws_secret_access_key
terraform init
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_REGION="us-east-2"
terraform apply --auto-approve
