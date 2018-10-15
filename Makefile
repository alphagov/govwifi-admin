BUNDLE_FLAGS = --build-arg BUNDLE_INSTALL_CMD='bundle install --jobs 20 --retry 5'
DOCKER_COMPOSE = docker-compose -f docker-compose.yml

ifdef DEPLOYMENT
	BUNDLE_FLAGS = --build-arg BUNDLE_INSTALL_CMD='bundle install --without test'
endif

ifndef JENKINS_URL
  DOCKER_COMPOSE += -f docker-compose.development.yml
endif

.PHONY: build
build:
	$(DOCKER_COMPOSE) build $(BUNDLE_FLAGS)

.PHONY: setup
setup: build
	$(DOCKER_COMPOSE) run --rm app ./bin/rails db:create db:schema:load db:seed

.PHONY: launch_db
launch_db:
	$(DOCKER_COMPOSE) up -d db
	$(DOCKER_COMPOSE) up -d rr_db
	./mysql/bin/wait_for_mysql
	./mysql/bin/wait_for_rr_db

.PHONY: serve
serve: build launch_db
	$(DOCKER_COMPOSE) run --rm app rm -f tmp/pids/server.pid
	$(DOCKER_COMPOSE) up -d

.PHONY: lint
lint: build
	$(DOCKER_COMPOSE) run --rm app bundle exec govuk-lint-ruby app lib spec Gemfile*

.PHONY: test
test: build launch_db
	$(DOCKER_COMPOSE) run -e RACK_ENV=test --rm app ./bin/rails db:create db:environment:set RAILS_ENV=test db:schema:load db:migrate
	$(DOCKER_COMPOSE) run --rm app bundle exec rspec

.PHONY: bash
bash: serve
	docker exec -it `docker-compose ps -q app | awk 'END{print}'` bash

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

.PHONY: clean
clean: stop
	$(DOCKER_COMPOSE) down
