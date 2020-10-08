.PHONY: validate
validate:
	@utils/script.sh validate

.PHONY: release
release: validate
	@utils/script.sh release