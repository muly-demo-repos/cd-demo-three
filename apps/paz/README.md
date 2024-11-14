<p align="right">
  <a href="https://amplication.com" target="_blank">
    <img alt="amplication-logo" height="70" alt="Amplication Logo" src="https://amplication.com/images/logo.svg"/>
  </a>
</p>

# Introduction

This service was generated with Amplication. The server-side of the generated project. This component provides the different backend services - i.e., REST API, authentication, authorization, logging, data validation and the connection to the database. Additional information about the server component and the architecture around it, can be found on the [documentation](https://docs.amplication.com/guides/getting-started) site.

## Getting started

Follow the steps below to get the service up and running.

### Step 1: Scripts - pre-requisites

1. Install the .NET SDK from [here](https://dotnet.microsoft.com/download)
2. Install the .NET Core tools by running the following command:

```sh
# install the .NET Core tools
$ dotnet restore .
```

3. Create the initial migration by running the following command, from the `src` folder:

```sh
# create and apply initial migration
# (from within the src folder)
$ dotnet ef migrations add initialMigration
```

### Step 2: Run the service in development mode

You can run the service in development mode in two ways:

1. Run the service locally
2. Run the service in a container

#### Run the service locally

1. Run the service's dependencies in Docker

```sg
  docker-compose up --build
```

2. Run the service by executing the following command from the root folder of the service:

```sh
  # run from the root folder of the service
  dotnet run --project ./src
```

#### Run the service in a container

- Run the service and its dependencies in Docker

```sh
  docker-compose --profile complete up --build
```

### Step 3: Access the service

The service will be available at the following URL:
`http://localhost:5202/`

You can access the Swagger UI at:
`http://localhost:5202/swagger/`

To access a specific endpoint, you can use the following format for the URL:
`http://localhost:5202/api/<controller>/<endpoint>`
e.g.
`http://localhost:5202/api/customers/meta`

## Database migrations

### Apply database migration in local development environment

For any database model change, create a new migrations, by running the following command from the `src` folder:
replace `<new migration name>` with a meaningful name for the migration

```sh
# (from within the src folder)
$ dotnet ef migrations add <new migration name>
```

> Migration will be automatically applied on docker compose up

### Apply database migration in non-local environment

Database modification in non-local environment would be applied through different strategies depending on the requirements.
Follow Microsoft directions for your strategy: https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/applying
