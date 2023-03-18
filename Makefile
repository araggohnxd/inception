INTRA_LOGIN := maolivei
DOMAIN_NAME := $(INTRA_LOGIN).42.fr

VOLUME_DIRS := wordpress mariadb
VOLUME_PATH := $(addprefix /home/$(INTRA_LOGIN)/data/, $(VOLUME_DIRS))

DOCKER_PATH := ./srcs

DOCKER_COMPOSE_FILE := $(DOCKER_PATH)/docker-compose.yml

all: up

up: | $(VOLUME_PATH)
	@sudo chmod +w /etc/hosts && \
	sudo cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	sudo echo "127.0.0.1 $(DOMAIN_NAME)" > /etc/hosts
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build

d: detach

detach: | $(VOLUME_PATH)
	@sudo chmod +w /etc/hosts && \
	sudo cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	sudo echo "127.0.0.1 $(DOMAIN_NAME)" > /etc/hosts
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build --detach

down:
	docker-compose --file $(DOCKER_COMPOSE_FILE) down

$(VOLUME_PATH):
	mkdir -p $@

clean: down
	docker-compose --file $(DOCKER_COMPOSE_FILE) rm --volumes --stop --force

fclean: clean
	docker system prune --volumes --all --force

re: fclean all

.PHONY: all up d detach down clean fclean re
