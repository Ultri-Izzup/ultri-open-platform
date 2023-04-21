# Local Development

## Get Code

```sh
git clone 
```

## Start Docker Containers

This provides 100% of the infrastructure needed to run end-to-end locally.

```sh
docker compose -f dev-compose.yaml up
```

## Frontend Development

```sh
cd frontend
yarn install
quasar dev
```