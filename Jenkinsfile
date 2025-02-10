pipeline {
    agent any
    options {
        ansiColor('xterm')
        // options
    }

    parameters {
        // Parameters
        choice(name: 'env' , choice ['prod', 'dev'], description)
        booleanParam(name: 'Destroy', defaultValue: false, description: 'Destruction du précédent déploiement - terraform destroy')
    }

    environment {
        // environment variables
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('iac:terraform plan') {
            when {
                expression { params.Destroy == false }
            }
            steps {
                script {
                    sh '''
                        terraform init \
                            -backend-config="bucket=maro-tp-terraform-bucket" \
                            -backend-config="key=terraform/${TF_VAR_env}/state" \
                            -backend-config="region=$AWS_DEFAULT_REGION" \
                            -backend-config="dynamodb_table=maro-dyndb"
                        terraform plan
                    '''
                }
            }
        }

        stage('confirm:deploy') {
            when {
                expression { params.Destroy == false }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:
                    - branch: ${env.GIT_BRANCH}
                    Do you confirm the deployment
                """)
            }
        }

        stage('confirm:destroy') {
            when {
                expression { params.Destroy == true }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to destroy:
                    - branch: ${env.GIT_BRANCH}
                    Do you confirm the destruction
                """)
            }
        }

        stage('iac:terraform apply') {
            when {
                expression { params.Destroy == false }
            }
            steps {
                script {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('iac:terraform destroy') {
            when {
                expression { params.Destroy == true }
            }
            steps {
                script {
                    sh '''
                        terraform init
                        terraform destroy -auto-approve
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