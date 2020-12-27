.PHONY: up down build test-shell mix-deps

build: down
	docker-compose  build

up: build
	docker-compose up

down:
	docker-compose down -v --remove-orphans		

mix-deps:
	mix do deps.get, deps.compile

test-shell: build
	docker-compose \
		-f docker-compose.yml \
		run --rm app bash -c 'make db && /bin/bash'

.PHONY: db
db: mix-deps
	mix do ecto.create, ecto.migrate		