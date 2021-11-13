SHELL := bash

.SHELLFLAGS := -euo pipefail -c

.DELETE_ON_ERROR:
.ONESHELL:

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

ERROR := "\033[38;5;160;1m[error]\033[0m"
INFO := "\033[38;5;141m[info]\033[0m"
OK := "\033[38;5;41m[ok]\033[0m"
WARNING := "\033[38;5;172m[warning]\033[0m"

default: help

.PHONY: help
help: # Display this help message
	@awk ' \
  	  BEGIN { \
  	      FS = ": #"; \
  	      printf "Usage:\n  make \033[38;5;141m<target>\033[0m\n\nTargets:\n" \
  	  } /^(.+)\: #\ (.+)/ { \
  	      printf "  \033[38;5;141m%-11s\033[0m %s\n", $$1, $$2 \
      } \
    ' $(MAKEFILE_LIST)

.PHONY: thumbprint
thumbprint: # Obtain the GitHub OpenID thumbprint
	@echo -e ${INFO} "Obtaining the GitHub OpenID thumbprint..."

