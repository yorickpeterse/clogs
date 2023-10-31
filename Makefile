.check-version:
	@test $${VERSION?The VERSION variable must be set}

build:
	inko pkg sync
	inko build -o ./build/clogs

release/version: .check-version
	sed -E -i -e "s/^let VERSION = '([^']+)'$$/let VERSION = '${VERSION}'/" \
		src/clogs/cli.inko

release/changelog: .check-version build
	./build/clogs "${VERSION}"

release/commit: .check-version
	git add .
	git commit -m "Release v${VERSION}"
	git push origin "$$(git rev-parse --abbrev-ref HEAD)"

release/tag: .check-version
	git tag -s -a -m "Release v${VERSION}" "v${VERSION}"
	git push origin "v${VERSION}"

release: release/version release/changelog release/commit release/tag

.PHONY: build
.PHONY: release/version release/changelog release/commit release/tag release
