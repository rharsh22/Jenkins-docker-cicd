pipeline {
    agent any
    triggers { pollSCM('H/2 * * * *') }     
    tools { maven 'maven-3' }
    options { skipDefaultCheckout(true) }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps { sh 'mvn -B clean package' }
        }
        stage('Image') {
            steps { sh 'docker build -t jenkins-app:$BUILD_NUMBER .' }
        }
        stage('Deploy') {
            steps {
                sh 'docker rm -f jenkins-app || true'
                sh 'docker run -d --name jenkins-app -p 127.0.0.1:8082:8080 jenkins-app:$BUILD_NUMBER'
            }
        }
    }
}
