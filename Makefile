.PHONY: lint
lint:
	shellcheck -x ./**/*.sh -s bash
