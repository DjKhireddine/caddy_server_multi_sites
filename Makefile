# Makefile pour la gestion des services
SHELL := /usr/bin/env bash

# Variables
DOCKER_COMPOSE = docker compose --env-file .env -f caddy/docker-compose.yml
DOCKER_COMPOSE_PHP = docker compose --env-file .env -f services/php/docker-compose.yml
DOCKER_COMPOSE_GO = docker compose --env-file .env -f services/go/docker-compose.yml
DOCKER_COMPOSE_PYTHON = docker compose --env-file .env -f services/python/docker-compose.yml
DOCKER_COMPOSE_DATABASE = docker compose --env-file .env -f services/database/docker-compose.yml

# Couleurs pour une meilleure lisibilité
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

.PHONY: help start stop restart status logs clean init

# Aide par défaut
help:
	printf "$(GREEN)Commandes disponibles:$(NC)"
	printf ""
	printf "$(YELLOW)Initialisation:$(NC)"
	printf "  make init       - Initialise l'environnement (première fois)"
	printf ""
	printf "$(YELLOW)Gestion complète:$(NC)"
	printf "  make start       - Démarre tous les services"
	printf "  make stop        - Arrête tous les services"
	printf "  make restart     - Redémarre tous les services"
	printf "  make status      - Affiche le statut des services"
	printf "  make logs        - Affiche les logs de tous les services"
	printf ""
	printf "$(YELLOW)Services individuels:$(NC)"
	printf "  make start-caddy - Démarre Caddy"
	printf "  make start-php - Démarre PHP"
	printf "  make start-go    - Démarre le service Go"
	printf "  make start-django - Démarre le service Django"
	printf "  make start-db    - Démarre la base de données"
	printf ""
	printf "$(YELLOW)Arrêt individuel:$(NC)"
	printf "  make stop-go     - Arrête le service Go"
	printf "  make stop-django - Arrête le service Django"
	printf "  make stop-db     - Arrête la base de données"
	printf ""
	printf "$(YELLOW)Maintenance:$(NC)"
	printf "  make clean       - Nettoie tout (containers, volumes, networks)"
	printf "  make rebuild     - Rebuild et redémarre tous les services"
	printf ""

# Initialisation (première fois)
init:
	printf "$(BLUE)Initialisation de l'environnement...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env 2>/dev/null || echo "$(YELLOW)Créez un fichier .env$(NC)"; \
	fi
	printf "$(GREEN)✅ Environnement initialisé$(NC)"
	printf "$(YELLOW)N'oubliez pas de configurer votre fichier .env$(NC)\n\n"

# Démarrage complet
start: start-caddy start-php start-db start-go start-django
	printf "$(GREEN)✅ Tous les services sont démarrés$(NC)\n\n"

# Arrêt complet
stop: stop-caddy stop-php stop-db stop-go stop-django
	printf "$(YELLOW)🛑 Tous les services sont arrêtés$(NC)\n\n"

# Redémarrage complet
restart: stop start
	printf "$(BLUE)🔄 Tous les services sont redémarrés$(NC)\n\n"

# Statut des services
status:
	printf "$(BLUE)=== Statut des services ===$(NC)"
	printf "$(YELLOW)Caddy:$(NC)"
	@$(DOCKER_COMPOSE) ps 2>/dev/null || echo "Non démarré"
	printf ""
	printf "$(YELLOW)Base de données:$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) ps 2>/dev/null || echo "Non démarré"
	printf ""
	printf "$(YELLOW)PHP:$(NC)"
	@$(DOCKER_COMPOSE_PHP) ps 2>/dev/null || echo "Non démarré"
	printf ""
	printf "$(YELLOW)Go:$(NC)"
	@$(DOCKER_COMPOSE_GO) ps 2>/dev/null || echo "Non démarré"
	printf ""
	printf "$(YELLOW)Django:$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) ps 2>/dev/null || echo "Non démarré\n\n"

# Services individuels - Démarrage
start-caddy:
	printf "$(GREEN)Démarrage de Caddy...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	printf "$(GREEN)✅ Caddy démarré$(NC)"

start-php:
	printf "$(GREEN)Démarrage de PHP...$(NC)"
	@$(DOCKER_COMPOSE_PHP) up -d
	printf "$(GREEN)✅ PHP démarré$(NC)"
	@if [ -f .env ]; then \
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

start-go:
	printf "$(GREEN)Démarrage du service Go...$(NC)"
	@$(DOCKER_COMPOSE_GO) up -d
	printf "$(GREEN)✅ Service Go démarré$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: go.$${DOMAIN}"; \
	else \
		echo "Service Go démarré"; \
	fi

start-django:
	printf "$(GREEN)Démarrage du service Django...$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) up -d
	printf "$(GREEN)✅ Service Django démarré$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: django.$${DOMAIN}"; \
	else \
		echo "Service Django démarré"; \
	fi

start-db:
	printf "$(GREEN)Démarrage de la base de données...$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) up -d
	printf "$(GREEN)✅ Base de données démarrée$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "phpMyAdmin disponible sur: phpmyadmin.$${DOMAIN}"; \
	else \
		echo "phpMyAdmin démarré"; \
	fi

# Services individuels - Arrêt
stop-caddy:
	printf "$(YELLOW)Arrêt de Caddy + PHP...$(NC)"
	@$(DOCKER_COMPOSE) down

stop-php:
	printf "$(YELLOW)Arrêt du service PHP...$(NC)"
	@$(DOCKER_COMPOSE_PHP) down

stop-go:
	printf "$(YELLOW)Arrêt du service Go...$(NC)"
	@$(DOCKER_COMPOSE_GO) down

stop-django:
	printf "$(YELLOW)Arrêt du service Django...$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) down

stop-db:
	printf "$(YELLOW)Arrêt de la base de données...$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) down

# Maintenance
clean:
	printf "$(RED)Nettoyage de tous les services...$(NC)"
	@-$(DOCKER_COMPOSE) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_PHP) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_GO) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_PYTHON) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_DATABASE) down -v --remove-orphans 2>/dev/null
	printf "$(GREEN)✅ Nettoyage terminé$(NC)\n\n"

rebuild: clean
	printf "$(BLUE)Rebuild de tous les services...$(NC)"
	@$(DOCKER_COMPOSE) build --no-cache
	@$(DOCKER_COMPOSE_PHP) build --no-cache
	@$(DOCKER_COMPOSE_GO) build --no-cache
	@$(DOCKER_COMPOSE_PYTHON) build --no-cache
	@$(DOCKER_COMPOSE_DATABASE) build --no-cache
	@make start
	printf "$(GREEN)✅ Rebuild terminé$(NC)\n\n"

# Commandes de développement
logs-caddy:
	@$(DOCKER_COMPOSE) logs -f

logs-php:
	@$(DOCKER_COMPOSE_PHP) logs -f

logs-go:
	@$(DOCKER_COMPOSE_GO) logs -f

logs-django:
	@$(DOCKER_COMPOSE_PYTHON) logs -f

logs-db:
	@$(DOCKER_COMPOSE_DATABASE) logs -f

# Vérification de l'installation
check:
	printf "$(BLUE)=== Vérification de l'environnement ===$(NC)"
	@which docker > /dev/null && echo "$(GREEN)✅ Docker installé$(NC)" || echo "$(RED)❌ Docker non installé$(NC)"
	@docker compose version > /dev/null 2>&1 && echo "$(GREEN)✅ Docker Compose installé$(NC)" || echo "$(RED)❌ Docker Compose non installé$(NC)"
	@test -f .env && echo "$(GREEN)✅ Fichier .env présent$(NC)" || echo "$(YELLOW)⚠️  Fichier .env manquant - exécutez 'make init'$(NC)\n\n"
