# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change. 

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Pull Request Process

1. The `branch` name for release should be the same as chart.
2. Notify the QA and Testing team when ready to release, providing the SHA-1 of the commit in master and a CHANGELOG.
3. Update the README.md with details of changes to the interface, this includes new environment 
   variables, exposed ports, useful file locations and container parameters.
4. Increase the version numbers in Chart to the new version that this
   Pull Request would represent. The versioning scheme we use is [SemVer][semver].
5. You may `merge` the Pull Request in once you have the sign-off of one other developer, or if you 
   do not have permission to do that, you may request the second reviewer to merge it for you.
6. After new release was tested delivered to master you should build release to the repo.
   ```bash
   git pull
   git checkout -b master
   git tag autonity-network-0.0.1
   git push --tag
   ```
   Be carefully, builded release will automatically `latest` and deployed by default for all users.


## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct][codeofconduct]. By participating, you are expected to uphold this code. Please report unacceptable behavior to [opensource@clearmatics.com][email].

[codeofconduct]: CODE_OF_CONDUCT.md 
[semver]: http://semver.org/
[email]: mailto:opensource@clearmatics.com
