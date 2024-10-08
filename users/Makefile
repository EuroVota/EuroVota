identity := app-2-test

aws_ecr_repo := 926033837002.dkr.ecr.us-east-1.amazonaws.com
docker_hub_repo := luisgamezdvp
jarFile:= users-0.0.1-SNAPSHOT.jar
jarPath := ./build/libs/${jarFile}
appName := users
appPath := /home/ubuntu/${appName}

build:   clean build-app
deploy:  build Build-DockerImage Tag-DockerImage login_aws Push-DockerImage login_aws_remote run ps logs
install: createDir deploy

push-app:   build Build-DockerImage Tag-DockerImage login_aws Push-DockerImage
push-app-amd64:   build Build-DockerImage-AMD64 Tag-DockerImage-AMD64 login_aws Push-DockerImage-AMD64

push-app-multi-aws:   build login_aws Push-DockerImage-Multi-to-AWS
push-app-multi:   build login_aws Push-DockerImage-Multi-to-Docker_Hub


login_aws:
	@echo "--------------------"
	@echo "Login aws ecr..."
	@echo "--------------------"
	@aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repo}

login_aws_remote:
	@echo "--------------------"
	@echo "Login aws ecr..."
	@echo "--------------------"
	@ssh ${identity} "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repo}"

clean:
	@echo "--------------------"
	@echo "Cleaning up..."
	@echo "--------------------"
	@./gradlew clean

build-app:
	@echo "--------------------"
	@echo "Building..."
	@echo "--------------------"
	@./gradlew build

assemble:
	@echo "--------------------"
	@echo "Assembling..."
	@echo "--------------------"
	@./gradlew assemble

createDir:
	@echo "--------------------"
	@echo "Creating directory..."
	@echo "--------------------"
	@ssh ${identity} "mkdir -p ${appPath}"

Build-DockerImage:
	@echo "--------------------"
	@echo "Building Docker image..."
	@echo "--------------------"
	@docker build -t ${appName} .

Build-DockerImage-AMD64:
	@echo "--------------------"
	@echo "Building Docker image... amd64"
	@echo "--------------------"
	@docker buildx build -t ${appName}:amd64 --platform linux/amd64 .

Push-DockerImage-Multi-to-Docker_Hub:
	@echo "--------------------"
	@echo "Building Docker image... amd64"
	@echo "--------------------"
	@docker buildx build --push -t ${docker_hub_repo}/${appName}:latest --platform linux/amd64,linux/arm64 .

Push-DockerImage-Multi-to-AWS:
	@echo "--------------------"
	@echo "Building Docker image... amd64"
	@echo "--------------------"
	@docker buildx build --push -t ${aws_ecr_repo}/${appName}:latest --platform linux/amd64,linux/arm64 .

Tag-DockerImage-AMD64:
	@echo "--------------------"
	@echo "Tagging Docker image... amd64"
	@echo "--------------------"
	@docker tag ${appName}:amd64 ${aws_ecr_repo}/${appName}:amd64

Tag-DockerImage:
	@echo "--------------------"
	@echo "Tagging Docker image..."
	@echo "--------------------"
	@docker tag ${appName}:latest ${aws_ecr_repo}/${appName}:latest

Push-DockerImage:
	@echo "--------------------"
	@echo "Pushing Docker image to ECR..."
	@echo "--------------------"
	@docker push ${aws_ecr_repo}/${appName}:latest

Push-DockerImage-AMD64:
	@echo "--------------------"
	@echo "Pushing Docker image to ECR..."
	@echo "--------------------"
	@docker push ${aws_ecr_repo}/${appName}:amd64

upload:
	@echo "--------------------"
	@echo "Uploading..."
	@echo "--------------------"
	@scp ${jarPath} ${identity}:${appPath} && \
		scp ./docker-compose.yml ${identity}:${appPath} && scp ./Dockerfile ${identity}:${appPath} && scp ./.env ${identity}:${appPath}

run:
	@echo "--------------------"
	@echo "Docker run..."
	@echo "--------------------"
	@ssh ${identity} "docker run -d -p 9002:9002 --restart unless-stopped --name ${appName} ${aws_ecr_repo}/${appName}:latest "

dockerImagesPrune:
	@echo "--------------------"
	@echo "Docker prune..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker image prune"

dockerComposeBuild:
	@echo "--------------------"
	@echo "Docker build..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker-compose build"

ps:
	@echo "--------------------"
	@echo "Docker ps..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker-compose ps"

logs:
	@echo "--------------------"
	@echo "Docker logs..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker logs --since 10m ${appName}"
