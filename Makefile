INTRA_LOGIN := maolivei
DOMAIN_NAME := $(INTRA_LOGIN).42.fr

VOLUME_DIRS := wordpress mariadb
VOLUME_PATH := $(addprefix /home/$(INTRA_LOGIN)/data/, $(VOLUME_DIRS))

DOCKER_PATH := ./srcs

DOCKER_COMPOSE_FILE := $(DOCKER_PATH)/docker-compose.yml

all: up

up: | $(VOLUME_PATH)
	@cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee /etc/hosts > /dev/null
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build

d: detach

detach: | $(VOLUME_PATH)
	@cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee /etc/hosts > /dev/null
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build --detach

down:
	docker-compose --file $(DOCKER_COMPOSE_FILE) down

$(VOLUME_PATH):
	sudo mkdir -p $@

clean: down
	docker-compose --file $(DOCKER_COMPOSE_FILE) rm -f -s -v

fclean: clean
	sudo rm -rf $(VOLUME_PATH)
	@(docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q)) 2> /dev/null || \
	return 0

re: fclean all

.PHONY: all up d detach down clean fclean re
