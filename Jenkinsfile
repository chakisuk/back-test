pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "chakisuk"
        IMAGE_NAME = "test-back"
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}" // chakisuk/farmdora-BE 이미지 생성
        DOCKER_TAG = "latest"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-jenkins')
        CONTAINER_NAME = "farmdora-BE"
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
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
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