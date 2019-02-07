# Govwifi Admin Application

This is the admin platform, a website where organisations can create and manage their GovWifi installation within their organisation.
N.B. The private GovWifi [build repository][build-repo] contains information on how to build GovWifi end-to-end - the sites, services and infrastructure.

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
make setup
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

## How to contribute

1. Fork the project
1. Create a feature or fix branch
1. Make your changes (with tests if possible)
1. Run and linter `make lint`
1. Run and pass tests `make test`
1. Raise a pull request

## Licence

This codebase is released under [the MIT License][mit].

[mit]: LICENCE
[registers]:https://www.registers.service.gov.uk
[notify]:https://www.notifications.service.gov.uk
[zendesk]:https://govuk.zendesk.com/hc/en-us
[build-repo]:https://github.com/alphagov/govwifi-build
