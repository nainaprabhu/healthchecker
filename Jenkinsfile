pipeline {
  agent any
  environment {
    POSTGRES_HOST = 'localhost'
    POSTGRES_USER = 'myuser'
  }

  stages {
    stage('Git Push!') {
      steps {
        script {
           sh "touch test.txt"
           sh 'git config --global user.email "naina.v.prabhu@gmail.com"'
           sh 'git config --global user.name "Naina"'
           sh 'git add --all'
           sh 'git commit -m "Merged develop branch to master"'
           sh "git push origin master"
        }
      }
    }
  }
}
