BUNDLE_FLAGS = --build-arg BUNDLE_INSTALL_CMD='bundle install --jobs 20 --retry 5'

ifdef DEPLOYMENT
	BUNDLE_FLAGS = --build-arg BUNDLE_INSTALL_CMD='bundle install --without test'
endif

DOCKER_BUILD_CMD = docker-compose build $(BUNDLE_FLAGS)


build:
	$(MAKE) stop
	$(DOCKER_BUILD_CMD)

serve:
	$(MAKE) build
	docker-compose up -d db
	./mysql/bin/wait_for_mysql
	docker-compose run --rm app ./bin/rails db:create db:schema:load
	docker-compose up -d app

lint:
	$(MAKE) build
	docker-compose run --rm app bundle exec govuk-lint-ruby app lib spec Gemfile*

test:
	$(MAKE) build
	docker-compose run --rm app rspec

stop:
	docker-compose kill
	docker-compose rm -f

.PHONY: build serve lint test stop
