# E2E Deployment of Flask application
Deploying a flask application with MYSQL database to EKS Cluster using multiple tool and going through multiple steps using
- AWS Services
- Terraform integrated with Ansible
- Docker
- Kubernetes
- Jenkins
## Repository Folders Contents
### Dockerization:
contains 
- the app source code and it's docker file
- database queries 
- docker compose to test the application locally
### K8s:
- deployment.yaml: create a deployment out of the flask app and add a load balancer service to it 
- statefulset.yaml: create a stateful set for the DBas it requires persistent storage for stateful workloads, and ordered, automated rolling updates
- ingress.yaml : an ingress object to map the traffic to the cluster services
### Terraform:
contains there main folders
- EKS: creates EKS cluster with 2 nodes
- EC2: creates an EC2 instance and integrates terraform with ansible to install Jenkins and skip initial setup 
- ECR: creates to repos for the app and the DB
- ansible.cfg: to skip confirmation at the beginning of the ansible playbook as it is provisioned by terraform 
### Jenkinsfile:
pipeline as a code used to be triggered at each commit and create new docker images of the app then push and deploy to EKS
### bash.sh:
Bash script used to get AWS credentials and automate creation or destruction of the  infrastructure

## Usage
### Testt locally with Docker
To test the app locally 

cd to the file that contains the docker-compose.yaml (`cd ./Dockerization`)
```bash
docker-compose up 
```
that will run three containers (app, db, adminer(to monitor the database))
you can use the application at `localhost:5000`
## CI/CD
to deploy the app on the cloud and enable outside traffic we start with:

run bash script 
```bash
bash bash.sh
```
then choose 1 to create infrastructure or 2 to destroy it after testing the app

the console will output infrastructure URLs

after that you will have ec2 configured with Jenkins master with plugins installed 

access the server using `Jenkins-server-ip:8080`

login using Username and password `admin`

<img src="https://i.stack.imgur.com/IbhDD.png" width="480" height="400" />

cancel plugins download from the top right corner as it was already downloaded at initialization
![image!](https://phoenixnap.com/kb/wp-content/uploads/2021/11/install-jenkins-windows-13-install-plugins.png)

Now add your AWS Credentials form  Dashboard → Manage Jenkins → Manage Credentials → global(add credentials)

then add credentials off Kind “AWS Credentials” with ID “aws-credentials”

<img src="https://user-images.githubusercontent.com/117172376/226955848-f244adee-c597-44ca-a6c6-fc1797a6bf43.png" width="480" height="400" />

add a new item of type pipeline to use Jenkins file

active "GitHub hook trigger for GITscm polling"

change script source to fetch it from GitHub

<img src="https://user-images.githubusercontent.com/117172376/226956065-08ff54e3-4aff-4db3-ac8c-134043c5166b.png" width="480" height="400" />

Add repo URL and credentials only if it was private and choose the branch to work on

From your GitHub repo settings add webhook with payload URL (jenkins_ip:8080/github-webhook/)

![Untitled3](https://user-images.githubusercontent.com/117172376/226956071-90627c77-b9b6-45fb-a3f2-c5fc8d2c51c5.png)

after these steps jenkins pipeline will build at each commit on GitHub repo

