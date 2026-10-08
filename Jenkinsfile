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

        stage('Docker Credential Fingerprint') {
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

                    $sha256 = [System.Security.Cryptography.SHA256]::Create()
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($env:DOCKER_PASSWORD)
                    $hash = $sha256.ComputeHash($bytes)
                    $fingerprint = [BitConverter]::ToString($hash).Replace("-", "").ToLower()

                    Write-Host "Credential SHA256: $fingerprint"
                    Write-Host "Credential length: $($env:DOCKER_PASSWORD.Length)"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Docker credential fingerprint check completed successfully!'
        }

        failure {
            echo 'Docker credential fingerprint check failed.'
        }
    }
}