# Makefile pour la gestion des services
SHELL := /usr/bin/env bash
.SILENT:

# Variables
DOCKER_COMPOSE = docker compose --env-file .env -f caddy/docker-compose.yml
DOCKER_COMPOSE_PHP = docker compose --env-file .env -f services/php/docker-compose.yml
DOCKER_COMPOSE_GO = docker compose --env-file .env -f services/go/docker-compose.yml
DOCKER_COMPOSE_PYTHON = docker compose --env-file .env -f services/python/docker-compose.yml
DOCKER_COMPOSE_DATABASE = docker compose --env-file .env -f services/database/docker-compose.yml

# Couleurs
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m

PRINT=printf

.PHONY: help start stop restart status logs clean init

help:
	$(PRINT) "$(GREEN)Commandes disponibles:$(NC)\n"
	$(PRINT) "\n$(YELLOW)Initialisation:$(NC)\n"
	$(PRINT) "  make init       - Initialise l'environnement (première fois)\n"
	$(PRINT) "\n$(YELLOW)Gestion complète:$(NC)\n"
	$(PRINT) "  make start      - Démarre tous les services\n"
	$(PRINT) "  make stop       - Arrête tous les services\n"
	$(PRINT) "  make restart    - Redémarre tous les services\n"
	$(PRINT) "  make status     - Affiche le statut des services\n"
	$(PRINT) "  make logs       - Affiche les logs de tous les services\n"
	$(PRINT) "\n$(YELLOW)Services individuels:$(NC)\n"
	$(PRINT) "  make start-caddy  - Démarre Caddy\n"
	$(PRINT) "  make start-php    - Démarre PHP\n"
	$(PRINT) "  make start-go     - Démarre le service Go\n"
	$(PRINT) "  make start-django - Démarre le service Django\n"
	$(PRINT) "  make start-db     - Démarre la base de données\n"
	$(PRINT) "\n$(YELLOW)Arrêt individuel:$(NC)\n"
	$(PRINT) "  make stop-go      - Arrête le service Go\n"
	$(PRINT) "  make stop-django  - Arrête le service Django\n"
	$(PRINT) "  make stop-db      - Arrête la base de données\n"
	$(PRINT) "\n$(YELLOW)Maintenance:$(NC)\n"
	$(PRINT) "  make clean        - Nettoie tout (containers, volumes, networks)\n"
	$(PRINT) "  make rebuild      - Rebuild et redémarre tous les services\n"

init:
	$(PRINT) "$(BLUE)Initialisation de l'environnement...$(NC)\n"
	if [ ! -f .env ]; then \
		cp .env.example .env 2>/dev/null || $(PRINT) "$(YELLOW)Créez un fichier .env$(NC)\n"; \
	fi
	$(PRINT) "$(GREEN)✅ Environnement initialisé$(NC)\n"
	$(PRINT) "$(YELLOW)N'oubliez pas de configurer votre fichier .env$(NC)\n\n"

start: start-db start-php  start-go start-django start-caddy
	$(PRINT) "$(GREEN)✅ Tous les services sont démarrés$(NC)\n\n"

stop: stop-caddy stop-php stop-db stop-go stop-django
	$(PRINT) "$(YELLOW)🛑 Tous les services sont arrêtés$(NC)\n\n"

restart: stop start
	$(PRINT) "$(BLUE)🔄 Tous les services sont redémarrés$(NC)\n\n"

status:
	$(PRINT) "$(BLUE)=== Statut des services ===$(NC)\n"
	$(PRINT) "$(YELLOW)Caddy:$(NC)\n"
	$(DOCKER_COMPOSE) ps 2>/dev/null || echo "Non démarré"
	$(PRINT) "\n$(YELLOW)Base de données:$(NC)\n"
	$(DOCKER_COMPOSE_DATABASE) ps 2>/dev/null || echo "Non démarré"
	$(PRINT) "\n$(YELLOW)PHP:$(NC)\n"
	$(DOCKER_COMPOSE_PHP) ps 2>/dev/null || echo "Non démarré"
	$(PRINT) "\n$(YELLOW)Go:$(NC)\n"
	$(DOCKER_COMPOSE_GO) ps 2>/dev/null || echo "Non démarré"
	$(PRINT) "\n$(YELLOW)Django:$(NC)\n"
	$(DOCKER_COMPOSE_PYTHON) ps 2>/dev/null || echo "Non démarré"
	$(PRINT) "\n"

start-caddy:
	$(PRINT) "$(GREEN)Démarrage de Caddy...$(NC)\n"
	$(DOCKER_COMPOSE) up -d
	$(PRINT) "$(GREEN)✅ Caddy démarré$(NC)\n"

start-php:
	$(PRINT) "$(GREEN)Démarrage de PHP...$(NC)\n"
	$(DOCKER_COMPOSE_PHP) up -d
	$(PRINT) "$(GREEN)✅ PHP démarré$(NC)\n"
	if [ -f .env ]; then \
		source .env; \
		echo "Sites PHP disponibles sur:"; \
		echo "  - laravel.$${DOMAIN}"; \
		echo "  - symfony.$${DOMAIN}"; \
		echo "  - wordpress.$${DOMAIN}"; \
		echo "  - php.$${DOMAIN}"; \
		echo "  - html.$${DOMAIN}"; \
		echo "  - landing.$${DOMAIN}"; \
	else \
		echo "Sites PHP disponibles (configurer .env pour les domaines)"; \
	fi
	$(PRINT) "\n"

start-go:
	$(PRINT) "$(GREEN)Démarrage du service Go...$(NC)\n"
	$(DOCKER_COMPOSE_GO) up -d
	$(PRINT) "$(GREEN)✅ Service Go démarré$(NC)\n"
	if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: go.$${DOMAIN}"; \
	else \
		echo "Service Go démarré"; \
	fi
	$(PRINT) "\n"

start-django:
	$(PRINT) "$(GREEN)Démarrage du service Django...$(NC)\n"
	$(DOCKER_COMPOSE_PYTHON) up -d
	$(PRINT) "$(GREEN)✅ Service Django démarré$(NC)\n"
	if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: django.$${DOMAIN}"; \
	else \
		echo "Service Django démarré"; \
	fi
	$(PRINT) "\n"

start-db:
	$(PRINT) "$(GREEN)Démarrage de la base de données...$(NC)\n"
	$(DOCKER_COMPOSE_DATABASE) up -d
	$(PRINT) "$(GREEN)✅ Base de données démarrée$(NC)\n"
	if [ -f .env ]; then \
		source .env; \
		echo "phpMyAdmin disponible sur: phpmyadmin.$${DOMAIN}"; \
	else \
		echo "phpMyAdmin démarré"; \
	fi
	$(PRINT) "\n"

stop-caddy:
	$(PRINT) "$(YELLOW)Arrêt de Caddy + PHP...$(NC)\n"
	$(DOCKER_COMPOSE) down

stop-php:
	$(PRINT) "$(YELLOW)Arrêt du service PHP...$(NC)\n"
	$(DOCKER_COMPOSE_PHP) down

stop-go:
	$(PRINT) "$(YELLOW)Arrêt du service Go...$(NC)\n"
	$(DOCKER_COMPOSE_GO) down

stop-django:
	$(PRINT) "$(YELLOW)Arrêt du service Django...$(NC)\n"
	$(DOCKER_COMPOSE_PYTHON) down

stop-db:
	$(PRINT) "$(YELLOW)Arrêt de la base de données...$(NC)\n"
	$(DOCKER_COMPOSE_DATABASE) down

clean:
	$(PRINT) "$(RED)Nettoyage de tous les services...$(NC)\n"
	-$(DOCKER_COMPOSE) down -v --remove-orphans 2>/dev/null
	-$(DOCKER_COMPOSE_PHP) down -v --remove-orphans 2>/dev/null
	-$(DOCKER_COMPOSE_GO) down -v --remove-orphans 2>/dev/null
	-$(DOCKER_COMPOSE_PYTHON) down -v --remove-orphans 2>/dev/null
	-$(DOCKER_COMPOSE_DATABASE) down -v --remove-orphans 2>/dev/null
	$(PRINT) "$(GREEN)✅ Nettoyage terminé$(NC)\n\n"

rebuild: clean
	$(PRINT) "$(BLUE)Rebuild de tous les services...$(NC)\n"
	$(DOCKER_COMPOSE) build --no-cache
	$(DOCKER_COMPOSE_PHP) build --no-cache
	$(DOCKER_COMPOSE_GO) build --no-cache
	$(DOCKER_COMPOSE_PYTHON) build --no-cache
	$(DOCKER_COMPOSE_DATABASE) build --no-cache
	$(MAKE) start
	$(PRINT) "$(GREEN)✅ Rebuild terminé$(NC)\n\n"

logs-caddy:
	$(DOCKER_COMPOSE) logs -f

logs-php:
	$(DOCKER_COMPOSE_PHP) logs -f

logs-go:
	$(DOCKER_COMPOSE_GO) logs -f

logs-django:
	$(DOCKER_COMPOSE_PYTHON) logs -f

logs-db:
	$(DOCKER_COMPOSE_DATABASE) logs -f

check:
	$(PRINT) "$(BLUE)=== Vérification de l'environnement ===$(NC)\n"
	which docker > /dev/null && $(PRINT) "$(GREEN)✅ Docker installé$(NC)\n" || $(PRINT) "$(RED)❌ Docker non installé$(NC)\n"
	docker compose version > /dev/null 2>&1 && $(PRINT) "$(GREEN)✅ Docker Compose installé$(NC)\n" || $(PRINT) "$(RED)❌ Docker Compose non installé$(NC)\n"
	test -f .env && $(PRINT) "$(GREEN)✅ Fichier .env présent$(NC)\n\n" || $(PRINT) "$(YELLOW)⚠️  Fichier .env manquant - exécutez 'make init'$(NC)\n\n"
