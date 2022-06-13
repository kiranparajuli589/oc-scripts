[![ShellCheck](https://github.com/kiranparajuli589/oc-scripts/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/kiranparajuli589/oc-scripts/actions/workflows/ci.yml)
# Handy scripts to run different [owncloud](https://github.com/owncloud) tests

## Services
- ocis
- middleware

## Scripts
- run_api_test_with_ocis.sh
- run_oc10_app_test.sh
- run_oc10_test.sh
- run_ocis_local_test.sh
- run_web_acceptance.sh
- run_web_e2e.sh

## Dependencies
- [wait-for-it](https://github.com/vishnubob/wait-for-it 'wait-for-it') is a debian package which helps us to wait for the availability of a host and a TCP port

    Installation:
    ```shell
    sudo apt-get install wait-for-it
    ```

## Run services
```sh
bash services/ocis.sh --help
```

## Run scripts
```sh
bash scripts/run_api_test_with_ocis.sh --help
```

