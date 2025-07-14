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

        stage('Configure Worker with Ansible') {
            steps {
                withCredentials([
                    string(credentialsId: 'worker_sudo_pass', variable: 'SUDO_PASS'),
                    sshUserPrivateKey(credentialsId: 'ssh_to_worker', keyFileVariable: 'SSH_KEY')
                ]) {
                    sh '''
                        cd ansible
                        ANSIBLE_HOST_KEY_CHECKING=False \
                        ansible-playbook -i inventory.ini playbook.yaml \
                          --private-key "$SSH_KEY" \
                          --extra-vars "ansible_become_pass=$SUDO_PASS"
                    '''
                }
            }
        }

        stage('Deploy Flask App with Ansible') {
            steps {
                withCredentials([
                    string(credentialsId: 'worker_sudo_pass', variable: 'SUDO_PASS'),
                    sshUserPrivateKey(credentialsId: 'ssh_to_worker', keyFileVariable: 'SSH_KEY')
                ]) {
                    sh '''
                        cd ansible
                        ANSIBLE_HOST_KEY_CHECKING=False \
                        ansible-playbook -i inventory.ini deploy_site.yaml \
                          --private-key "$SSH_KEY" \
                          --extra-vars "ansible_become_pass=$SUDO_PASS image_name=$IMAGE_NAME"
                    '''
                }
            }
        }

        stage('Run Ad-hoc Checks') {
            steps {
                withCredentials([
                    string(credentialsId: 'worker_sudo_pass', variable: 'SUDO_PASS'),
                    sshUserPrivateKey(credentialsId: 'ssh_to_worker', keyFileVariable: 'SSH_KEY')
                ]) {
                    sh '''
                        cd ansible
                        chmod +x adhoc.sh
                        ./adhoc.sh "$SUDO_PASS"
                    '''
                }
            }
        }
    }
}
