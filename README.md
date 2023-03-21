# E2E Deployment of Flask application
Deploying a flask application with MYSQL database to EKS Cluster using multiple tool and going through multiple steps 
- AWS Services
- Terraform integrated with Ansible
- Docker
- Kubernetes
- Jenkins
## GitHub Repo Folders Contents
#### Dockerization
contains 
- the app source code and it's docker file
- database queries 
- docker compose to test the application locally
#### K8s
- deployment.yaml: create a deployment out of the flask app and add a load balancer service to it 
- statefulset.yaml: create a stateful set for the DBas it requires persistent storage for stateful workloads, and ordered, automated rolling updates
- ingress.yaml : an ingress object to map the traffic to the cluster services
#### Terraform
contains there main folders
- EKS: creates EKS cluster with 2 nodes
- EC2: creates an EC2 instance and integrates terraform with ansible to install Jenkins and skip initial setup 
- ECR: creates to repos for the app and the DB
- ansible.cfg: to skip confirmation at the beginning of the ansible playbook as it is provisioned by terraform 
#### Jenkinsfile
pipeline as a code used to be triggered at each commit and create new docker images of the app then push and deploy to EKS

## Usage
### Docker
To test the app locally 

cd to the file that contains the docker-compose.yaml
```bash
docker-compose up 
```
that will run three containers (app, db, adminer(to monitor the database))
you can use the application at `localhost:5000`
## CI/CD
