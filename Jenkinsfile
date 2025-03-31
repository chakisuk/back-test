pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "chakisuk"
        IMAGE_NAME = "farmdora-BE"
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}" // chakisuk/farmdora-BE 이미지 생성
        CONTAINER_NAME = "farmdora-BE"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Build') {
            steps {
                sh './gradlew clean build'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'farmdora-login', usernameVariable: 'username', passwordVariable: 'password')]) {
                    sh 'echo ${password} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker stop ${CONTAINER_NAME} || true'
                sh 'docker rm ${CONTAINER_NAME} || true'
                sh 'docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}