# Entregable del Módulo de Containers

El entregable para superar el módulo se compone de 2 ejercicios. Los pasos para complentarlos se indican a continuación.

El primer paso sería clonar este repositorio, lo que creará la carpeta _lemoncode-challenge_ de la cual colgarán todos los archivos necesarios para ejecutar los ejercicios.

## Ejercicio 1

### Preparativos

1.- Crear una red llamada lemoncode-challenge: `docker network create lemoncode-challenge`

2.- Crear un volumen llamado db_data: `docker volume create db_data`

### Imagen personalizada para la base de datos 

Crearemos el siguiente fichero _Dockerfile_, que ubicaremos en la ruta _lemoncode-challenge/repository_:

&nbsp;&nbsp;FROM mongo:latest  
&nbsp;&nbsp;EXPOSE 27017  
&nbsp;&nbsp;ENV MONGO_INITDB_ROOT_USERNAME=myadmin  
&nbsp;&nbsp;ENV MONGO_INITDB_ROOT_PASSWORD=mypass  

Desde la ruta indicada anteriormente, ejecutamos el comando para crear la imagen, a la que llamamos _repository:1.0_: `docker build . --tag repository:1.0`

Comprobaremos que se ha creado mediante `docker images`

### Imagen personalizada para el backend

Crearemos el siguiente fichero _Dockerfile_, que ubicaremos en la ruta _lemoncode-challenge/backend/backend_:

&nbsp;&nbsp;FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build  
&nbsp;&nbsp;WORKDIR /app  
&nbsp;&nbsp;COPY "backend.csproj" ./  
&nbsp;&nbsp;RUN dotnet restore  
&nbsp;&nbsp;COPY . ./  
&nbsp;&nbsp;RUN dotnet build "backend.csproj" -c Release -o ./build/  
&nbsp;&nbsp;RUN dotnet publish -c Release -o ./publish/  

&nbsp;&nbsp;FROM mcr.microsoft.com/dotnet/core/aspnet:3.1  
&nbsp;&nbsp;ENV MONGO_URI="mongodb://myadmin:mypass@myrepository"  
&nbsp;&nbsp;WORKDIR /app  
&nbsp;&nbsp;EXPOSE 80  
&nbsp;&nbsp;COPY --from=build /app/publish/ .  
&nbsp;&nbsp;ENTRYPOINT ["dotnet", "backend.dll"]

Desde la ruta indicada anteriormente, ejecutamos el comando para crear la imagen, a la que llamamos _backend:1.0_: `docker build . --tag backend:1.0`.

Comprobaremos que se ha creado mediante `docker images`.

Como es un backend dotNet, hemos utilizado una imagen para compilar y publicar el projecto, copiando los archivos resultantes de ese proceso en la imagen definitiva _backend:1.0_. Podemos borrar la imagen intermedia mediante el comando `docker image prune`.

En el Dockerfile, podemos ver, que el backend se conectará a un contenedor mongo al que llamaremos _myrepository_ y que debmos crear después con ese nombre.


### Imagen personalizada para el frontend

Crearemos el siguiente fichero _Dockerfile_, que ubicaremos en la ruta _lemoncode-challenge/frontend_:

&nbsp;&nbsp;FROM node:latest  
&nbsp;&nbsp;ENV NODE_ENV=production  
&nbsp;&nbsp;ENV REACT_APP_API_URL=http://localhost:5000/api/topics  
&nbsp;&nbsp;WORKDIR /frontend  
&nbsp;&nbsp;COPY ["package.json", "package-lock.json","./"]  
&nbsp;&nbsp;RUN npm install  
&nbsp;&nbsp;COPY . .  
&nbsp;&nbsp;EXPOSE 3000  
&nbsp;&nbsp;CMD ["npm", "start"]  

Desde la ruta indicada anteriormente, ejecutamos el comando para crear la imagen, a la que llamamos _frontend:1.0_: `docker build . --tag frontend:1.0`.

Comprobaremos que se ha creado mediante `docker images`

### Creación de los contenedores para ejecutar la aplicación.

1.- Contenedor mongo:

Este contenedor hará uso tanto de la network _lemoncode-challenge_ como del volumen _db_data_ que creamos al principio del proceso. Agregaremos el contenedor a la network y mapearemos el volumen a la ruta _/data/db_. Este contenedor no será accesible desde puerto alguno de nuestro host, por lo que no haremos port forwarding. Su nombre será _myrepository_:

`docker run -d --name myrepository --network lemoncode-challenge -v db_data:/data/db repository:1.0`

2.- Contenedor backend:

Este contenedor hará uso tanto la network _lemoncode-challenge_, agregándolo a la misma. Este contenedor será accesible desde el puerto 5000 de nuestro host, recibiendo por dicho puerto las peticiones desde el frontend. Como la aplicación backend está escuchando en el puerto 80 de su contenedor, tenemos que hacer port forwarding del puerto 5000 del host al 80 del contenedor. Su nombre será _mybackend_:

`docker run -d -p 5000:80 --name mybackend --network lemoncode-challenge backend:1.0`

3.- Contenedor frontend:

Este contenedor será accesible desde el puerto 3000 de nuestro host, recibiendo por dicho puerto las peticiones desde el cliente web. Como la aplicación frontend está escuchando en el puerto 3000 de su contenedor, tenemos que hacer port forwarding del puerto 3000 del host al 3000 del contenedor. Su nombre será _myfrontend_:

`docker run -d -p 3000:3000 --name myfrontend frontend:1.0`


### Accediendo a la aplicación.

Si todo ha ido como esperado, si accedemos a la url `http://localhost:3000` desde un navegador, debería mostrarse la pantalla del aplicativo de frontend:


![Screenshot Frontend](./lemoncode-challenge/resources/screenshotFrontend.jpg)

<br>

## Ejercicio 2

El objetivo de este ejercicio, una vez que tengamos las imágenes personalizadas creadas como indicado en las instrucciones del **Ejercicio 1**, es desplegar nuestro aplicativo y la creación del network, volumen y contenedores a través de compose.

Para ello, crearemos en la ruta _lemoncode-challenge/_ el siguiente fichero _docker-compose.yml_:

version: '3.8'  
services:  
&nbsp;&nbsp;repository:  
&nbsp;&nbsp;&nbsp;&nbsp;image: repository:1.0  
&nbsp;&nbsp;&nbsp;&nbsp;container_name: myrepository  
&nbsp;&nbsp;&nbsp;&nbsp;volumes:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- db_data:/data/db  
&nbsp;&nbsp;&nbsp;&nbsp;restart: always  
&nbsp;&nbsp;&nbsp;&nbsp;networks:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- lemoncode-challenge  
&nbsp;&nbsp;backend:  
&nbsp;&nbsp;&nbsp;&nbsp;image: backend:1.0  
&nbsp;&nbsp;&nbsp;&nbsp;container_name: mybackend  
&nbsp;&nbsp;&nbsp;&nbsp;ports:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- "5000:80"  
&nbsp;&nbsp;&nbsp;&nbsp;restart: always  
&nbsp;&nbsp;&nbsp;&nbsp;networks:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- lemoncode-challenge  
&nbsp;&nbsp;&nbsp;&nbsp;depends_on:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- repository  
&nbsp;&nbsp;frontend:  
&nbsp;&nbsp;&nbsp;&nbsp;image: frontend:1.0  
&nbsp;&nbsp;&nbsp;&nbsp;container_name: myfrontend  
&nbsp;&nbsp;&nbsp;&nbsp;ports:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- "3000:3000"  
&nbsp;&nbsp;&nbsp;&nbsp;restart: always  
&nbsp;&nbsp;&nbsp;&nbsp;depends_on:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- backend  
&nbsp;&nbsp;networks:  
&nbsp;&nbsp;&nbsp;&nbsp;lemoncode-challenge:  
&nbsp;&nbsp;&nbsp;&nbsp;name: lemoncode-challenge  
&nbsp;&nbsp;volumes:  
&nbsp;&nbsp;&nbsp;&nbsp;db_data:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;name: db_data  

A continuación, estando en la carpeta en la que se encuentra este fichero, ejecutaremos el siguiente comando para lanzarlo todo: `docker-compose up -d`.

Si todo ha ido como esperado, si accedemos a la url `http://localhost:3000` desde un navegador, debería mostrarse la pantalla del aplicativo de frontend, al igual que ocurría en el **Ejercicio 1**.

Si queremos pararlo todo, ejecutaremos: `docker-compose stop`.

Si queremos eliminarlo todo, inclusive el volumen, ejecutaremos: `docker-compose down --volumes`. Si no queremos borrar los volúmenes, omitiremos el flag `--volumes`.