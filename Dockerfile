FROM --platform=linux/amd64 golang:1.22 AS build-env
ENV APP_HOME /checkout-api
ENV GOFLAGS -mod=vendor
WORKDIR $APP_HOME
COPY go.* ./
COPY vendor ./
COPY . ./
# With the trick below, Go's build cache is kept between builds.
# https://github.com/golang/go/issues/27719#issuecomment-514747274
RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $APP_HOME/bin/api ./cmd/api
RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $APP_HOME/bin/worker ./cmd/worker
RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $APP_HOME/bin/consumer ./cmd/event_consumer
RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $APP_HOME/bin/console ./cmd/console

FROM --platform=linux/amd64 ruby:3.3.0-slim
WORKDIR /app
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libpq-dev \
    make \
    gcc \
    tzdata \
    xz-utils \
    pkg-config \
    libxml2-dev \
    libxslt-dev \
  && apt-get upgrade -y \
  && rm -rf /var/lib/apt/lists/*
RUN bundle config set without 'development test'
RUN bundle config build.nokogiri --use-system-libraries
COPY db_migrations db_migrations
RUN bundle install --gemfile db_migrations/Gemfile
COPY run-*.sh ./
COPY docs/api/ /app/docs/
COPY --from=build-env /checkout-api/bin/* ./
CMD ["./run-server.sh"]
