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

        stage('Docker Environment Check') {
            steps {
                bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" context show'
                bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" version'
                bat '"C:\\Users\\Nehal\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" info'
            }
        }
    }

    post {
        success {
            echo 'Docker environment check completed successfully!'
        }

        failure {
            echo 'Docker environment check failed. Check the logs.'
        }
    }
}