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
           
           sh 'git tag -a tagName -m "Your tag comment"'
sh 'git merge develop'
sh 'git commit -am "Merged develop branch to master'
sh "git push origin master"
        }
      }
    }
  }
}
