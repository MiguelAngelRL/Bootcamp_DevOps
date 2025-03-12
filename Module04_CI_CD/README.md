## Jenkins

### 1. Java project CI/CD using the Jenkins server as agent

* Use this [Dockerfile](./gradle.Dockerfile) to create the image __jenkins-bootcamp-gradle__ with gradle installed by running the following command:

  `docker build -t jenkins-bootcamp-gradle -f gradle.Dockerfile .`

* Run the container __jenkins-gradle__ mapping ports and creating a volume by running the following command:

  `docker run -d -p 8080:8080 -p 50000:50000 --volume jenkins-gradle-data:/var/jenkins_home --name jenkins-gradle jenkins-bootcamp-gradle`

* Go to [Jenkins server](http://localhost:8080) and configure it for the very first time, installing the suggested plugins. Also, create a global credentials with the username and personal access token you want Jenkins to use to clone the repo.
* Use this [Jenkinsfle](./Jenkinsfile.exercise1) to execute the `gradlew compileJava` and the `gradlew test` processes within the pipeline.
* Back to [Jenkins server](http://localhost:8080) and create a new pipeline item with the following settings:
  * Definition -> _Pipeline script from SCM_
  * SCM -> _Git_
  * Repository URL -> _https://github.com/MiguelAngelRL/Bootcamp_DevOps.git_
  * Credentials -> _the one you created previously_
  * Branch Specifier -> _*/main_
  * Script Path -> _Module04_CI_CD/jenkins/Jenkinsfile.exercise1_
* Once configured the pipeline, run it by clicking on __Build Now__ from the item dashboard.
* Inspect the [build console log](./Exercise1_Build_Console_Output%20.txt) to check that everything has been executed as expected.

### 2. Java project CI/CD using docker in docker as agent

* Use this [Dockerfile](./dockercli.Dockerfile) to create the image __jenkins-bootcamp-gradle__ with docker cli installed by running the following command:

  `docker build -t jenkins-bootcamp-dockercli -f dockercli.Dockerfile .`

* Use this [bash script file](./start_jenkins.sh) to create all the infrastructure we need (indicating the image name, the network name and the volumes) with the following command:

  `./start_jenkins.sh jenkins-bootcamp-dockercli jenkins-bootcamp jenkins-docker-certs jenkins-dockercli-data`

* Go to [Jenkins server](http://localhost:8080) and configure it for the very first time, installing the suggested plugins. Also:
  * Create a global credentials with the username and personal access token you want Jenkins to use to clone the repo.
  * Install the __Docker__ and __Docker Pipeline__ plugins. Restart the container after installation.
* Use this [Jenkinsfle](./Jenkinsfile.exercise2) to execute the `gradlew compileJava` and the `gradlew test` processes within the pipeline, using the `gradle:6.6.1-jre14-openj9` docker image for the docker in docker agent.
* Back to [Jenkins server](http://localhost:8080) and create a new pipeline item with the following settings:
  * Definition -> _Pipeline script from SCM_
  * SCM -> _Git_
  * Repository URL -> _https://github.com/MiguelAngelRL/Bootcamp_DevOps.git_
  * Credentials -> _the one you created previously_
  * Branch Specifier -> _*/main_
  * Script Path -> _Module04_CI_CD/jenkins/Jenkinsfile.exercise2_
* Once configured the pipeline, run it by clicking on __Build Now__ from the item dashboard.
* Inspect the [build console log](./Exercise2_Build_Console_Output%20.txt) to check that everything has been executed as expected.