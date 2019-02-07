# Govwifi Admin API

This is the admin platform, a website where organisations can create and manage their GovWifi installation within their organisation.

## Overview

The API contains files and test suites that describe and maintain the desired functionality of the admin platform. It is primarily a Ruby-on-Rails Project.

The API uses some GovUK Services to implement some the desired functions, including:

* [GOV.UK Registers][registers] as a resource for Government organisations to select their names from a predetermined list of registered organisations as they create their accounts.

* [GOV.UK Notify][notify] to handle sending out situational emails to users.

* [GOV.UK Zendesk][zendesk] to handle forms submitted by the user within the app.

## Developping

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
