# Contributing
When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository first.

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Pull Request process
### From Forks
1. The destination branch must be `candidate`
2. PR description should contain:
   1. Chart name
   2. New version
3. One PR should contain changes only for one chart. (only files in `./stable/%CHART_NAME%/` directory)
4. Changes to any automation pipelines are prohibited

### From Collaborators or Team members
1. To work on a chart, create a `branch` name which shares the same name as a `./stable/%CHART_NAME%/` to trigger tests through GitHub action. A branch name by any other name, will not triger any tests.
2. Notify the QA and Testing team when you ready to release, providing the SHA-1 of the commit in master and a CHANGELOG.
3. Update the README.md with details of changes to the interface. This includes new environment variables, exposed ports, useful file locations and container parameters.
4. Increase the version numbers in the `Chart.yaml` to the new version using [SemVer][semver].
5. Open a pull request into`master`. `master` branch requires pull request approval and passing tests before merging.

## Release Process
### From Forks
External fork `branch_name` --> `candidate` --> `chartname` --> `master` --> `release tag`

### From Collaborators or Team members
`chartname` --> `master` --> `release tag`

After a new release was tested and merged into master, it can then be built by tagging the master branch: `%CHART_NAME%`-[SemVer][semver].
```bash
git pull
git checkout master
git tag autonity-network-0.0.1
git push origin tags/autonity-network-0.0.1
```

Note: The above release will also automatically update the `latest` tag.

## Code of Conduct
This project and everyone participating in it is governed by the [Code of Conduct][codeofconduct]. By participating, you are expected to uphold this code. Please report unacceptable behavior to [opensource@clearmatics.com][email].

[codeofconduct]: CODE_OF_CONDUCT.md
[semver]: http://semver.org/
[email]: mailto:opensource@clearmatics.com
