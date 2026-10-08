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

        stage('Docker Hub Credential Check') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {

                    powershell '''
                    Write-Host "Docker username: $env:DOCKER_USERNAME"
                    Write-Host "Docker token length: $($env:DOCKER_PASSWORD.Length)"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD credential diagnostic completed successfully!'
        }

        failure {
            echo 'CI/CD pipeline failed. Check the stage logs.'
        }
    }
}