class Globals {
  static boolean userInput = true
  static boolean didTimeout = false
}

pipeline {
  agent none
  stages {
    stage('Linting') {
      agent any
      steps {
        sh 'make lint'
      }
      post {
        always {
          sh 'make stop'
        }
      }

    }

    stage('Test') {
      agent any
      steps {
        sh 'make test'
      }
      post {
        always {
          sh 'make stop'
        }
      }
    }

    stage('Publish stable tag') {
      agent any
      when{
        branch 'master'
      }

      steps {
        publishStableTag()
      }
    }

    stage('Deploy to staging') {
      agent any
      when{
        branch 'master'
      }

      steps {
        deploy('staging')
      }
    }

    stage('Confirm deploy to production') {
      when {
        branch 'master'
        beforeAgent true
      }
      agent none
      steps {
        wait_for_input('production')
      }
    }

    stage('Deploy to production') {
      agent any
      when{
        branch 'master'
      }

      steps {
        deploy('production')
      }
    }
  }
}


def wait_for_input(deploy_environment) {
  if (deployCancelled()) {
    return;
  }
  try {
    timeout(time: 5, unit: 'MINUTES') {
      input "Do you want to deploy to ${deploy_environment}?"
    }
  } catch (err) {
    def user = err.getCauses()[0].getUser()

    if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
      Globals.didTimeout = true
      echo "Release window timed out, to deploy please re-run"
    } else {
      Globals.userInput = false
      echo "Aborted by: [${user}]"
    }
  }
}

def deploy(deploy_environment) {
  if(deployCancelled()) {
    return
  }

  echo "${deploy_environment}"
  // Jenkins does a fetch without tags during setup this means
  // we need to run git fetch again here before we can checkout stable
  sh('git fetch')
  sh('git checkout stable')

  docker.withRegistry(env.AWS_ECS_API_REGISTRY) {
    sh("eval \$(aws ecr get-login --no-include-email)")
    def appImage = docker.build(
      "govwifi/admin:${deploy_environment}",
      "--build-arg BUNDLE_INSTALL_FLAGS='--without test development' ."
    )
    appImage.push()
    runMigrations(deploy_environment)
  }

  if(deploy_environment == 'production') {
    deploy_environment = 'wifi'
  }

  sh("aws ecs update-service --cluster ${deploy_environment}-admin-cluster --service admin-${deploy_environment} --force-new-deployment")
}

def runMigrations(deploy_environment) {
  if(deploy_environment == 'production') {
    deploy_environment = 'wifi'
  }

  // we need to get the network config from our main service
  aws_service_cmd = "aws ecs describe-services --cluster '${deploy_environment}-admin-cluster' --service 'admin-${deploy_environment}'"
  network_config = sh(returnStdout: true, script: "${aws_service_cmd} --output json --query 'services[0].networkConfiguration'").trim()
  launch_type = sh(returnStdout: true, script: "${aws_service_cmd} --output text --query 'services[0].launchType'").trim()
  sh("aws ecs run-task --cluster '${deploy_environment}-admin-cluster' --task-definition  'admin-task-${deploy_environment}' --count 1 --overrides '{ \"containerOverrides\": [{ \"name\": \"admin\", \"command\": [\"bundle\", \"exec\", \"rake\", \"db:migrate\"] }] }' --launch-type '${launch_type}' --network-configuration '${network_config}'")
}

def publishStableTag() {
  sshagent(credentials: ['govwifi-jenkins']) {
    sh('export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"')
    sh("git tag -f stable HEAD")
    sh("git push git@github.com:alphagov/govwifi-admin.git --force --tags")
  }
}

def deployCancelled() {
  if(Globals.didTimeout || Globals.userInput == false) {
    return true
  }
}
