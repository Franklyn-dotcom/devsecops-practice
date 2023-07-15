pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later. 
            }
        }   

      stage('Unit test') {
	  steps {
	    sh "mvn test"
	  }
	  post {
	    always{
		junit 'target/surefire-reports/*.xml'
	 	jacoco execPattern: 'target/jacoco.exec'
	    }
	  }	
       }


      stage('Pit mutatiion test '){
	  steps {
	     echo "checking pit test"
	     sh "mvn org.pitest:pitest-maven:mutationCoverage"     
	  }
	  post {
	    always {
		pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
	    }
	  }

       }

      stage("Sonarqube - SAST"){
        steps {
		mvn clean verify sonar:sonar \
  		-Dsonar.projectKey=numeric_application \
  		-Dsonar.projectName='numeric_application' \
  		-Dsonar.host.url=http://74.220.26.11:9000 \
		-Dsonar.token=sqp_7d8b9c9da05f4fff21eaff4f08deb855495fff7c
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
