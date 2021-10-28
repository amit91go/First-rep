The port number for each of the service has been changed in the routes/index.js file in the web project.

Each service has the DockerFile and a common docker-compose file 
Run the below docker command to build and deploy to the containers
docker-compose -f project_path/docker-compose.yml up -d

to deploy services using kubernetes run the below commands once the images are created with the above docker command.

Run the below commands with minikube.

$ kubectl apply -f project_path/architectures/searvices/
$ kubectl apply -f project_path/architectures/

The architectures folder contains the yaml file for each of the service.