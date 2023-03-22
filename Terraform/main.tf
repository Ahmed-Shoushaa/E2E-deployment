module "ECR" {
    source= "./ECR"
}

module "jenkins-ec2" {
    source= "./jenkins-ec2"
}

module "EKS" {
    source= "./EKS"
}

output "Jenkins server ip"{
    value = module.jenkins-ec2.jenkins-server-ip
}

output "ecr-app-repository-url"{
    value = module.ECR.app-repo-url
}

output "ecr-db-repository-url"{
    value = module.ECR.db-repo-url
}  
