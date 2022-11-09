BASH=bash -l -c
PROJECT=main-backend
# Replace it with any path you want to execute with pytest
TESTS_PATH = app/

start:
	docker-compose up

stop:
	docker-compose stop

build:
	docker-compose build

bash:
	docker-compose run $(PROJECT) bash

shell:
	docker-compose run $(PROJECT) sh

lint:
	pre-commit run --all-files
	make mypy

flake:
	docker-compose run --rm $(PROJECT) sh -c "flake8"

mypy:
	docker-compose run --rm $(PROJECT) sh -c "mypy ."

test:
	docker-compose run --rm $(PROJECT) sh -c "python manage.py wait_for_db && python manage.py test && python manage.py coverage"

# Prepare for the PR
prep:
	make lint
	make flake
	make test

coverage:
	docker-compose run --rm $(PROJECT) sh -c "python manage.py coverage"

dc_python_shell:
	# Python shell on <REPO_NAME>'s app container
	docker-compose run $(PROJECT) ipython



reset:
	docker-compose stop
	docker-compose down
