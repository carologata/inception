VOLUME_PATH=/home/cogata/data
COMPOSE=./srcs/docker-compose.yml

all: permission-check env-check config up

permission-check:
	@/usr/bin/echo "Checking sudo permission..."
	@sudo /usr/bin/echo "Sudo working..."

env-check:
	@if [ ! -f ./srcs/.env ]; then \
		sudo echo "Error: .env file not found in ./srcs/."; \
		exit 1; \
	fi

config:
	@sudo chmod 666 /etc/hosts
	@if ! grep -q 'cogata' /etc/hosts; then \
		sudo echo '127.0.0.1 cogata.42.fr' >> /etc/hosts; \
	fi
	@if [ ! -d "${VOLUME_PATH}/wordpress-db" ]; then \
		sudo mkdir -p ${VOLUME_PATH}/wordpress-db; \
	fi
	@if [ ! -d "${VOLUME_PATH}/mariadb-db" ]; then \
		sudo mkdir -p ${VOLUME_PATH}/mariadb-db; \
	fi

# Starts the Docker containers defined in docker-compose.yml, builds images, and runs in detached mode.
up:
	@if [ -z "$$(docker-compose -f ${COMPOSE} ps 2> /dev/null | grep Up)" ]; then \
		docker-compose -f ${COMPOSE} up; \
	else \
		echo "Error: There is containers up, please kill them."; \
	fi

# The down target stops and completely removes the Docker containers, networks, and resources defined in your docker-compose.yml.
down:
	@if [ -n "$$(docker-compose -f ${COMPOSE} images -q 2> /dev/null)" ]; then \
		docker-compose -f ${COMPOSE} down; \
	else \
		echo "No images to delete."; \
	fi

# Prunes everything (images, networks, volumes, containers)
prune: down
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi
	@sudo rm -fr ${VOLUME_PATH}/*
	@docker system prune -f -a

# Starts the containers again
start:
	docker start nginx wordpress mariadb; 

# Stops running containers without removing them.
stop:
	docker stop nginx wordpress mariadb; 

# Stops and starts the containers again
restart:
	docker restart nginx wordpress mariadb; 

re: prune all

.PHONY: all permission-check env-check config up down prune re start stop restart 