FROM elixir:1.11.2-slim

WORKDIR /app

COPY mix.exs mix.lock ./

RUN apt-get update && apt-get install make gcc -y && mix do local.hex --force, local.rebar

CMD mix setup && mix phx.server