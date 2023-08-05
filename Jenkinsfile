pipeline {
  agent any

//   environment {
//     deploymentName = "devsecops"
//     containerName = "devsecops-container"
//     serviceName = "devsecops-svc"
//     imageName = "siddharth67/numeric-app:${GIT_COMMIT}"
//     applicationURL="http://devsecops-demo.eastus.cloudapp.azure.com"
//     applicationURI="/increment/99"
//       trivyDir = "/devsecops-numeric-app/dockerfiles"
//   }

  stages {

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }

    stage('Unit Tests - JUnit and JaCoCo') {
      steps {
        sh "mvn test"
      }
    }

    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
    }

 //    stage('SonarQube - SAST') {
 //      steps {
 //        withSonarQubeEnv('SonarQube') {
 //          sh "mvn sonar:sonar \
	// 	              -Dsonar.projectKey=numeric-application \
	// 	              -Dsonar.host.url=http://devsecops-demo.eastus.cloudapp.azure.com:9000"
 //        }
 //        timeout(time: 2, unit: 'MINUTES') {
 //          script {
 //            waitForQualityGate abortPipeline: true
 //          }
 //        }
 //      }
 //    }

	stage('Vulnerability Scan - Docker') {
      steps {
        parallel(
        	// "Dependency Scan": {
        		// sh "mvn dependency-check:check"
			// },
			"Trivy Scan":{
			    dir('dockerfiles/'){
				sh "bash trivy-docker-image-scan.sh"
				echo "Scanning ... Done!"
			    }
			},
			 "OPA Conftest":{
				 sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security-test.rego Dockerfile'
			 }	
      	)
      }
    }
    

    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: 'dockerhub-credential', url: ""]){
		    sh "printenv"
		    sh "docker build -t franklyn27181/my-devops-projects:2.0 ."
		    sh 'docker push franklyn27181/my-devops-projects:2.0'
		}  
      }
    }

 //    stage('Vulnerability Scan - Kubernetes') {
 //      steps {
 //        parallel(
 //          "OPA Scan": {
 //            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
 //          },
 //          "Kubesec Scan": {
 //            sh "bash kubesec-scan.sh"
 //          },
 //          "Trivy Scan": {
 //            sh "bash trivy-k8s-scan.sh"
 //          }
 //        )
 //      }
 //    }

 //    stage('K8S Deployment - DEV') {
 //      steps {
 //        parallel(
 //          "Deployment": {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "bash k8s-deployment.sh"
 //            }
 //          },
 //          "Rollout Status": {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "bash k8s-deployment-rollout-status.sh"
 //            }
 //          }
 //        )
 //      }
 //    }

 //    stage('Integration Tests - DEV') {
 //      steps {
 //        script {
 //          try {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "bash integration-test.sh"
 //            }
 //          } catch (e) {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "kubectl -n default rollout undo deploy ${deploymentName}"
 //            }
 //            throw e
 //          }
 //        }
 //      }
 //    }

 //   stage('OWASP ZAP - DAST') {
 //      steps {
 //        withKubeConfig([credentialsId: 'kubeconfig']) {
 //          sh 'bash zap.sh'
 //        }
 //      }
 //    }

 //    stage('Prompte to PROD?') {
 //      steps {
 //        timeout(time: 2, unit: 'DAYS') {
 //          input 'Do you want to Approve the Deployment to Production Environment/Namespace?'
 //        }
 //      }
 //    }

 //    stage('K8S CIS Benchmark') {
 //      steps {
 //        script {

 //          parallel(
 //            "Master": {
 //              sh "bash cis-master.sh"
 //            },
 //            "Etcd": {
 //              sh "bash cis-etcd.sh"
 //            },
 //            "Kubelet": {
 //              sh "bash cis-kubelet.sh"
 //            }
 //          )

 //        }
 //      }
 //    }

     stage('K8S Deployment - PROD') {
      steps {
        parallel(
          "Deployment": {
            echo "Replace the kubernetes manifest image with the docker image and applying the file"
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "sed -i 's#replace#franklyn27181/my-devops-projects:2.0#g' k8s_deployment_service.yaml"
              sh "kubectl apply -f k8s_deployment_service.yaml"
            }
          }
        //   "Rollout Status": {
        //     withKubeConfig([credentialsId: 'kubeconfig']) {
        //       sh "bash k8s-PROD-deployment-rollout-status.sh"
        //     }
        //   }
        )
      }
    }

 //    stage('Integration Tests - PROD') {
 //      steps {
 //        script {
 //          try {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "bash integration-test-PROD.sh"
 //            }
 //          } catch (e) {
 //            withKubeConfig([credentialsId: 'kubeconfig']) {
 //              sh "kubectl -n prod rollout undo deploy ${deploymentName}"
 //            }
 //            throw e
 //          }
 //        }
 //      }
 //    }   
   
//       stage('Testing Slack - 1') {
//       steps {
//           sh 'exit 0'
//       }
//     }

//    stage('Testing Slack - Error Stage') {
//       steps {
//           sh 'exit 0'
//       }
//     }

  }

  post { 
        always { 
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        //   publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report'])
        
 		  // //Use sendNotifications.groovy from shared library and provide current build result as parameter 
     //      //sendNotification currentBuild.result
        }

        // success {
        // 	script {
		//         /* Use slackNotifier.groovy from shared library and provide current build result as parameter */  
		//         env.failedStage = "none"
		//         env.emoji = ":white_check_mark: :tada: :thumbsup_all:" 
		//         sendNotification currentBuild.result
		//       }
        // }

	    // failure {
	    // 	script {
		// 	  //Fetch information about  failed stage
		//       def failedStages = getFailedStages( currentBuild )
	    //       env.failedStage = failedStages.failedStageName
	    //       env.emoji = ":x: :red_circle: :sos:"
		//       sendNotification currentBuild.result
		//     }	
	    // }
    }

}
