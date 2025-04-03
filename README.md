pipeline {
    agent any
    
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/parnik-code/webpage_thankyou.git'
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                 sh ''' $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.host.url=http://35.183.62.18:9000 \
                        -Dsonar.login=squ_4da6f426bef23868e2575ae9d8928df74cb7763d \
                        -Dsonar.projectName=thankyou \
                        -Dsonar.projectKey=thankyou \
                        -Dsonar.java.binaries=. 
                    '''
            }
        }
        stage('docker build') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred'){
                        sh 'docker build -t parnikdwivedi/webpage_thankyou:latest .'
                        sh 'docker push parnikdwivedi/webpage_thankyou:latest '
                    }
                }
            }
        }
        stage('Trivy scan') {
            steps {
                sh 'trivy fs --severity HIGH,CRITICAL --format table .'
            }
        }
        stage('Docker deploy') {
            steps {
                sh 'docker run -d -p 8099:80 parnikdwivedi/webpage_thankyou:latest'
            }
        }
        
    }
}
