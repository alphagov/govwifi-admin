# Govwifi Admin Application

This is the admin platform, a website where organisations can create and manage their GovWifi installation within their organisation.

N.B. The private GovWifi [build repository][build-repo] contains information on how to build GovWifi end-to-end - the sites, services and infrastructure.

## Table of Contents

- [Govwifi Admin Application](#govwifi-admin-application)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Developing](#developing)
    - [Setup and serve the app locally](#setup-and-serve-the-app-locally)
    - [Running the tests](#running-the-tests)
    - [Using the Linter](#using-the-linter)
    - [Run a shell in the docker composed application](#run-a-shell-in-the-docker-composed-application)
    - [Stop the application](#stop-the-application)
    - [Remove the application volumes](#remove-the-application-volumes)
  - [Deploying](#deploying)
    - [Staging](#staging)
    - [Production](#production)
  - [How to contribute](#how-to-contribute)
  - [Licence](#licence)

## Overview

The application allows users to perform the following tasks:

- Create an admin account.
- Invite team members to their account.
- View instructions on how to setup and configure GovWifi on their local network.
- Add IP addresses of their access points to the GovWifi system.
- View logs of authentication requests to GovWifi by IP and username.
- Make support ticket requests.

The application also includes a "Super Admin" login feature that allows a GDS administrator to:

- View all organisations signed up to GovWifi
- See specific information on each of these organisations
- Add custom organisation names to the allowed register

The application uses a few third party services, including:

- [GOV.UK Registers][registers] as a resource for Government organisations to select their names from a predetermined list of registered organisations as they create their accounts.

- [GOV.UK Notify][notify] to handle sending out situational emails to users.

- [GOV.UK Zendesk][zendesk] to handle forms submitted by the user within the app.

The application also provides the following data for the RADIUS configuration via an S3 bucket:

- IP addresses.
- RADIUS secret keys

## Developing

### Setup and serve the app locally

```shell
make serve
```

### Running the tests

```shell
make test
```

### Using the Linter

```shell
make lint
```

### Run a shell in the docker composed application

```shell
make serve
make shell
```

### Stop the application

```shell
make stop
```

### Remove the application volumes

```shell
make clean
```

## Deploying

All deployments are run by the [GDS Concourse][gds-concourse].

The process amounts to:

1. Test + Lint
2. Build a deployment image
3. Push deployment image to the GovWifi ECR
4. Run migrations using the deployment image
5. restart the ECS services using the new deployment image

### Staging

Deployments to Staging are run automatically whenever a change to the `master` branch is made.

### Production

Deployments to Production must be manually triggered.
You can do this by going to the [production deployment pipeline][prod-deploy-pipeline], and starting the "Confirm Deploy to Production" task.

You can start the task by clicking on it, and pressing the `+` icon in the top right of the screen.

This will do a few things:
- It ensures the tests have been run on the latest commit for master.
- It ensures Staging has already been deployed for the latest commit for master.
- It then allows production to deploy using the latest commit for master.

You do not need to wait the Tests and Staging deploy to finish before starting a Production deploy.
The Production deploy will wait for the Tests and Staging deploy to finish before actually running.

## How to contribute

1. Fork the project
2. Create a feature or fix branch
3. Make your changes (with tests if possible)
4. Run and linter `make lint`
5. Run and pass tests `make test`
6. Raise a pull request

## Licence

This codebase is released under [the MIT License][mit].

[mit]: LICENCE
[registers]:https://www.registers.service.gov.uk
[notify]:https://www.notifications.service.gov.uk
[zendesk]:https://govuk.zendesk.com/hc/en-us
[build-repo]:https://github.com/alphagov/govwifi-build
[gds-concourse]: https://cd.gds-reliability.engineering/
[prod-deploy-pipeline]: https://cd.gds-reliability.engineering/teams/govwifi/pipelines/admin-deploy?groups=Production
