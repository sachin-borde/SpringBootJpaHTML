pipeline {
  agent any

  environment {
    DOCKER_CRED_ID = 'dockerhub-creds'
    DOCKER_USER    = 'ssborde26'
    IMAGE_NAME     = "${DOCKER_USER}/springboot-html"
    IMAGE_TAG      = "${env.BUILD_NUMBER}"
    FULL_IMAGE     = "${IMAGE_NAME}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        git(
          url: 'https://github.com/sachin-borde/SpringBootJpaHTML.git',
          branch: 'master',
          credentialsId: 'github-creds'
        )
      }
    }

    stage('Build JAR') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build(FULL_IMAGE)
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('', "${DOCKER_CRED_ID}") {
            dockerImage.push("${IMAGE_TAG}")
            dockerImage.push('latest')
          }
        }
      }
    }
  }

  post {
    always {
      sh "docker rmi ${FULL_IMAGE} || true"
      cleanWs()
    }
  }
}
