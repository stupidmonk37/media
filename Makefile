# make up → starts all services
# make up-sonarr → starts only sonarr
# make down-radarr → stops just radarr
# make restart-jellyfin → restarts only jellyfin
# make logs-homarr → shows recent logs for homarr
# make status → see status of all
# make status-prowlarr → status of just prowlarr

# List of services
SERVICES = jellyfin sonarr radarr prowlarr jellyseerr homarr

# Base path
BASE_DIR = $(HOME)/media-server

# === Batch Commands ===
.PHONY: up down restart pull logs status

up:
	@for svc in $(SERVICES); do \
		echo "⬆️  Starting $$svc..."; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml up -d; \
	done

down:
	@for svc in $(SERVICES); do \
		echo "⬇️  Stopping $$svc..."; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml down; \
	done

restart:
	@for svc in $(SERVICES); do \
		echo "🔁 Restarting $$svc..."; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml restart; \
	done

pull:
	@for svc in $(SERVICES); do \
		echo "⬇️  Pulling $$svc..."; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml pull; \
	done

logs:
	@for svc in $(SERVICES); do \
		echo "📋 Logs for $$svc:"; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml logs --tail=10; \
	done

status:
	@for svc in $(SERVICES); do \
		echo "📦 Status of $$svc:"; \
		docker compose -f $(BASE_DIR)/$$svc/docker-compose.yml ps; \
	done

# === Per-service Commands (like: make up-sonarr) ===
define SERVICE_COMMANDS
.PHONY: up-$(1) down-$(1) restart-$(1) pull-$(1) logs-$(1) status-$(1)

up-$(1):
	@echo "⬆️  Starting $(1)..."
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml up -d

down-$(1):
	@echo "⬇️  Stopping $(1)..."
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml down

restart-$(1):
	@echo "🔁 Restarting $(1)..."
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml restart

pull-$(1):
	@echo "⬇️  Pulling $(1)..."
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml pull

logs-$(1):
	@echo "📋 Logs for $(1):"
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml logs --tail=50

status-$(1):
	@echo "📦 Status of $(1):"
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml ps
endef

$(foreach svc,$(SERVICES),$(eval $(call SERVICE_COMMANDS,$(svc))))
