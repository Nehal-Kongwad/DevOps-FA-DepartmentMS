pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend Build') {
            steps {
                dir('backend') {
                    bat 'npm ci'
                    bat 'npm run build'
                }
            }
        }

        stage('Backend Test') {
            steps {
                dir('backend') {
                    bat 'set NODE_ENV=test&& npm test -- --runInBand'
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker-compose.exe" build'
            }
        }

        stage('Docker Hub Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',,
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {

                    bat 'echo %DOCKER_PASSWORD% | "C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login -u %DOCKER_USERNAME% --password-stdin'

                    bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" tag campus-connect-fa2-backend %DOCKER_USERNAME%/campus-connect-backend:latest'

                    bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" tag campus-connect-fa2-frontend %DOCKER_USERNAME%/campus-connect-frontend:latest'

                    bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" push %DOCKER_USERNAME%/campus-connect-backend:latest'

                    bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" push %DOCKER_USERNAME%/campus-connect-frontend:latest'
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Docker build and push completed successfully!'
        }

        failure {
            echo 'CI/CD pipeline failed. Check the stage logs.'
        }
    }
}