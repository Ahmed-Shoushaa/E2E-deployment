pipeline {
    agent any
    stages {
        stage('Clone repository') { 
            steps { 
                script{
                checkout scm
                }
            }
        }
        stage('Build app image') { 
            steps { 
                script{
                    dir('Dockerization'){
                        app = docker.build("app", "./app")
                    }
                }
            }
        }
        stage('Build MYSQL image') { 
            steps { 
                script{
                    dir('Dockerization'){
                        db = docker.build("db","./db")
                    }
                }
            }
        }
        stage('Push APP image to ECR') {
            steps {
                script{
                    docker.withRegistry('https://< ECR REPO URL >', 'ecr:us-east-1:aws-credentials') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("latest")
                    }
                }
            }
        }
        stage('Push DB image to ECR') {
            steps {
                script{
                    docker.withRegistry('https://< ECR REPO URL >', 'ecr:us-east-1:aws-credentials') {
                    db.push("${env.BUILD_NUMBER}")
                    db.push("latest")
                    }
                }
            }
        }
        stage("Connect kubectl to aws cluster and deploy") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                sh 'aws eks update-kubeconfig --name cluster --region eu-south-1'
                    dir('K8s-Files'){
                        sh "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml"
                        sh "sleep 30"
                        sh "kubectl apply -f ."
                    }
                }
            }
        }


       
        
    }
}
