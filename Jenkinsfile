pipeline {
  agent any
  tools {
      terraform "Terraform"
  }

  stages {
    stage('Git Checkout') {
      steps {
        git branch: 'main', credentialsId: 'Github details', url: 'https://github.com/Koventhan28/cicd-pipeline'
      }
    }

    stage('Terraform Init') {
      steps {
        sh label: '', script: 'terraform init'
      }
    }
    
    stage('Terraform apply') {
      steps {
        sh label: '', script: 'terraform apply --auto-approve'
      }
    }
  }
}