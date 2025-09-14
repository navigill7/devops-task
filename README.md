🚀 DevOps CI/CD Pipeline on AWS EKS

This project implements a complete CI/CD pipeline for deploying a Node.js application on Amazon EKS with quality checks, security scans, continuous deployment via ArgoCD, and monitoring using CloudWatch.

🌐 Accessing the Application

```bash
http://a7f33f404cb9b4b79b52bab0a83c7269-1994389429.us-east-1.elb.amazonaws.com:3000/
```

📌 Architecture Diagram

<img width="1144" height="684" alt="image" src="https://github.com/user-attachments/assets/93af0831-5392-4b94-b928-6080beb5c283" />

⚙️ CI/CD Pipeline Stages

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/836446fb-97e4-47df-b3ae-2fca48896c9d" />


1️⃣ Code Quality Analysis - SonarQube

Runs static code analysis on every commit.

Detects bugs, vulnerabilities, code smells, and test coverage gaps.

2️⃣ Security Analysis - OWASP Dependency Check

Scans dependencies for known CVEs (security vulnerabilities).

Generates a report before build continues.

3️⃣ Docker Image Build

Builds a lightweight Node.js application image using multi-stage Dockerfile.

Ensures smaller and optimized container image.

4️⃣ Push Image to AWS ECR

Logs in to AWS ECR using aws ecr get-login-password.

Pushes the built Docker image with commit-based tags.

5️⃣ Update Helm Chart

Updates the values.yaml file in Helm chart repo with the new image tag.

Commits changes back to GitHub (GitOps model).

6️⃣ Continuous Deployment with ArgoCD

📌 Architecture Diagram
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/535860c5-60a7-41e1-950e-19a689885309" />

ArgoCD watches Helm repo.

Detects new image tag update.

Syncs and deploys new version of app to Amazon EKS.

7️⃣ Deployment on EKS

Application runs inside Kubernetes Pods.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/435c1c29-62c4-4572-b3b9-c727853cc39a" />


Exposed via LoadBalancer Service (AWS ELB) on port 3000.

8️⃣ Monitoring with CloudWatch

Integrated CloudWatch Container Insights for metrics (CPU, Memory, Network).

Fluent Bit pushes application logs to CloudWatch Logs.

Alerts can be configured for failures, latency, or high resource usage.

🔧 Tech Stack

CI/CD Tool → Jenkins / GitHub Actions

Code Quality → SonarQube

Security Scan → OWASP Dependency Check

Containerization → Docker

Registry → AWS Elastic Container Registry (ECR)

Orchestration → Amazon Elastic Kubernetes Service (EKS)

GitOps → ArgoCD

Monitoring → AWS CloudWatch (Metrics + Logs + Alarms)

🚀 How It Works

Developer pushes code → triggers pipeline.

Pipeline runs SonarQube + OWASP Dependency Check.

Docker image is built & pushed to ECR.

Helm chart values.yaml updated with new image tag.

ArgoCD detects change → deploys app to EKS.

Application accessible via AWS LoadBalancer DNS.

Metrics & logs available in CloudWatch Container Insights.



# Logo Server

A simple Express.js web server that serves the Swayatt logo image.

## What is this app?

This is a lightweight Node.js application built with Express.js that serves a single logo image (`logoswayatt.png`) when accessed through a web browser. When you visit the root URL, the server responds by displaying the Swayatt logo.

## Prerequisites

- Node.js (version 12 or higher)
- npm (Node Package Manager)

## Installation

1. Clone or download this repository
2. Navigate to the project directory:
   ```bash
   cd "devops task"
   ```
3. Install dependencies:
   ```bash
   npm install
   ```

## How to Start the App

Run the following command:
```bash
npm start
```

The server will start and display:
```
Server running on http://localhost:3000
```

## Usage

Once the server is running, open your web browser and navigate to:
```
http://localhost:3000
```

You will see the Swayatt logo displayed in your browser.

## Project Structure

```
├── app.js              # Main server file
├── package.json        # Project dependencies and scripts
├── logoswayatt.png     # Logo image file
└── README.md          # This file
```

## Technical Details

- **Framework**: Express.js
- **Port**: 3000
- **Endpoint**: GET `/` - serves the logo image
- **File served**: `logoswayatt.png`
