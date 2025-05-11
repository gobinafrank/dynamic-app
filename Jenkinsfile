pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('dockerhub-creds')
        DOCKER_IMAGE_NAME = 'ewanedon/java-webapp-devops'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_HOST_IP = '16.171.239.146'
    }
    
    tools {
        maven 'Maven-3.9.9'
        jdk 'JDK 21'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                // Build using Jenkins' Maven installation
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Deploy to Docker Host') {
            steps {
                script {
                    // Copy WAR file and Dockerfile to Docker host
                    sh 'scp target/java-webapp-devops.war ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/app.war'
                    sh 'scp Dockerfile ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/Dockerfile'
                    sh 'scp docker-compose.yml ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/'
                    sh 'scp src/main/resources/db/init.sql ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/'
                    
                    // Build and deploy on Docker host
                    withEnv(['DOCKER_CONTEXT=docker-ec2']) {
                        sh """
                            docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} /home/ubuntu/
                            docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:latest
                            echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin
                            docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                            docker push ${DOCKER_IMAGE_NAME}:latest
                            
                            export DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}
                            export DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}
                            cd /home/ubuntu
                            docker-compose down || true
                            docker-compose up -d
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
