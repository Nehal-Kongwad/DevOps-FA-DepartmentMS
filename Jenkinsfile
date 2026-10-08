pipeline {
    agent any

    environment {
        DOCKER = 'C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        DOCKER_COMPOSE = 'C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker-compose.exe'
    }

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
                bat "\"%DOCKER_COMPOSE%\" build"
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    powershell '''
                    $docker = "C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe"

                    Write-Host "Docker Hub username: $env:DOCKER_USERNAME"
                    Write-Host "Docker password length: $($env:DOCKER_PASSWORD.Length)"
                    Write-Host "Testing Docker Hub authentication..."

                    $env:DOCKER_PASSWORD | & $docker login `
                        --username $env:DOCKER_USERNAME `
                        --password-stdin

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "Docker Hub authentication failed."
                        exit 1
                    }

                    Write-Host "Docker Hub authentication SUCCESSFUL!"
                    '''
                }
            }
        }

        stage('Tag Docker Images') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    bat "\"%DOCKER%\" tag campus-connect-fa2-backend %DOCKER_USERNAME%/campus-connect-backend:latest"
                    bat "\"%DOCKER%\" tag campus-connect-fa2-frontend %DOCKER_USERNAME%/campus-connect-frontend:latest"
                }
            }
        }

        stage('Push Backend Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    bat "\"%DOCKER%\" push %DOCKER_USERNAME%/campus-connect-backend:latest"
                }
            }
        }

        stage('Push Frontend Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-jenkins',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    bat "\"%DOCKER%\" push %DOCKER_USERNAME%/campus-connect-frontend:latest"
                }
            }
        }
    }

    post {
        success {
            echo '=========================================='
            echo 'CI/CD PIPELINE COMPLETED SUCCESSFULLY!'
            echo '=========================================='
            echo 'Backend built, tested and pushed to Docker Hub.'
            echo 'Frontend built and pushed to Docker Hub.'
        }

        failure {
            echo '=========================================='
            echo 'CI/CD PIPELINE FAILED'
            echo '=========================================='
            echo 'Check the failed stage in the Jenkins console.'
        }
    }
}