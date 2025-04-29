pipeline {
  agent any

  environment {
    // Replace with your actual Docker Hub repo
    DOCKER_IMAGE = 'ssborde26/springboot-html'
  }

  stages {
    stage('Checkout') {
      steps {
        // Pull the code
        git url: 'https://github.com/sachin-borde/SpringBootJpaHTML.git', branch: 'master', credentialsId: 'github-creds'

        // Make mvnw executable so Jenkins can run it
        sh 'chmod +x mvnw'                     // :contentReference[oaicite:1]{index=1}
      }
    }

    stage('Build JAR') {
      steps {
        // Build the fat JAR; skip tests for speed
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // Build and tag as <repo>:<buildNumber> and latest
          docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")  // :contentReference[oaicite:2]{index=2}
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        // Log in (uses stored credentials in Jenkins) and push
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
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
      // Clean up local image and workspace
      sh 'docker rmi ${DOCKER_IMAGE}:${env.BUILD_NUMBER} || true'
      cleanWs()
    }
  }
}
