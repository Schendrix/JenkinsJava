pipeline {
    agent {
        docker { image 'maven:3.9.3-eclipse-temurin-20' }
    }
    environment {
        IMAGE_NAME = "schender21/simple-web-app"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Schendrix/JenkinsJava.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push $IMAGE_NAME:$IMAGE_TAG"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container...'
                sh "docker stop simple-web-app || true"
                sh "docker rm simple-web-app || true"
                sh "docker run -d -p 8081:8080 --name simple-web-app $IMAGE_NAME:$IMAGE_TAG"
            }
        }
    }

    post {
        always {
            cleanWs() // This is outside the stages block
        }
    }
}
