pipeline {
    agent any
    // environment {
    //     AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    //     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    //     AWS_DEFAULT_REGION = "us-east-1"
    // }
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


       
        
    }
}