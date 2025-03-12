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


GitHub Actions
1. Crea un workflow CI para el proyecto de frontend - OBLIGATORIO
Copia el directorio .start-code/hangman-front en el directorio raíz del mismo repositorio que usaste para las clases de GitHub Actions. Si no lo creaste, crea un repositorio nuevo.

Después crea un nuevo workflow que se dispare cuando haya cambios en el proyecto hangman-front y exista una nueva pull request (deben darse las dos condiciones a la vez). El workflow ejecutará las siguientes operaciones:

Build del proyecto de front
Ejecutar los unit tests
2. Crea un workflow CD para el proyecto de frontend - OBLIGATORIO
Crea un nuevo workflow que se dispare manualmente y haga lo siguiente:

Crear una nueva imagen de Docker
Publicar dicha imagen en el container registry de GitHub
3. Crea un workflow que ejecute tests e2e - OPCIONAL
Crea un workflow que se lance de la manera que elijas y ejecute los tests e2e que encontrarás en este enlance. Puedes usar Docker Compose o Cypress action para ejecutar los tests.

Como ejecutar los tests e2e
Tanto el front como la api se deben estar corriendo
docker run -d -p 3001:3000 hangman-api
docker run -d -p 8080:8080 -e API_URL=http://localhost:3001 hangman-front
Los tests se ejecutan desde el directorio hangman-e2e/e2e haciendo uso del comando npm run open
cd hangman-e2e/e2e
npm run open
4. Crea una custom JavaScript Action - OPCIONAL
Crea una custom JavaScript Action que se ejecute cada vez que una issue tenga la etiqueta motivate. La acción deberá pintar por consola un mensaje motivacional. Puedes usar esta API gratuita. Puedes encontrar más información de como crear una custom JS action en este enlace.

curl https://type.fit/api/quotes