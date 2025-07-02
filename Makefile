# List of services
SERVICES = jellyfin sonarr radarr prowlarr jellyseerr homarr

# Base path
BASE_DIR = $(HOME)/media-server

# === Batch Commands ===
.PHONY: up down restart pull logs status

up:
	@for service in $(SERVICES); do \
		echo "⬆️  Starting $$service..."; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml up -d; \
	done

down:
	@for service in $(SERVICES); do \
		echo "⬇️  Stopping $$service..."; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml down; \
	done

restart:
	@for service in $(SERVICES); do \
		echo "🔁 Restarting $$service..."; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml restart; \
	done

pull:
	@for service in $(SERVICES); do \
		echo "⬇️  Pulling $$service..."; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml pull; \
	done

logs:
	@for service in $(SERVICES); do \
		echo "📋 Logs for $$service:"; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml logs --tail=10; \
	done

status:
	@for service in $(SERVICES); do \
		echo "📦 Status of $$service:"; \
		docker compose -f $(BASE_DIR)/$$service/docker-compose.yml ps; \
	done

# === Per-service Commands ===
define SERVICE_COMMANDS
up-$(1):
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml up -d

down-$(1):
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml down

restart-$(1):
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml restart

logs-$(1):
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml logs --tail=50

status-$(1):
	docker compose -f $(BASE_DIR)/$(1)/docker-compose.yml ps
endef

$(foreach svc,$(SERVICES),$(eval $(call SERVICE_COMMANDS,$(svc))))

