VOLUME_PATH=/home/cogata/data
COMPOSE=./srcs/docker-compose.yml

all: permission env-check config up

permission:
	@/usr/bin/echo -e '\033[1;33mChecking sudo permission...\033[0m'
	@sudo /usr/bin/echo -e '\033[1;32mSudo working...\033[0m'

env-check:
	@if [ ! -f ./srcs/.env ]; then \
		sudo echo -e '\033[1;31mError: .env file not found in ./srcs/.\033[0m'; \
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

up:
	@if [ -z "$$(docker-compose -f ${COMPOSE} ps 2> /dev/null | grep Up)" ]; then \
		docker-compose -f ${COMPOSE} up; \
	else \
		echo "There is containers up, please KILL them :)"; \
	fi

down:
	@if [ -n "$$(docker-compose -f ${COMPOSE} images -q 2> /dev/null)" ]; then \
		docker-compose -f ${COMPOSE} down; \
	else \
		echo "No images to delete!"; \
	fi

prune: down
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi
	@sudo rm -fr ${VOLUME_PATH}/*
	@docker system prune -f -a

re: prune all

.PHONY: all permission env-check config up down prune re