cd ./Terraform
echo "
############################################
        ___        ____  ____   _    _   ___
||  || ||    ||   ||    ||  || ||\  /|| ||
||  || | ==  ||   ||    ||  || || \/ || | ==
||/\|| ||__  ||__ ||___ ||__|| ||    || ||__
                    
############################################
"
echo "This script will either"
echo "1- run terraform scripts which is integrated with ansible scripts to:"
echo "   - Create ECR repository with names app and db"
echo "   - Create EC2 instance configured with Jenkins master and have plugins installed with default username and password (admin)"
echo "   - Create EkS cluster with 2 nodes"
echo "2- Destroy the created infrastructure"
echo "------------------------------------------------------------------------------------------------------------------------------"
read -p "Enter either 1 ->(Create) or 2 ->(Destroy):" desicion
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
case $desicion in
        1)
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
                ;;
        2)
                echo "PLEASE ENTER YOUR AWS CREDENTIALS to destroy the infrastructure"
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                read -p "Enter your AWS access key ID: " aws_access_key_id
                read -p "Enter your AWS secret access key: " aws_secret_access_key
                export AWS_ACCESS_KEY_ID=$aws_access_key_id
                export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
                export AWS_REGION="us-east-2"
                terraform destroy --auto-approve
                ;;
        *)
                echo "PLEASE ENTER A VALID OPTION"
esac