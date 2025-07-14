# CI/CD Project: Flask App with Jenkins, Ansible, Docker & Kubernetes 

## Overview
This project demonstrates a complete CI/CD pipeline for deploying a Flask web application using Jenkins, Docker, and Kubernetes (K3s).
Ansible is used to automatically configure the worker VM by installing required tools and deploying the Flask app.

## Tools & Technologies
* Jenkins – CI/CD pipeline orchestration
* Ansible – Infrastructure automation
* Python – for Web application
* Docker – Containerization
* Docker Hub – Image registry
* K3s – Lightweight Kubernetes distribution
* GitHub – Source control and project management

## Prerequisites
Before running the pipeline, make sure you have the following in place:
### Environment Setup
Prepare two Linux VMs (e.g. Ubuntu):
- Master VM:
  * Jenkins installed
  * Ansible installed
  * SSH private key configured for access to the Worker VM
  * Docker installed and running (configure to run docker without sudo)
- Worker VM:
  * Install Openssh
  * Copy public ssh from the master vm to the worker vm
  * All the the required programs will be installed automaticaly by Ansible.
    
### GitHub Configuration (Before Running the Pipeline)
To successfully configure your pipeline and automation, make the following updates in your cloned GitHub repo:
1. ansible/inventory.ini
   * Set the correct IP address and SSH username of your worker VM:
     ```ini
      [worker]
      worker-vm ansible_host=[worker IP] ansible_user=[worker user name]
     ```
3. ansible/deploy_site.yaml
   * Update line 10 with your actual worker VM username [worker user name]:
     ```yaml
      kubeconfig_path: "/home/[worker user name]/k3s.yaml"
     ```
5. ansible/adhoc.sh
   * Update line 7 with your actual worker VM username [worker user name]:
     ```bash
      ansible worker -i inventory.ini -m shell -a "KUBECONFIG=/home/[worker user name]/k3s.yaml kubectl get svc"
     ```
     
### Jenkins Configuration
Jenkins must have:
* Access to your GitHub repo
* Docker Hub credentials (Docker_cred) stored in Jenkins
* Sudo password for the worker VM stored as a Secret text (worker_sudo_pass)
* SSH private key stored as SSH Username with private key (ssh_to_worker) to allow Ansible to connect

### SSH Key Setup for Jenkins & Ansible
To allow Jenkins to SSH into the worker VM and run Ansible playbooks:
#### Step 1: Copy the Private Key for Jenkins
Run:
```bash
cat ~/.ssh/[you_rsa_file]
```
Copy the full content, including the markers:
```vbnet
-----BEGIN RSA PRIVATE KEY-----
...your key...
-----END RSA PRIVATE KEY-----
```
#### Step 2: Add the SSH Key in Jenkins
1. Go to Manage Jenkins → Credentials → Global → Add Credentials
2. Select:
  - Kind: SSH Username with private key
  - Username: [The user of the worker]
  - Private Key: Enter directly and paste the full key
  - ID: ssh_to_worker
3. Click Save

## How the Pipeline Works
1. Jenkins pulls the code and Jenkinsfile from GitHub
2. Docker builds the image and tags it as lidordayan/site-app
3. The image is pushed to Docker Hub
4. Jenkins triggers Ansible to:
  - Install Docker, K3s, and pip on the worker VM
  - Deploy the Flask app using deployment.yaml and site-service.yaml
5. An ad-hoc script is run to verify the setup (e.g., docker, kubectl, services)

## Accessing the App
Once the deployment is complete, open the app in your browser at:
```cpp
http://<node-ip>:30007
```

## 📁 Project Structure
```csharp
├── ansible/
│   ├── templates/
│   │   └── deployment.yaml.j2           # Jinja2 template for Kubernetes deployment
│   ├── adhoc.sh                         # Optional validation or manual script
│   ├── deploy_site.yaml                 # Ansible playbook for deploying site
│   ├── inventory.ini                    # Inventory file with target hosts
│   └── playbook.yaml                    # Ansible playbook for installing Docker, K3s, pip
│
├── static/
│   └── css/
│       └── style.css                   # CSS styles for the Flask app
│
├── templates/
│   ├── base.html                       # Base HTML layout
│   └── index.html                      # Main HTML page for the Flask app
│
├── .gitignore                          # Specifies files to be ignored by Git
├── Dockerfile                          # Docker image definition for the Flask app
├── Jenkinsfile                         # Jenkins pipeline definition
├── README.md                           # Project documentation (this file)
├── app.py                              # Main Flask application
├── deployment.yaml                     # Kubernetes deployment (rendered or static)
├── requirements.txt                    # Python dependencies
├── site-service.yaml                   # Kubernetes NodePort service definition

```

