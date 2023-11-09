# clogs

clogs (short for **c**hange**logs**) is a tool for generating a Markdown
changelog, populating the changelog from Git commits containing
[trailers](https://git-scm.com/docs/git-interpret-trailers). The approach is
similar to that of [GitLab's changelog API](https://docs.gitlab.com/ee/api/repositories.html#add-changelog-data-to-a-changelog-file),
which isn't a coincidence given I implemented said API while working for GitLab.
Unlike said API, clogs doesn't depend on third-party APIs, and takes a more
opinionated approach.

Compared to [conventional
commits](https://www.conventionalcommits.org/en/v1.0.0/) and the many tools that
use the convention, using trailers means you don't have to change how you write
subject lines, which is nice if you're trying to stick to a line length of 50
characters (give or take a few). In addition, as Git supports trailers natively,
you can filter commits based on these trailers should that ever be necessary.
You can also easily add trailers when writing commits by using `git commit
--trailer="Changelog: added"` for example.

## Usage

clogs only includes commits that contain the `Changelog` trailer. The value of
this trailer is the changelog category, as specified in the `changelog.json`
configuration file. Commits without such a trailer are ignored. clogs also
ignores commits that are reverted, provided the bodies of such commit contain
the string `This reverts commit SHA` where `SHA` is the SHA of the commit that
is reverted.

To generate a changelog for a new version, simply run `clogs VERSION` where
`VERSION` is the version to generate the changelog for. For more information,
run `clogs --help`.

## Configuration

Configuration settings are specified in a `config.json` file using the following
format:

```json
{
  "url": "https://github.com/yorickpeterse/clogs/commit/%s",
  "changelog": "CHANGELOG.md",
  "categories": {
    "added": "Added",
    "fixed": "Fixed",
    "changed": "Changed"
  }
}
```

The `url` pair specifies the project URL, used for generating links to commits.
The `%s` placeholder is replaced with the full commit SHA.

The `changelog` pair specifies the path (relative to the directory of the
configuration file) to the changelog file to update.

The `categories` object specifies the trailer values (e.g. `added` for
`Changelog: added`), and the titles to use in the generated changelog section.
When generating the Markdown, commits are grouped in the same order as the
key-value pairs in this object (i.e. `added` commits are grouped before `fixed`
commits using the above configuration).

To generate a configuration file and an initial changelog file (if one doesn't
already exist), run `clogs init`.

## The output

The Markdown output is fixed and can't be customized, nor are there any plans
to add support for this. This is a deliberate, at it keeps the tool simple and
ensures a consistent changelog format.

clogs also requires that the headings for new versions use the format
`## X.Y.Z ...`, where `X.Y.Z` is a version number and `...` any additional
characters. This format is required such that clogs can figure out where the
Markdown for a new version should be inserted, such that the version sections
are in version order, starting with the newest version. So if your changelog
looks like this:

```markdown
## 2.0.0

...

## 1.1.0

...
```

And you run `clogs 1.2.0`, the result is as follows:

```markdown
## 2.0.0

...

## 1.2.0

...

## 1.1.0

...
```

If no such headings are found, clogs inserts the new section at the end of the
changelog.

## Requirements

- Inko 0.13.1 or newer
- Git

Generating changelogs comes with the following workflow requirements:

- Commits must include a `Changelog` trailer to be included in the changelog.
- Tags for releases must be in the format `vMAJOR.MINOR.PATCH`, other formats
  aren't supported.
- Release versions passed to clogs must be in the format `MAJOR.MINOR.PATCH`,
  other formats aren't supported.

## Installation

To build from source:

```
inko pkg sync
inko build -o build/clogs
```

If you're using Arch Linux, [an AUR
package](https://aur.archlinux.org/packages/git-clogs) is also available:

```
yay -S git-clogs
```

## License

All source code in this repository is licensed under the Mozilla Public License
version 2.0, unless stated otherwise. A copy of this license can be found in the
file "LICENSE".
