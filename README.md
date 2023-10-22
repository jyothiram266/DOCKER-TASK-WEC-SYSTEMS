## Project name : Containerization

## Description
1. Containerize this mern-stack-apllication (https://github.com/puranikvinit/mern-application) using Docker.
2. Use Docker Compose to bring up all services together Expose only the required services.
3. Created a K8s deployment object for the services such that they can communicate with each other in a cluster. (Used minikube)
4. Write a Github Actions workflow to Build and Push Docker images to DockerHub from the GitHub repository.

## Table of Contents
  - Cloning the mern-stack-application locally
  - Building the frontend and backend separate Docker images
  - Composing two docker images into docker-compose file
  - Kubernetes Deployment(using minikube)
  - Github workflow Action
## Cloning the Repository
``` bash 
git clone https://github.com/puranikvinit/mern-application.git
```
## Building the Docker Image
1.Created a two differnt Dockerfile one is for frontend and other is for backend with the configuration given below to build an image and run it on container.
  - Frontend Dockerfile
  
  '

     FROM node:17 
     WORKDIR /app/frontend
     COPY package*.json .
     RUN npm install
     COPY . .
     CMD ["npm","run","dev"]
     EXPOSE 5173 '
  - Backend Dockerfile

   '
    
    FROM node:17
    WORKDIR /app/backend
    COPY package*.json ../
    RUN npm install
    COPY . .
    EXPOSE 5000
    CMD ["npm", "start"] '

 2. Composing the two docker file into docker-compose.yml file with the configured given below to run web-application and database on the same network.
```
version: '3'
services:
  backend:
    build:
      context: .
    ports:
      - "5000:5000"
    depends_on:
      - mongo 
    environment:
      #-  MONGO_URI="mongodb//mon-project-wee:monproject@monprojectwee.brqps.mongodb.net/monprojectWee?retryWrites=true&w=majority"
      - MONGO_URI=mongodb://student:nitk@mongo:27017/admin


  frontend:
    build:
      context: ./frontend
    ports:
      - "5173:5173"

  mongo:
    image: mongo:latest
    ports:
      - "27018:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: student
      MONGO_INITDB_ROOT_PASSWORD: nitk
      MONGO_INITDB_DATABASE: mongodb
```


3. To run docker compose file 
``` bash
  docker compose up -bulid
```
  As the container is running but webpage doesn't load in the browser due to there is bug in the source code to fix that,adding the line ``` "dev": "vite --host" ```  in frontend/package.json, again build the image and web-site works correctly as show below
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-17-35.png?raw=true)
  
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-17-43.png?raw=true)
  
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/assets/112464539/e79f283e-01ee-42dc-b7f4-321dd4c12e03)

## Kubernates deployment
 1. For creating the kubernates manifest file . used Kompose to convert the dockerfile into kunernates manifest file
 ``` bash
   kompose convert -f docker-compose.yaml
 ```
   ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-23-18.png?raw=true)
  -It will create three deployments files (frontend,endend,mongo) ans three services files (frontend,endend,mongo) 
  
  3. To run k8s deployments we use minikube . run the following commands
  ``` bash
   minikube start --profile webapp
```
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-25-13.png?raw=true)
4. To run that depolyment files and services files we use kubect1 tool. run the following commands

``` bash
   kubectl apply -f backend-deployment.yaml
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f mongo-deployment.yaml 
   kubectl apply -f backend-service.yaml
   kubectl apply -f frontend-service.yaml
   kubectl apply -f mongo-service.yaml
```
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-27-16.png?raw=true)
5. Check whenther the services and deployments are running . run the following commands
``` bash
   kubect1 get deployments
   kunect1 ger service
   curl http://frontend
```
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-30-07.png?raw=true)
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-32-43.png?raw=true)
  ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-32-57.png?raw=true0)
## Github Workflow
 - Created .yml file for github actions and configured it as shown below
``` bash
    name: Build and Push Docker Images

on:
  push:
    branches:
      - main 

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v2

    - name: Login to Docker Hub
      run: |
        docker login -u ${{ secrets.DOCKERHUB_USERNAME }} -p ${{ secrets.DOCKERHUB_PASSWORD }}
      env:
        DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
        DOCKERHUB_PASSWORD: ${{ secrets.DOCKERHUB_PASSWORD }}

    - name: Build and Push Docker Images
      run: |
        docker-compose -f docker-compose.yml build
        docker-compose -f docker-compose.yml push
```
 ![image](https://github.com/jyothiram266/DOCKER-TASK-WEC-SYSTEMS/blob/main/screenshots/Screenshot%20from%202023-10-22%2010-36-55.png?raw=true)

