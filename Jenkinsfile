pipeline {
    agent any
    parameters { string(name: 'ORIG_BUILD_NUMBER', defaultValue: '${BUILD_NUMBER}', description: '') }
      tools {
       maven 'maven'
	 	jdk 'jdk17'
    }
	environment {
		RESPOSITORY_NAME = "quay.io/mohammed_zuhairal-najjar/mzm"
		HELM_TEMPLATE_NAME = "demo-app-test-from-starter"
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
			sh 'mvn clean install'
		}
	    }
        stage('OWASP Dependency-Check Vulnerabilities') {
               steps {
               dependencyTrackPublisher artifact: '${WORKSPACE}/target/bom.json', autoCreateProjects: true, dependencyTrackApiKey: '', dependencyTrackFrontendUrl: '', dependencyTrackUrl: '', projectId: '', projectName: 'spring-app1', projectVersion: '${BUILD_NUMBER}', synchronous: true, warnOnViolationWarn: true
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
	stage('Build docker image') {
		steps {
		    script {
				sh 'docker build --rm -t $RESPOSITORY_NAME:${DOCKER_IMAGE_NAME}$_V${IMAGE_TAG} . '
		         }
	              }
           }
       stage('Scan Docker Image Trivy') {
            steps {
                script {
                    // Run Trivy to scan the Docker image
	      sh 'curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl > ${WORKSPACE}/html.tpl'
	      sh 'trivy image --vuln-type os,library --format template --template @${WORKSPACE}/html.tpl -o ${WORKSPACE}/image-scan.html $RESPOSITORY_NAME:${DOCKER_IMAGE_NAME}$_V${IMAGE_TAG}'

                }
            }
       }
       stage('Publish Trivy security image report') {
            steps {
		publishReport displayType: 'absolute', name: 'app1-container-scan-report', provider: json(id: '${BUILD_NUMBER}', pattern: '${WORKSPACE}/trivy-report.json')
		publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '', reportFiles: 'image-scan.html', reportName: 'Trivy-image-scanning-report', reportTitles: 'Trivy-image-scanning-report', useWrapperFileDirectly: true])
		}
	    }
	stage('Respository login') {
		steps {
		    script {
				sh 'echo $RESPOSITORY_CREDENTIALS_PSW | docker login -u $RESPOSITORY_CREDENTIALS_USR --password-stdin $RESPOSITORY_NAME'
			        sh 'echo $RESPOSITORY_CREDENTIALS_PSW'
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
	  stage('Helm templates update downstream job') {
		steps {
		   build job: 'Helm-CI-JOBS/Build-HELM-package',  parameters: [string(name: 'ORIG_BUILD_NUMBER', value: "${BUILD_NUMBER}")]
			}
		}
	stage('clean workspace'){
		steps {
        cleanWs()
		}
	    }

        }
    post {
         always {
             echo 'The Job ${JOB_NAME} is triggered with build number : ${BULD_NUMBER}'
         }
         success {
mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "Success CI: Project name -> ${env.JOB_NAME}", to: "mzm.najjar@gmail.com";
         }
         failure {
             echo 'This will run only if Pipeline Failed'
             // Sending an email notification with details about the failure
             mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "mzm.najjar@gmail.com";
         }
         unstable {
             mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "unstable CI: Project name -> ${env.JOB_NAME}", to: "mzm.najjar@gmail.com";

         }
     }
        
     }
