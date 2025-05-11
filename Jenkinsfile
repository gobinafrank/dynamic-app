pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('dockerhub-credentials')
        DOCKER_IMAGE_NAME = 'yourusername/java-webapp-devops'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_HOST_IP = 'your-docker-ec2-ip'
    }
    
    tools {
        maven 'Maven 3.9.9'
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
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Copy WAR file to Docker host
                    sh 'scp target/*.war ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/app.war'
                    
                    // Copy Dockerfile to Docker host
                    sh 'scp Dockerfile ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/Dockerfile'
                    
                    // Use Docker context to build and push
                    withEnv(['DOCKER_CONTEXT=docker-ec2']) {
                        sh """
                            docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} /home/ubuntu/
                            docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:latest
                            echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin
                            docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                            docker push ${DOCKER_IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Copy docker-compose.yml to Docker host
                    sh 'scp docker-compose.yml ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/'
                    
                    // Copy init.sql to Docker host
                    sh 'scp src/main/resources/db/init.sql ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/'
                    
                    // Deploy using Docker context
                    withEnv(['DOCKER_CONTEXT=docker-ec2']) {
                        sh """
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
