# rfed — install dependencies, run tests, build and publish releases.
#
#   make            show this help
#   make install    install the package editable
#   make test       run the test suite
#   make clean      remove build/test artifacts
#
#   make release        build sdist+wheel and upload to PyPI (twine)
#   make release-dry    build sdist+wheel and validate metadata only

PYTHON ?= python3

.PHONY: help install test clean release release-dry
.DEFAULT_GOAL := help

help: ## Show this help
	@echo "rfed runner"
	@echo
	@echo "Targets:"
	@echo "  install       $(PYTHON) -m pip install -e ."
	@echo "  test          $(PYTHON) -m unittest discover -s tests"
	@echo "  clean         remove build/test artifacts"
	@echo
	@echo "  release       twine upload to PyPI  (release-dry validates)"

install: ## Install the package (editable)
	$(PYTHON) -m pip install -e .

test: ## Run tests
	$(PYTHON) -m unittest discover -s tests

clean: ## Remove build/test artifacts
	rm -rf build dist *.egg-info .pytest_cache
	find . -type d -name __pycache__ -prune -exec rm -rf {} +

# --- release ---------------------------------------------------------------
# PyPI: `release` uses twine with local creds (~/.pypirc or TWINE_*).
#       CI instead builds via release-dry and uploads through OIDC
#       trusted publishing (pypa/gh-action-pypi-publish, no token).

release: ## Build sdist+wheel and upload to PyPI (twine)
	rm -rf dist && $(PYTHON) -m build && $(PYTHON) -m twine upload dist/*

release-dry: ## Build sdist+wheel and validate metadata (twine check)
	rm -rf dist && $(PYTHON) -m build && $(PYTHON) -m twine check dist/*
