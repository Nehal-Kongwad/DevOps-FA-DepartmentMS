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
                bat 'docker compose build'
            }
        }
    }

    post {
        success {
            echo 'CI Pipeline completed successfully!'
        }

        failure {
            echo 'CI Pipeline failed. Check the stage logs.'
        }
    }
}