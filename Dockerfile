##
# 1. Build elixir app and assets
##
FROM ubuntu:focal AS app_builder
ENV DEBIAN_FRONTEND="noninteractive" \
    MIX_ENV=prod \
    NODE_ENV=production \
    LANG=C.UTF-8

# Install deps
RUN apt-get update -q && \
    apt-get install -y curl git build-essential libtool automake autogen libgmp3-dev

# Install elixir
RUN curl -sS https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    --output erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update -q && \
    apt-get install -y esl-erlang elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# Setup the build
RUN mkdir /build
WORKDIR /build
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY mix.exs mix.lock ./

# Build the application
RUN mix deps.get
RUN mix deps.compile
RUN mix compile
RUN mix release


##
# 2. Run the app
##
FROM ubuntu:focal AS release
ENV DEBIAN_FRONTEND="noninteractive" \
    LANG=C.UTF-8

RUN apt-get update -q && \
    apt-get install -y openssl postgresql-client

# Setup non-root user and copy build artifacts
RUN useradd --create-home --home-dir /home/app --shell /bin/bash app
WORKDIR /home/app
COPY --from=app_builder /build/_build .
RUN chown -R app: ./prod

# Run the Phoenix app
USER app
COPY entrypoint.sh .
CMD ["./entrypoint.sh"]