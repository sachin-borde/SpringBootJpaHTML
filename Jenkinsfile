pipeline {
  agent any

  environment {
    // Docker Hub credentials ID in Jenkins
    DOCKER_CRED_ID = 'dockerhub-creds'
    // Docker Hub repo (replace with your own)
    DOCKER_IMAGE   = 'ssborde26/springboot'
  }

  stages {
    stage('Checkout') {
      steps {
        // Pull from GitHub
        git url: 'https://github.com/your-org/your-springboot-repo.git', branch: 'master'
      }
    }

    stage('Build JAR') {
      steps {
        // Build with Maven wrapper (or use mvn if no wrapper)
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        // Build and tag image as <repo>:<buildNumber> and as latest
        script {
          docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}", '.')
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        // Log in and push both tags
        withCredentials([usernamePassword(
          credentialsId: "$DOCKER_CRED_ID",
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
          sh "docker push ${DOCKER_IMAGE}:latest"
        }
      }
    }
  }

  post {
    always {
      // Cleanup workspace & dangling images
      sh 'docker rmi ${DOCKER_IMAGE}:${env.BUILD_NUMBER} || true'
      cleanWs()
    }
  }
}
