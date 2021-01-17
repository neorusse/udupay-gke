# Instruct Make to use bash instead of sh
SHELL := /usr/bin/env bash

ROOT := ${CURDIR}

# lint is the first target in the file so it will get picked up when you just
#   run 'make' on its own
lint: check_shebangs check_shell check_base_files check_trailing_whitespace check_docker check_terraform

# create/delete/validate is for CICD
.PHONY: create
create:
	@source $(ROOT)/scripts/create.sh

.PHONY: teardown
teardown:
	@source $(ROOT)/scripts/teardown.sh
