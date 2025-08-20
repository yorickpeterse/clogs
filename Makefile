PREFIX := /usr
BINDIR := ${PREFIX}/bin
DATADIR := ${PREFIX}/share

.check-version:
	@test $${VERSION?The VERSION variable must be set}

build:
	inko build --release

install: build
	install -D --mode=755 build/release/clogs ${DESTDIR}${BINDIR}/clogs

uninstall:
	rm --force ${BINDIR}/clogs

release/version: .check-version
	sed -E -i -e "s/^let VERSION = '([^']+)'$$/let VERSION = '${VERSION}'/" \
		src/clogs.inko

release/changelog: .check-version build
	./build/release/clogs "${VERSION}"

release/commit: .check-version
	git add .
	git commit -m "Release v${VERSION}"
	git push origin "$$(git rev-parse --abbrev-ref HEAD)"

release/tag: .check-version
	git tag -a -m "Release v${VERSION}" "v${VERSION}"
	git push origin "v${VERSION}"

release: release/version release/changelog release/commit release/tag

.PHONY: build install uninstall
.PHONY: release/version release/changelog release/commit release/tag release
