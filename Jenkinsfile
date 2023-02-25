pipeline{
       agent any
       stages{
              stage('Checkout Pipeline code '){
                steps {
                echo "cloning the git repository "
                 sh ('git clone https://github.com/Koventhan28/cicd-pipeline')
                }
                }
              stage('terraform init and planning '){
                steps {
                echo "Terraform initialinzing the necessary plugins"
                sh ('terraform init')
                echo "terraform plan "
                sh ('terraform plan ')
                }
                }
              stage('Terraform Deploy'){
                steps {
                echo "Terraform  action is ${action}"
                sh ('terraform ${action} - auto-approve')
                 }
                }
              stage('Monitor'){
                 ........
                }
       }
}