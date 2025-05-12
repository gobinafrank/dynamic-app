pipeline {
    agent any
    
    environment {
        DOCKER_HOST_CREDS = credentials('dockerhost')
        DOCKER_HUB_CREDS = credentials('dockerhub-creds')
        DOCKER_IMAGE_NAME = 'ewanedon/java-webapp-devops'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_HOST_IP = '13.49.57.27'
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
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                script {
                    def testOutput = sh(script: 'mvn test', returnStdout: true)
                    env.TESTS_EXECUTED = !(testOutput.contains('No tests to run') || testOutput.contains('No tests were executed'))
                }
            }
            post {
                always {
                    script {
                        if (env.TESTS_EXECUTED == 'true') {
                            junit '**/target/surefire-reports/*.xml'
                        } else {
                            echo "No tests were executed, skipping JUnit report collection"
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Docker Host') {
            steps {
                sshagent(['dockerhost']) {
                    script {
                        // Copy WAR file and Dockerfile to Docker host
                        sh 'scp -o StrictHostKeyChecking=no target/java-webapp-devops.war ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/app.war'
                        sh 'scp -o StrictHostKeyChecking=no Dockerfile ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/Dockerfile'
                        
                        // Check if init.sql exists before trying to copy it
                        sh 'if [ -f src/main/resources/db/init.sql ]; then scp -o StrictHostKeyChecking=no src/main/resources/db/init.sql ubuntu@${DOCKER_HOST_IP}:/home/ubuntu/init.sql; fi'
                        
                        // Execute Docker commands on the remote host - IMPORTANT: Use single quotes for the outer ssh command
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@''' + env.DOCKER_HOST_IP + ''' "
                                cd /home/ubuntu
                                docker build -t ''' + env.DOCKER_IMAGE_NAME + ''':''' + env.DOCKER_IMAGE_TAG + ''' .
                                docker tag ''' + env.DOCKER_IMAGE_NAME + ''':''' + env.DOCKER_IMAGE_TAG + ''' ''' + env.DOCKER_IMAGE_NAME + ''':latest
                                echo ''' + env.DOCKER_HUB_CREDS_PSW + ''' | docker login -u ''' + env.DOCKER_HUB_CREDS_USR + ''' --password-stdin
                                docker push ''' + env.DOCKER_IMAGE_NAME + ''':''' + env.DOCKER_IMAGE_TAG + '''
                                docker push ''' + env.DOCKER_IMAGE_NAME + ''':latest
                                
                                # Stop and remove existing containers
                                docker stop webapp mysql || true
                                docker rm webapp mysql || true
                                
                                # Create a network if it doesn't exist
                                docker network create java-app-network || true
                                
                                # Start MySQL container
                                docker run -d --name mysql \\
                                    --network java-app-network \\
                                    -p 3306:3306 \\
                                    -e MYSQL_ROOT_PASSWORD=rootpassword \\
                                    -e MYSQL_DATABASE=javaapp \\
                                    -e MYSQL_USER=javaapp \\
                                    -e MYSQL_PASSWORD=javaapp123 \\
                                    -v /home/ubuntu/mysql-data:/var/lib/mysql \\
                                    -v /home/ubuntu/init.sql:/docker-entrypoint-initdb.d/init.sql \\
                                    --restart always \\
                                    mysql:8.0
                                
                                # Start webapp container - FIXED: properly quote the CATALINA_OPTS value
                                docker run -d --name webapp \\
                                    --network java-app-network \\
                                    -p 8080:8080 \\
                                    -e 'CATALINA_OPTS=-Xms512m -Xmx1024m' \\
                                    --restart always \\
                                    ''' + env.DOCKER_IMAGE_NAME + ''':''' + env.DOCKER_IMAGE_TAG + '''
                            "
                        '''
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
