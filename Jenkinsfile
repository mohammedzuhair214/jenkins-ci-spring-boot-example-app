pipeline {
    agent any
      tools {
       maven 'maven'
	 	jdk 'java'
    }
	environment {
		DOCKER_IMAGE_NAME = "quay.io/mohammed_zuhairal-najjar/mzm:mysql-springboot-example-with-healthcheck"
		DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
	}
     stages {
	stage('Git checkout Build '){
		steps {
           git branch: 'main', credentialsId: 'github', url: 'https://github.com/mohammedzuhair214/jenkins-ci-spring-boot-example-app.git'
		}
	    }
	stage('maven Build '){
		steps {
			sh 'mvn clean install package'
		}
	    }
	
	stage('Build docker image') {
		steps {
		    script {
				sh 'docker build --rm -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .	'
		         }
	              }
           }
        }
        
     }
