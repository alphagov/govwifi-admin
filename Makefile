DOCKER_COMPOSE = docker-compose -f docker-compose.yml
BUNDLE_FLAGS=

ifdef DEPLOYMENT
  BUNDLE_FLAGS = --without test development
endif

DOCKER_COMPOSE += -f docker-compose.development.yml


DOCKER_BUILD_CMD = BUNDLE_INSTALL_FLAGS="$(BUNDLE_FLAGS)" $(DOCKER_COMPOSE) build

build:
	$(DOCKER_COMPOSE) build

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
	$(DOCKER_COMPOSE) run  --no-deps --rm app node ./node_modules/stylelint/bin/stylelint.mjs "**/*.scss"

autocorrect: autocorrect-erb
autocorrect-erb: build
	$(DOCKER_COMPOSE) run --rm --no-deps app bundle exec erblint --lint-all --autocorrect

test: stop build prebuilt-test

prebuilt-test:
	$(DOCKER_COMPOSE) run -e RACK_ENV=test --rm app ./bin/rails db:create db:schema:load db:migrate
	$(DOCKER_COMPOSE) run --rm app bundle exec rspec

shell: serve
	$(DOCKER_COMPOSE) exec app bash

stop:
	$(DOCKER_COMPOSE) down -v

.PHONY: build lint serve shell stop test

vsctest: 
	RACK_ENV=test ./bin/rails db:drop db:create db:schema:load db:migrate
	bundle exec rspec

vscrefreshdb:
	./bin/rails db:drop db:create db:schema:load db:seed

vscdbg:
	BYPASS_2FA=true bundle exec rdbg -n --open=vscode -c -- bin/rails s -b 0.0.0.0

vscdbg-mfa:
	bundle exec rdbg -n --open=vscode -c -- bin/rails s -b 0.0.0.0

vscrubylint:
	bundle exec rubocop
  
vsclint:
	bundle exec rubocop
	bundle exec erblint --lint-all
	node ./node_modules/stylelint/bin/stylelint.mjs "**/*.scss"
