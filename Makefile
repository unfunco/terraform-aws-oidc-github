SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

.DELETE_ON_ERROR:
.ONESHELL:

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

default: help

.PHONY: docs
docs: # generate documentation
	terraform-docs .
	npx prettier --write '**/*.md'

.PHONY: help
help: # display this help message
	@egrep '^(.+)\:\ #\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':'
