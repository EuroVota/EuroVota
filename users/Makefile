identity := app-2

jarFile:= users-0.0.1-SNAPSHOT.jar
jarPath := ./build/libs/${jarFile}
appName := users
appPath := /home/ubuntu/${appName}

install: createDir clean build upload dockerComposeBuild up
deploy:  clean build upload down dockerComposeBuild up dockerImagesPrune ps

clean:
	@echo "--------------------"
	@echo "Cleaning up..."
	@echo "--------------------"
	@./gradlew clean

build:
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

upload:
	@echo "--------------------"
	@echo "Uploading..."
	@echo "--------------------"
	@scp ${jarPath} ${identity}:${appPath} && \
		scp ./docker-compose.yml ${identity}:${appPath} && scp ./Dockerfile ${identity}:${appPath} && scp ./.env ${identity}:${appPath}

up:
	@echo "--------------------"
	@echo "Starting..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker-compose up -d"

down:
	@echo "--------------------"
	@echo "Downing..."
	@echo "--------------------"
	@ssh ${identity} "cd ${appPath} && docker-compose down"

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
