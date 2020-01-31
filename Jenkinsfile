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
println InetAddress.localHost.hostAddress
        println "************************************************************"
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
  
  //dir("healthchecker") {         
           sh "echo 'this is a test' > test_${BUILD_NUMBER}.txt"
           sh "pwd"
           sh "ls"
           sh "git status"
           sh 'git config --global user.email "naina.v.prabhu@gmail.com"'
           sh 'git config --global user.name "Naina"'
           sh 'git add --all'
           sh 'git commit -m "Merged to master"'
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'MyGitHubID', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
           //sh "git push origin HEAD:master"
          sh " git push https://${GIT_USERNAME}:Pulsar%405686@github.com/nainaprabhu/healthchecker.git HEAD:master"
}
        // }
        }
      }
    }
  }

