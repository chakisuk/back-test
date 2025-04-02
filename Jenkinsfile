pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "chakisuk" // Docker Hub의 사용자 이름
        IMAGE_NAME = "test-back" // 생성할 Docker 이미지의 이름
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}" // chakisuk/test-back 이미지 생성
        DOCKER_TAG = "latest" // Docker의 이미지 태그 lastest : 최신버전
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-jenkins') // 젠킨스 자격증명 시스템에서 dockerhub-jenkins라는 ID를 가진 자격증명을 가져온다.
                                                                // DOCKERHUB_CREDENTIALS_USR: Docker Hub 사용자 이름
                                                                // DOCKERHUB_CREDENTIALS_PSW: Docker Hub 비밀번호 또는 토큰
                                                                // 이 2개의 변수를 자동으로 생성해준다.(도커 로그인할 때, 사용됨)
        CONTAINER_NAME = "test-back" // 실행할 Docker 컨테이너의 이름
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                   url: 'https://github.com/chakisuk/back-test.git',
                   credentialsId: 'farmdora-login'  // 필요한 경우
            }
        }
        
        stage('Prepare') {
            steps {
                // gradlew 파일에 실행 권한 추가
                sh 'chmod +x ./gradlew'
                sh 'ls -la gradlew'  // 권한 확인
            }
        }

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
        
        stage('Cleanup') {
            steps {
                sh 'docker image prune -f --filter="reference=${DOCKERHUB_USERNAME}/${IMAGE_NAME}"' // chakisuk/test-back + <none> 태그 삭제
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}