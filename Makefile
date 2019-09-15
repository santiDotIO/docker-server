include .env

make up:
	docker-compose up -d;
	@for filename in ./applications/*/docker-compose.yml; do \
        $(cd $$filename && docker-compose up -d;); \
    done

# required env
# APP_NAME = use to name directory
# IMAGE = Docker image to use
new-application:
	@if [ -z ${APP_NAME} ]; then echo "\n**********\nMust set APP_NAME,\nmake new-application APP_NAME=my-app\n**********\n" && exit 1; fi
	make app-dir
	make generate-env-file
	make generating-docker-compose

app-dir:
	@echo "Creating application directory: applications/${APP_NAME}"
	@mkdir -p $(PWD)/applications/${APP_NAME}

generate-env-file:
	@echo "Generating .env file"
	@touch $(PWD)/applications/${APP_NAME}/.env
	@echo "DOCKER_IMAGE='${IMAGE}'" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "HOST_NAME=${HOST_NAME}" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "VIRTUAL_HOST='${APP_NAME}'" >> $(PWD)/applications/${APP_NAME}/.env

generating-docker-compose:
	@echo "Generating $(PWD)/applications/${APP_NAME}/docker-compose.yml file"
	@cp assets/docker-compose.yml.example $(PWD)/applications/${APP_NAME}/docker-compose.yml