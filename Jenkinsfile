pipeline {
    agent any
    environment { // Jenkins -> Credentials -> System -> Global credentials 
        GIT_TOKEN = credentials('GIT_TOKEN')
    }

    stages {
        stage('checkout') {
            steps {
                git branch: 'code' ,credentialsId: 'GIT_TOKEN' ,url: 'https://github.com/cbagade/argocd-all.git'
            }
        }
        stage('CODE') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE'){
                sh '''#!/bin/bash
                      pwd
                      ls -lrt
                      echo "Jenkins startred demo"
                      chmod a+rx ./build_code.sh
                      ./build_code.sh start
                '''
                }
            }
        }
    }
}
