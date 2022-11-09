FROM python:3.11-alpine3.16


ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PYTHONDONTWRITEBYTECODE=1 \
  # pip:
  PIP_NO_CACHE_DIR=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_DEFAULT_TIMEOUT=100 \
  # dockerize:
  DOCKERIZE_VERSION=v0.6.1 \
  # poetry:
  POETRY_VERSION=1.2.2 \
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  DOCKER_BUILDKIT=1

COPY ./pyproject.toml /code/pyproject.toml
COPY ./poetry.lock /code/poetry.lock
COPY ./scripts /scripts
COPY ./src /code/
WORKDIR /code/
EXPOSE 8000

ARG DEV=false

RUN apk update \
    && apk add \
    && apk add --no-cache bash \
    && apk add libffi-dev \
    && apk add --update --no-cache alpine-sdk \
    && pip install --no-cache-dir poetry==$POETRY_VERSION


RUN poetry run pip install -U pip \
  && poetry install \
    $(if [ $DEV = 'false' ]; then echo '--only main'; fi) \
    --no-interaction --no-ansi


RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts


ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

CMD ["run.sh"]