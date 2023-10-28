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
