# E2E Deployment of Flask application
Deploying a flask application with MYSQL database to EKS Cluster using multiple tool and going through multiple steps using
- AWS Services
- Terraform integrated with Ansible
- Docker
- Kubernetes
- Jenkins
## Repository Folders Contents
### Dockerization:

- app : The flask app source code with it's Docker file
- db : Database queries and the db Docker file
- docker-compose.yaml: to test the application locally
### K8s-Files:
- dep.yaml: create a deployment out of the flask app and add a load balancer service to it 
- stateful.yaml: create a stateful set for the DB as it requires persistent storage for stateful workloads, and ordered, automated rolling updates
- ingress.yaml : an ingress object to map the traffic from the outside to the cluster services
### Terraform:
contains there main modules
- EKS: Creates EKS cluster with 2 nodes
- EC2: Creates an EC2 instance and integrates terraform with ansible playbook to install  
  - Jenkins 
  - Jenkins plugins 
  - skip initial setup 
  - creates default user with username and password "admin" 
- ECR: Creates to repos for the app and the DB
- ansible.cfg: to skip confirmation at the beginning of the ansible playbook as it is provisioned by terraform 
### Jenkinsfile:
pipeline as a code used to be triggered at each commit and create new docker images of the app then push to ECR and deploy to EKS
### bash.sh:
Bash script used to get AWS credentials and automate creation or destruction of the  infrastructure

# Usage
You can either test the app locally or deploy it to EKS
### Test locally with Docker
To test the app locally 
```bash
cd ./Dockerization
docker-compose up 
```
- that will run three containers (app, db, adminer(to monitor the database))
- Access the app through  `localhost:5000`
![docker-localhost](https://user-images.githubusercontent.com/117172376/227232800-8296a3e7-b3c2-422d-8cd2-0f375fd54085.png)

### Deploy to EKS
1- run bash script in the repo root directory
```bash
bash bash.sh
```
![bashscript](https://user-images.githubusercontent.com/117172376/227230713-ebe90efd-f40f-405a-8429-3fad46029cfc.png)
- Choose `1` to `Create` infrastructure or `2` to `Destroy` it after testing the app
- Enter your AWS Credentials
the console will output infrastructure URLs

Now you in your AWS account there is:
- EKS cluster with 2 nodes 
- Two ECR repos with names app and db 
- EC2 instance with Jenkins master running 

2- Access the server using URL outputted from the console  `Jenkins-server-ip:8080`

login using Username and password `admin`
<p align="center">
  <img width="460" height="300" src="https://user-images.githubusercontent.com/117172376/227234823-d2f13dd6-5b20-4901-a4da-f2d0c7f45cbd.png">
</p>

Cancel plugins download as it was already downloaded at initialization
<p align="center">
  <img width="460" height="300" src="https://user-images.githubusercontent.com/117172376/227237318-2a672164-8e79-4c08-aebf-581954ae53d3.png">
</p>

3- Add your AWS Credentials form  Dashboard → Manage Jenkins → Manage Credentials → global(add credentials)

then add credentials off Kind “AWS Credentials” with ID “aws-credentials”
<p align="center">
<img src="https://user-images.githubusercontent.com/117172376/226955848-f244adee-c597-44ca-a6c6-fc1797a6bf43.png" width="480" height="400" />
</p>

3- Add a new item of type pipeline to use Jenkins file

- active "GitHub hook trigger for GITscm polling"
<p align="center">
<img src="https://user-images.githubusercontent.com/117172376/227238968-78962361-589a-4648-bd3d-c83e0b3f507d.png" />
</p>

 - Change script source to fetch it from GitHub
   - Add repo URL and credentials only if it was private and choose the branch to work on
<p align="center">
<img src="https://user-images.githubusercontent.com/117172376/226956065-08ff54e3-4aff-4db3-ac8c-134043c5166b.png" width="480" height="400" />
</p>

From your GitHub repo settings add webhook with payload URL (jenkins_ip:8080/github-webhook/)

<p align="center">
<img src="https://user-images.githubusercontent.com/117172376/226956071-90627c77-b9b6-45fb-a3f2-c5fc8d2c51c5.png" />
</p>

after these steps Jenkins pipeline will be triggered at each commit on GitHub repo

