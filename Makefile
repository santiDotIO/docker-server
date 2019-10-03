include .env

up:
	@echo "bringing main docker-compose up"
	@docker-compose up -d

	@for filename in ./applications/*; do \
		echo "bringing $$filename up"; \
        (cd $$filename && docker-compose up -d); \
    done

down: 
	@for filename in ./applications/*; do \
		echo "bringing $$filename down"; \
        (cd $$filename && docker-compose down); \
    done	
	@echo "bringing main docker-compose down"
	@docker-compose down

update:
	@echo "Updating main services"
	@git pull
	@docker-compose pull
	
	@for filename in ./applications/*; do \
		echo "Updating $$filename down"; \
        (cd $$filename && docker-compose pull); \
    done
	@make up
	@make clean

clean:
	@echo "Removing untagged images"
	docker rmi $(docker images -f "dangling=true" -q)

# required env
# APP_NAME = use to name directory
# IMAGE = Docker image to use
new:
	@if [ -z ${APP_NAME} ]; then echo "\n**********\nMust set APP_NAME,\nmake new-application APP_NAME=my-app\n**********\n" && exit 1; fi
	
	@echo "Creating application directory: applications/${APP_NAME}"
	@mkdir -p $(PWD)/applications/${APP_NAME}
	
	@echo "Generating .env file"
	@touch $(PWD)/applications/${APP_NAME}/.env
	@echo "DOCKER_IMAGE=${IMAGE}" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "HOST_NAME=${HOST_NAME}" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" >> $(PWD)/applications/${APP_NAME}/.env
	@echo "VIRTUAL_HOST=${APP_NAME}" >> $(PWD)/applications/${APP_NAME}/.env


	@echo "Generating $(PWD)/applications/${APP_NAME}/docker-compose.yml file"
	@cp assets/docker-compose.yml.example $(PWD)/applications/${APP_NAME}/docker-compose.yml