## Build the Jenkins Docker Image
```shell
docker build -t jenkins-docker .
```

## Create Docker Network
```shell
docker network create jenkins
```

## Run the container
Run in powershell
```bash
sh run_docker.sh
```

### Run - Windows Troubleshots
You have to run this has "inline" command in Powershell or CommandPrompt. Git Bash generates wrong path variables for CERT_PATH. 

## Get the initial Password
```shell
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## Routing Docker Agens with Docker Desktop
Run in powershell
```shell
docker run -d --restart=always --name=jenkins-socat --network jenkins -p 127.0.0.1:2376:2375 -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
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

## Jenkins Configuration
### 1. Git Host Key Verification Configuration
``Dashboard > Jenkins verwalten > Security > Host Key Verification Strategy > "Accept First Connection"``

### 2. Add SSH Credentials
``Dashboard > Jenkins verwalten > Zugangsdaten > System > Globale Zugangsdaten``

#### Jenkins GitHub
1. Create new SSH Credential with ``private key (id_rsa)``
2. Add  ``public key (id_rsa.pub)`` to [GitHub](https://github.com/settings/keys)

##### Troubleshooting
###### "Bad owner or permissions on /var/jenkins_home/.ssh/config"
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

#### Jenkins Deployment Key
1. Create new SSH Credential with ``private key (id_rsa)``
2. Add  ``public key (id_rsa.pub)`` to ``<user>/.ssh/authorized_keys``

#### 3. Docker Cloud
1. ``Dashboard > Jenkins verwalten > Clouds > New cloud``
2. Cloud
    - ``Cloud Name = cloud``
    - ``Type = docker``
3. Add Cloud Details
   - ``Docker Host URI = tcp://<jenkins-socat-ip>:<jenkins-socat-port>`` (look at "Get Ip Address from socat server")
   - ``Enabled = true``
4. Add Agent Template
    - ``Label``
    - ``Enabled = true``
    - ``Name``
    - ``Docker Image``
    - ``Instance Capacity = 2``

## Update Jenkins
1.Change version in Dockerfile
```
# Dockerfile
FROM jenkins/jenkins:2.XXX
```
2.Shutdown and remove Docker Container
```bash
docker stop jenkins
```
```bash
docker rm jenkins
```
3.Build new Jenkins Image
```bash
docker build -t jenkins-docker .
```
4.Run the Container
```bash
# Run in powershell bc of path problems with cert path
sh run_docker.sh
```

## Use docker.sh to create, tag, push and run image to DockerHub
### Powershell
```bash
sh docker.sh
```
