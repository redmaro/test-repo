pipeline {
    agent any
//    options {
//        // options
//    }
//
//    parameters {
//        // Parameters
//    }
//
    environment {
        // environment variables
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('iac:terraform plan') {
            steps {
                script {
                    sh '''
                        terraform init
                        terraform plan
                    '''
                }
            }
        }

        stage('confirm:deploy') {
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:
                    - branch: ${env.GIT_BRANCH}
                    Do you confirm the deployment
                """)
            }
        }

        stage('iac:terraform apply') {
            steps {
                script {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

    post { 
        always { 
            cleanWs()
        }
    }

}