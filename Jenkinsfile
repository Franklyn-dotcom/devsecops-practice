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
	
       stage('build image') {
	  steps {
	    withCredentials([usernamePassword(credentialsId: 'dockerhub-credential', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
	             sh 'docker build -t franklyn27181/my-devops-projects:devsecops .'
		     sh "echo $PASS | docker login -u $USER --password-stdin"
		     sh 'docker push franklyn27181/my-devops-projects:devsecops'  
		}
	   }

	   post {
	     success {
		echo "Succesfully built"
	  	echo "Logging out of the container registry!"
	  	sh 'docker logout'
	     }
	   }
	}
    }
}
