pipeline {
    agent any
      tools {
       maven 'maven'
	 	jdk 'jdk17'
    }
	environment {
		RESPOSITORY_NAME = "quay.io/mohammed_zuhairal-najjar/mzm"
		DOCKER_IMAGE_NAME = "mysql-springboot-example-with-healthcheck"
		IMAGE_TAG= "${env.BUILD_NUMBER}"
		RESPOSITORY_CREDENTIALS= credentials ('redhatquay')
	}
     stages {
	stage('Git checkout Build '){
		steps {
           git branch: 'main', credentialsId: 'github', url: 'https://github.com/mohammedzuhair214/jenkins-ci-spring-boot-example-app.git'
		}
	    }
	stage('maven Build '){
		steps {
			sh 'mvn clean install -DskipTests'
		}
	    }
        stage('build && SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonarqube-on-premis') {
                    // Optionally use a Maven environment you've configured already
                    withMaven(maven:'maven') {
                        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=spring-boot-example-app -Dsonar.projectName='spring-boot-example-app'"
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        */stage('OWASP Dependency-Check Vulnerabilities') {
               steps {
               dependencyTrackPublisher artifact: 'bom.json', autoCreateProjects: false, dependencyTrackApiKey: '', dependencyTrackFrontendUrl: '', dependencyTrackUrl: '', projectId: '', projectName: 'spring-my-sql-example', projectVersion: '${BUILD_NUMBER}', synchronous: true
      }
    }
	stage('Build docker image') {
		steps {
		    script {
				sh 'docker build --rm -t $RESPOSITORY_NAME:${DOCKER_IMAGE_NAME}$_V${IMAGE_TAG} . '
		         }
	              }
           }
	stage('Respository login') {
		steps {
		    script {
				sh 'echo $RESPOSITORY_CREDENTIALS_PSW | docker login -u $RESPOSITORY_CREDENTIALS_USR --password-stdin $RESPOSITORY_NAME'
	              }
           }
	}
	stage('push image tag') {
		steps {
		    script {
				sh 'docker push $RESPOSITORY_NAME:${DOCKER_IMAGE_NAME}$_V${IMAGE_TAG} '
		         }
	              }
           }
	stage('Respository logout') {
		steps {
		    script {
				sh 'docker logout'
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
