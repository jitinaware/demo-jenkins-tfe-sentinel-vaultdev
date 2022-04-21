/* 
This is an example pipeline, featuring Jenkins credential binding,
downloading Terraform CLI during the pipeline (instead of using existing install),
and VCS integration
*/

pipeline {
    
    agent any

    environment {
        GIT_REPO = "https://github.com/echelonproject/demo-jenkins-tfe-sentinel-aws.git"
        TFE_NAME = "app.terraform.io"
        TFE_URL = "https://app.terraform.io"
        TFE_ORGANIZATION = "jaware-hashicorp"
        TFE_API_URL = "${TFE_URL}/api/v2"
        TFE_API_TOKEN = credentials('tfc-api-token')
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Preparation') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'fd17e70a-f1f9-4f07-bbae-8ceae0b78738', gitToolName: '/usr/bin/git')]) {
                sh 'git fetch --all || git clone $GIT_REPO'
                sh "ls"
                sh '''
                  curl -o tf.zip https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip ; yes | unzip tf.zip
                    ./terraform version
                    
                '''
                }        
            }
        }
        stage('TFE Workspace List ') {
            steps {
                sh '''
                  curl \
                    --silent --show-error --fail \
                    --header "Authorization: Bearer $TFE_API_TOKEN" \
                    --header "Content-Type: application/vnd.api+json" \
                    ${TFE_API_URL}/organizations/${TFE_ORGANIZATION}/workspaces \
                    | jq -r \'.data[] | .attributes.name\'
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                sh "./terraform -chdir=demo-jenkins-tfe-sentinel-aws plan"
            }
        }
        stage('Terraform Apply') {
            steps {
                sh "./terraform apply -auto-approve"
            }
        }
    }
}