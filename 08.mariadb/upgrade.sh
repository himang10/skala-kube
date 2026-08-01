#!/bin/bash

helm upgrade mariadb-1 bitnami/mariadb \
  -f custom-values.yaml

