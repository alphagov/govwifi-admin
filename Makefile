DOCKER_COMPOSE = docker-compose -f docker-compose.yml
BUNDLE_FLAGS=

ifdef DEPLOYMENT
  BUNDLE_FLAGS = --without test development
endif

ifndef ON_CONCOURSE
	DOCKER_COMPOSE += -f docker-compose.development.yml
endif

ifdef ON_CONCOURSE
	DOCKER_COMPOSE += -f docker-compose.concourse.yml
endif

DOCKER_BUILD_CMD = BUNDLE_INSTALL_FLAGS="$(BUNDLE_FLAGS)" $(DOCKER_COMPOSE) build

build:
ifndef ON_CONCOURSE
	$(DOCKER_COMPOSE) build
endif

prebuild:
	$(DOCKER_COMPOSE) build
	$(DOCKER_COMPOSE) up --no-start

serve: stop build
	$(DOCKER_COMPOSE) run --rm app ./bin/rails db:create db:schema:load db:seed
	$(DOCKER_COMPOSE) up -d app

lint: lint-ruby lint-erb lint-scss
lint-ruby: build
	$(DOCKER_COMPOSE) run  --no-deps --rm app bundle exec rubocop
lint-erb: build
	$(DOCKER_COMPOSE) run  --no-deps --rm app bundle exec erblint --lint-all
lint-scss: build
	$(DOCKER_COMPOSE) run  --no-deps --rm app node ./node_modules/stylelint/bin/stylelint.js "**/*.scss"

autocorrect: autocorrect-erb
autocorrect-erb: build
	$(DOCKER_COMPOSE) run --rm --no-deps app bundle exec erblint --lint-all --autocorrect

test: stop build
	$(DOCKER_COMPOSE) run -e RACK_ENV=test --rm app ./bin/rails db:create db:schema:load db:migrate
	$(DOCKER_COMPOSE) run --rm app bundle exec rspec

shell: serve
	$(DOCKER_COMPOSE) exec app bash

stop:
	$(DOCKER_COMPOSE) down -v

.PHONY: build lint serve shell stop test
