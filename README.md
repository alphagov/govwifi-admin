# govwifi-admin

## Purpose

This is the User Admin UI for the [GovWiFi][link_govwifi] project.

## How to install and use

```shell
make setup
make serve
```

Other useful Makefile targets are:

- `make bash` - run a shell in the docker composed application
- `make stop` - stops the application
- `make clean` - removes the application volumes
- `make lint` - runs the linter
- `make test` - runs the tests

## How to contribute

1. Fork the project
1. Create a feature or fix branch
1. Make your changes (with tests if possible)
1. Run and linter `make lint`
1. Run and pass tests `make test`
1. Raise a pull request

[link_govwifi]: https://www.gov.uk/government/publications/govwifi/govwifi
