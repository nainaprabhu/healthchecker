pipeline {
  agent any
  environment {
    POSTGRES_HOST = 'localhost'
    POSTGRES_USER = 'myuser'
  }

  stages {
    stage('Git Push!') {
      steps {
        sh 'git config --global credential.helper cache'
        sh 'git config --global push.default simple'

checkout([
    $class: 'GitSCM',
    branches: [[name: "master"]],
    extensions: [
        [$class: 'CloneOption', noTags: true, reference: '', shallow: true]
    ],
    submoduleCfg: [],
    userRemoteConfigs: [[ credentialsId: '', url: "https://github.com/nainaprabhu/healthchecker.git"]
    ]
])
        dir("healthchecker") { 
        
           sh "touch test.txt"
           sh "git status"
           sh "git branch"
           sh 'git config --global user.email "naina.v.prabhu@gmail.com"'
           sh 'git config --global user.name "Naina"'
           sh 'git add --all'
           sh 'git commit -m "Merged develop branch to master"'
           sh "git push -u origin master"
        }
        }
      }
    }
  }

