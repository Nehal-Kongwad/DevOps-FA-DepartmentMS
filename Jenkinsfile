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

        stage('Docker Hub Login Test') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {

                    powershell '''
                    Write-Host "Testing Docker Hub login..."
                    Write-Host "Username: $env:DOCKER_USERNAME"

                    $env:DOCKER_PASSWORD | & "C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login --username $env:DOCKER_USERNAME --password-stdin

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "Docker Hub login failed."
                        exit 1
                    }

                    Write-Host "Docker Hub login successful!"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Docker Hub authentication test completed successfully!'
        }

        failure {
            echo 'Docker Hub authentication test failed.'
        }
    }
}