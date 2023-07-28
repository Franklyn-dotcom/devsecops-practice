pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' 
            }
        }   



      stage("Sonarqube - SAST"){
        steps {
		sh "mvn sonar:sonar -Dsonar.projectKey=numeric_app -Dsonar.projectName='numeric_app' -Dsonar.host.url=http://74.220.26.11:9000 -Dsonar.token=sqp_50166ef5184090f720835b4e007c51c1dfc9644a"
		echo "again done"
	 }
      }
	
       stage('build image') {
	  steps {
	    echo 'Building images'
	    withCredentials([usernamePassword(credentialsId: 'dockerhub-credential', passwordVariable: 'PASS', usernameVariable: 'USER')]){
		    sh 'docker build -t franklyn27181/my-devops-projects:2.0 .'
		    sh "echo $PASS | docker login -u $USER --password-stdin"
		    sh 'docker push franklyn27181/my-devops-projects:2.0'
		}  
 	  }

	}

      stage('Kubernetes manifest') {
	 steps {
	    echo "Replace the kubernetes manifest image with the docker image and applying the file"
	    withKubeConfig([credentialsId: 'kubeconfig']) {
		sh "sed -i 's#replace#franklyn27181/my-devops-projects:2.0#g' k8s_deployment_service.yaml"
		sh "kubectl apply -f k8s_deployment_service.yaml"
	    }
	 }	
       }

      
    }
}
