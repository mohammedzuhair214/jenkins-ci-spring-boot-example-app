pipeline {
    agent any
      tools {
       maven 'maven'
	 	jdk 'jdk17'
    }
	environment {
		DOCKER_IMAGE_NAME = "quay.io/mohammed_zuhairal-najjar/mzm:mysql-springboot-example-with-healthcheck"
		IMAGE_TAG= "${env.BUILD_NUMBER}"
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
				sh "docker build --rm -t ${DOCKER_IMAGE_NAME}$V${IMAGE_TAG} . "
		         }
	              }
           }
	stage('push image tag') {
		steps {
		    script {

				withCredentials([string(credentialsId: 'redhatquay', variable: 'password')]) {
				sh 'docker login -u mohammed_zuhairal-najjar -p ${password} quay.io/mohammed_zuhairal-najjar/mzm'
				sh 'docker push ${DOCKER_IMAGE_NAME}$V${IMAGE_TAG}'
		         }
	              }
           }
	}
	stage('clean workspace'){
		steps {
        cleanWs()
		}
	    }

        }
        
     }
