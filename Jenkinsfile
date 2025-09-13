pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = credentials('aws-account-id')  
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')

        ECR_REPO = "devops_task"
        SONARQUBE =  tool "SonarQube" 
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
                withSonarQubeEnv('SonarQube') {
                    sh '$SONARQUBE/bin/sonar-scanner  -Dsonar.projectName=devops_task -Dsonar.projectKey=devops_task'
                }
            }
        }

        // stage(' OWASP Dependency Check') {
        //     steps {
        //         dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }



        stage('Docker Build') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh "trivy image --exit-code 0 --severity HIGH,CRITICAL ${ECR_REPO}:${IMAGE_TAG}"
            }
        }

        stage('Push to ECR') {
            steps {
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
            }
        }

        // stage('Terraform Apply EKS Infra') {
        //     steps {
        //         dir("EKS_INFRA/eks") {
        //             withCredentials([
        //                 string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
        //                 string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
        //             ]) {
        //                 script {
        //                     sh """
        //                     export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
        //                     export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
        //                     export AWS_REGION=${AWS_REGION}
                            
        //                     terraform init -input=false
        //                     terraform validate
        //                     terraform plan -out=tfplan -input=false
        //                     terraform apply -input=false -auto-approve tfplan || true
        //                     terraform output eks_cluster_endpoint || echo 'EKS cluster not ready'
        //                     """
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Update Helm Chart') {
            steps {
                dir('Deployment') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'Github_Auth', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD'),
                                        string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT_ID')]) {
                            sh """
                            # Clone the Helm repository using HTTPS with credentials
                            git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/navigill7/devops-task.git helm-repo
                            cd helm-repo

                            # Navigate to the Deployment directory
                            cd Deployment || { echo "Error: Deployment directory not found"; exit 1; }

                            # Check if values.yaml exists
                            if [ ! -f values.yaml ]; then
                                echo "Error: values.yaml not found in Deployment directory"
                                exit 1
                            fi

                            # Update repository and tag in values.yaml
                            sed -i 's|repository:.*|repository: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}|g' values.yaml
                            sed -i 's|tag:.*|tag: "${IMAGE_TAG}"|g' values.yaml

                            # Configure git user
                            git config user.email "jenkins@ci.com"
                            git config user.name "Jenkins"

                            # Add, commit, and push changes
                            git add values.yaml
                            git commit -m "Update image to ${ECR_REPO}:${IMAGE_TAG}" || echo "No changes to commit"
                            git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/navigill7/devops-task.git ${env.BRANCH_NAME}
                            """
                        }
                    }
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
