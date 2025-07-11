pipeline {
    agent any

    environment {
        IMAGE_NAME = "lidordayan/site-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/LidorDayan/Project-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f site-service.yaml
                '''
            }
        }
    }
}
