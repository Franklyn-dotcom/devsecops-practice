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
	    sh 'Building images'
	    withCredentials([usernamePassword(credentialsId: 'dockerhub-credential', passwordVariable: 'PASS', usernameVariable: 'USER')]){
		    sh 'docker build -t franklyn27181/my-devops-projects:2.0 .'
		    sh "echo $PASS | docker login -u $USER --password-stdin"
		    sh 'docker push franklyn27181/my-devops-projects:2.0'
		}  
 	  }

	}
    }
}
