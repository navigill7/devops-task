pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = credentials('aws-account-id')  
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        ECR_REPO = "devops_task"
        SONARQUBE = "Sonar" 
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        HELM_REPO = "https://github.com/navigill7/devops-task.git" 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/navigill7/devops-task.git'
            }
        }

        stage('Code Quality - SonarQube') {
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "$SONARQUBE/bin/sonar-scanner -Dsonar.projectName=devops_task -Dsonar.projectKey=devops_task "
                }
            }
        }

        stage('Dependency Check') {
            steps {
                script {
                    
                     sh 'npm audit --audit-level=high || true'
                }
            }
        }



        stage('Docker Build') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker build -t $ECR_REPO:$IMAGE_TAG .
                    docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                    """
                }
            }
        }

        // stage('Trivy Scan') {
        //     steps {
        //         sh "trivy image --exit-code 0 --severity HIGH,CRITICAL $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"
        //     }
        // }

        // stage('Push to ECR') {
        //     steps {
        //         sh "docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"
        //     }
        // }

        // stage('Terraform Check EKS') {
        //     steps {
        //         dir('infra/terraform') {   // path where Terraform scripts are stored
        //             sh """
        //             terraform init
        //             terraform validate
        //             terraform output eks_cluster_endpoint
        //             """
        //         }
        //     }
        // }

        // stage('Update Helm Chart') {
        //     steps {
        //         script {
        //             sh """
        //             git clone $HELM_REPO helm-chart
        //             cd helm-chart
        //             sed -i 's|image: .*|image: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG|g' values.yaml
        //             git config user.email "jenkins@ci.com"
        //             git config user.name "jenkins"
        //             git commit -am "Update image to $IMAGE_TAG"
        //             git push origin main
        //             """
        //         }
        //     }
        // }

        // stage('Trigger ArgoCD Deployment') {
        //     steps {
        //         script {
        //             // Sync ArgoCD with updated Helm chart
        //             sh """
        //             argocd login <ARGOCD_SERVER> --username <ARGOCD_USER> --password <ARGOCD_PASS> --insecure
        //             argocd app sync logo-server
        //             """
        //         }
        //     }
        // }
    }

    post {
        always {
            cleanWs()
        }
    }
}
