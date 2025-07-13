# CI/CD Project: Flask App with Jenkins, Docker & Kubernetes

## Overview
This project shows how to set up a full CI/CD pipeline for a Flask web app. Jenkins manages the whole process, from making a Docker image to submitting it to Docker Hub and then using kubectl to deploy it to a Kubernetes cluster.

## Tools & Technologies
* Python – for Web application
* Docker – Containerization
* Docker Hub – Image registry
* Jenkins – CI/CD orchestration
* Kubernetes – Deployment platform
* GitHub – Source control and project management

## Prerequisites
Before running the pipeline, make sure you have the following in place:
### Environment Setup
* A Linux VM (e.g. Ubuntu) with:
  * Docker installed and running (configure to run docker without sudo)
  * Jenkins installed
  * K3s installed and configured (configure to run kubectl without sudo)
### Jenkins Configuration
Jenkins must have:
* Access to your GitHub repo (via HTTPS or SSH)
* Docker Hub credential set up in Jenkins for pushing images

## How the Pipeline Works
- Jenkins pulls the code from GitHub, including the Jenkinsfile
- It builds a Docker image using the Dockerfile
- The image is pushed to Docker Hub
- Jenkins then applies deployment.yaml and site-service.yaml to the Kubernetes cluster using kubectl

## Accessing the App
Once the deployment is complete, open the app in your browser at:
```cpp
http://<node-ip>:30007
```

## 📁 Project Structure
```csharp
├── static/css/
│   └── style.css                  # CSS styling
├── templates/
│   ├── base.html                  # HTML base layout
│   └── index.html                 # Main page template
├── .gitignore                     # Git ignore rules
├── app.py                         # Flask application
├── requirements.txt              # Python dependencies
├── Dockerfile                     # Docker image definition
├── Jenkinsfile                    # Jenkins pipeline steps
├── deployment.yaml                # Kubernetes deployment config
├── site-service.yaml              # Kubernetes NodePort service
└── README.md                      # Project documentation
```

