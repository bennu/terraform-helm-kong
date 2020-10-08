.PHONY: validate
validate:
	@ci/release.sh validate

.PHONY: release
release: validate
	@ci/release.sh release