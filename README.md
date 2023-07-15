## Build the Jenkins Docker Image
```shell
docker build -t jenkins-docker .
```

## Create Docker Network
```shell
docker network create jenkins
```

## Run the container
```shell
docker run --name jenkins \
  --restart=on-failure \
  --detach \
  --privileged \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH="/certs/client" \
  --env DOCKER_TLS_VERIFY=1 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --publish 8080:8080 \
  --publish 50000:50000 \
  jenkins-docker
```

### Run - Windows Troubleshots
You have to run this has "inline" command in Powershell or CommandPrompt. Git Bash generates wrong path variables for CERT_PATH. 

## Get the initial Password
```shell
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## Routing Docker Agens with Docker Desktop
```shell
docker run -d \
  --restart=always \
  --name=jenkins-socat \
  --network jenkins \
  -p 127.0.0.1:2376:2375 \
  -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
```

### Get Ip Address from socat server
```shell
docker inspect jenkins-socat | grep IPAddress
```

### Docker Cloud Agent
```
# Docker Host URI
tcp://<IPAddress>:2375
```

## Add id_rsa.pub to GitHub SSH
