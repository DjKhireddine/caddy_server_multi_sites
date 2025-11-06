# Makefile pour la gestion des services
SHELL := /usr/bin/env bash

# Variables
DOCKER_COMPOSE = docker compose --env-file .env -f caddy/docker-compose.yml
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
	@echo "$(GREEN)Commandes disponibles:$(NC)"
	@echo ""
	@echo "$(YELLOW)Initialisation:$(NC)"
	@echo "  make init       - Initialise l'environnement (première fois)"
	@echo ""
	@echo "$(YELLOW)Gestion complète:$(NC)"
	@echo "  make start       - Démarre tous les services"
	@echo "  make stop        - Arrête tous les services"
	@echo "  make restart     - Redémarre tous les services"
	@echo "  make status      - Affiche le statut des services"
	@echo "  make logs        - Affiche les logs de tous les services"
	@echo ""
	@echo "$(YELLOW)Services individuels:$(NC)"
	@echo "  make start-caddy - Démarre Caddy + PHP"
	@echo "  make start-go    - Démarre le service Go"
	@echo "  make start-django - Démarre le service Django"
	@echo "  make start-db    - Démarre la base de données"
	@echo ""
	@echo "$(YELLOW)Arrêt individuel:$(NC)"
	@echo "  make stop-go     - Arrête le service Go"
	@echo "  make stop-django - Arrête le service Django"
	@echo "  make stop-db     - Arrête la base de données"
	@echo ""
	@echo "$(YELLOW)Maintenance:$(NC)"
	@echo "  make clean       - Nettoie tout (containers, volumes, networks)"
	@echo "  make rebuild     - Rebuild et redémarre tous les services"
	@echo ""

# Initialisation (première fois)
init:
	@echo "$(BLUE)Initialisation de l'environnement...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env 2>/dev/null || echo "$(YELLOW)Créez un fichier .env$(NC)"; \
	fi
	@echo "$(GREEN)✅ Environnement initialisé$(NC)"
	@echo "$(YELLOW)N'oubliez pas de configurer votre fichier .env$(NC)"

# Démarrage complet
start: start-caddy start-db start-go start-django
	@echo "$(GREEN)✅ Tous les services sont démarrés$(NC)"

# Arrêt complet
stop: stop-caddy stop-db stop-go stop-django
	@echo "$(YELLOW)🛑 Tous les services sont arrêtés$(NC)"

# Redémarrage complet
restart: stop start
	@echo "$(BLUE)🔄 Tous les services sont redémarrés$(NC)"

# Statut des services
status:
	@echo "$(BLUE)=== Statut des services ===$(NC)"
	@echo "$(YELLOW)Caddy + PHP:$(NC)"
	@$(DOCKER_COMPOSE) ps 2>/dev/null || echo "Non démarré"
	@echo ""
	@echo "$(YELLOW)Base de données:$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) ps 2>/dev/null || echo "Non démarré"
	@echo ""
	@echo "$(YELLOW)Go:$(NC)"
	@$(DOCKER_COMPOSE_GO) ps 2>/dev/null || echo "Non démarré"
	@echo ""
	@echo "$(YELLOW)Django:$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) ps 2>/dev/null || echo "Non démarré"

# Services individuels - Démarrage
start-caddy:
	@echo "$(GREEN)Démarrage de Caddy + PHP...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✅ Caddy + PHP démarrés$(NC)"
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
	@echo "$(GREEN)Démarrage du service Go...$(NC)"
	@$(DOCKER_COMPOSE_GO) up -d
	@echo "$(GREEN)✅ Service Go démarré$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: go.$${DOMAIN}"; \
	else \
		echo "Service Go démarré"; \
	fi

start-django:
	@echo "$(GREEN)Démarrage du service Django...$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) up -d
	@echo "$(GREEN)✅ Service Django démarré$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "Disponible sur: django.$${DOMAIN}"; \
	else \
		echo "Service Django démarré"; \
	fi

start-db:
	@echo "$(GREEN)Démarrage de la base de données...$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) up -d
	@echo "$(GREEN)✅ Base de données démarrée$(NC)"
	@if [ -f .env ]; then \
		source .env; \
		echo "phpMyAdmin disponible sur: phpmyadmin.$${DOMAIN}"; \
	else \
		echo "phpMyAdmin démarré"; \
	fi

# Services individuels - Arrêt
stop-caddy:
	@echo "$(YELLOW)Arrêt de Caddy + PHP...$(NC)"
	@$(DOCKER_COMPOSE) down

stop-go:
	@echo "$(YELLOW)Arrêt du service Go...$(NC)"
	@$(DOCKER_COMPOSE_GO) down

stop-django:
	@echo "$(YELLOW)Arrêt du service Django...$(NC)"
	@$(DOCKER_COMPOSE_PYTHON) down

stop-db:
	@echo "$(YELLOW)Arrêt de la base de données...$(NC)"
	@$(DOCKER_COMPOSE_DATABASE) down

# Maintenance
clean:
	@echo "$(RED)Nettoyage de tous les services...$(NC)"
	@-$(DOCKER_COMPOSE) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_GO) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_PYTHON) down -v --remove-orphans 2>/dev/null
	@-$(DOCKER_COMPOSE_DATABASE) down -v --remove-orphans 2>/dev/null
	@echo "$(GREEN)✅ Nettoyage terminé$(NC)"

rebuild: clean
	@echo "$(BLUE)Rebuild de tous les services...$(NC)"
	@$(DOCKER_COMPOSE) build --no-cache
	@$(DOCKER_COMPOSE_GO) build --no-cache
	@$(DOCKER_COMPOSE_PYTHON) build --no-cache
	@$(DOCKER_COMPOSE_DATABASE) build --no-cache
	@make start
	@echo "$(GREEN)✅ Rebuild terminé$(NC)"

# Commandes de développement
logs-caddy:
	@$(DOCKER_COMPOSE) logs -f

logs-go:
	@$(DOCKER_COMPOSE_GO) logs -f

logs-django:
	@$(DOCKER_COMPOSE_PYTHON) logs -f

logs-db:
	@$(DOCKER_COMPOSE_DATABASE) logs -f

# Vérification de l'installation
check:
	@echo "$(BLUE)=== Vérification de l'environnement ===$(NC)"
	@which docker > /dev/null && echo "$(GREEN)✅ Docker installé$(NC)" || echo "$(RED)❌ Docker non installé$(NC)"
	@docker compose version > /dev/null 2>&1 && echo "$(GREEN)✅ Docker Compose installé$(NC)" || echo "$(RED)❌ Docker Compose non installé$(NC)"
	@test -f .env && echo "$(GREEN)✅ Fichier .env présent$(NC)" || echo "$(YELLOW)⚠️  Fichier .env manquant - exécutez 'make init'$(NC)"
