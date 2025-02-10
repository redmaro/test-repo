pipeline {
    agent any
    options {
        ansiColor('xterm')
        // options
    }

    parameters {
        // Parameters
        choice(name: 'env', choices: ['prod', 'dev'], description: 'Choisir l’environnement')
        booleanParam(name: 'Destroy', defaultValue: false, description: 'Destruction du précédent déploiement - terraform destroy')
    }

    environment {
        // environment variables
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    terraform init \
                      -backend-config="bucket=maro-tp-terraform-bucket" \
                      -backend-config="key=terraform/state" \
                      -backend-config="region=us-east-1" \
                      -backend-config="dynamodb_table=maro-dyndb"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh """
                    terraform plan -var="env=${params.env}"
                    """
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