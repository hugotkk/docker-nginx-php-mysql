# Makefile for Docker Nginx PHP Composer MySQL

include .env

# MySQL
MYSQL_DUMPS_DIR=data/db/dumps
MYSQL_CONTAINER=$(shell docker inspect -f '{{.Name}}' $(shell docker-compose ps -q db))

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  composer-up         Update PHP dependencies with composer"
	@echo "  docker-start        Create and start containers"
	@echo "  docker-stop         Stop and clear all services"
	@echo "  gen-certs           Generate SSL certificates"
	@echo "  logs                Follow log output"
	@echo "  mysql-dump          Create backup of all databases"
	@echo "  mysql-restore       Restore backup of all databases"

docker-start:
	docker-compose up -d

docker-stop:
	@docker-compose down -v

gen-certs:
	@docker run --rm -v $(shell pwd)/etc/ssl:/certificates -e "SERVER=$(NGINX_HOST)" jacoelho/generate-certificate

logs:
	@docker-compose logs -f

mysql-dump:
	@mkdir -p $(MYSQL_DUMPS_DIR)
	@docker exec $(MYSQL_CONTAINER) mysqldump -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" --all-databases > $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null
	@make resetOwner

mysql-restore:
	@docker exec -i $(MYSQL_CONTAINER) mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" < $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null

resetOwner:
	@$(shell chown -Rf $(SUDO_USER):$(shell id -g -n $(SUDO_USER)) $(MYSQL_DUMPS_DIR) "$(shell pwd)/etc/ssl" "$(shell pwd)/web/app" 2> /dev/null)
