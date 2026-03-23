SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

.DELETE_ON_ERROR:

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

default: help

.PHONY: docs
docs: # generate docs and format Terraform/README
	./hack/make-targets/docs.sh

.PHONY: help
help: # display this help message
	@egrep '^(.+)\:\ #\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':'
