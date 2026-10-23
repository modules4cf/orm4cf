# orm4cf Contributing Guide

Thank you for your interest in contributing to orm4cf! orm4cf is maintained by the [modules4cf](https://github.com/modules4cf) community. It is a fork of [cborm](https://github.com/coldbox-modules/cborm) by Ortus Solutions, Corp, licensed under the Apache License, Version 2.0. Before submitting your contribution, please take a moment to read the following guidelines:

- [Code Of Conduct](#code-of-conduct)
- [Bug Reporting](#bug-reporting)
- [Pull Requests](#pull-requests)
- [Support Questions](#support-questions)
- [Security Vulnerabilities](#security-vulnerabilities)
- [Language Compatibility](#language-compatibility)
- [Coding Styles \& Formatting](#coding-styles--formatting)
- [CFC Docs With DocBox](#cfc-docs-with-docbox)
- [License](#license)
- [Supporting the Original Authors](#supporting-the-original-authors)
- [Contributors](#contributors)

## Code Of Conduct

This project is open source, and as such, the maintainers give their free time to build and maintain the source code held within. They make the code freely available in the hope that it will be of use to other developers and/or businesses. Please be considerate towards maintainers when raising issues or presenting pull requests.  **We all follow the Golden Rule: Do to others as you want them to do to you.**

- As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.
- Participants will be tolerant of opposing views.
- Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.
- Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned with this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.
- When interpreting the words and actions of others, participants should always assume good intentions.  Emotions cannot be derived from textual representations.
- Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by opening an issue or contacting one or more of the project maintainers.

## Bug Reporting

Please report bugs in the orm4cf issue tracker: <https://github.com/modules4cf/orm4cf/issues>

If you file a bug report, your issue should contain a title, a clear description of the issue, the CFML engine and version you use (for example Lucee 7 or Adobe ColdFusion 2025), the orm4cf version, a way to replicate the issue, and any support files that we might need to replicate your issue. The goal of a bug report is to make it easy for yourself - and others - to replicate the bug and develop a fix for it.

## Pull Requests

Pull requests are welcome at <https://github.com/modules4cf/orm4cf/pulls>.

1. Fork the repository and create a branch from `main`.
2. Keep **one concern per pull request**. Small, focused pull requests are easier to review and merge.
3. Add or update tests for your change. Tests must never be skipped or weakened to get a green build.
4. Make sure the CI matrix passes on all supported engines.
5. Link the related issue in the pull request description.

## Support Questions

If you have questions on usage or ideas to bounce off the maintainers, you are welcome to use the community channels:

- Lucee Dev Forum: <https://dev.lucee.org>
- CFML Slack     : <https://cfml.slack.com>
- GitHub issues  : <https://github.com/modules4cf/orm4cf/issues>

## Security Vulnerabilities

If you discover a security vulnerability, please do not open a public issue. Contact one of the [modules4cf maintainers](https://github.com/orgs/modules4cf/people) privately first (for example via a direct message on the CFML Slack), so the issue can be fixed before it is disclosed.

## Language Compatibility

Please make sure your code runs on the following engines, which are covered by CI:

- Lucee 6 and 7
- Adobe ColdFusion 2023 and 2025

## Coding Styles & Formatting

Make sure all code is formatted

```bash
# Format everything
box run-script format

# Start a watcher, type away, save and auto-format for you
box run-script format:watch
```

We recommend that anytime you hack on the code you start the formatter watcher (`box run-script format:watch`). This will monitor your changes and auto-format your code for you.

The formatting rules are inherited from the original project and follow the Ortus Coding Standards: <https://github.com/Ortus-Solutions/coding-standards>.

## CFC Docs With DocBox

All CFCs are self-documenting and we leverage [DocBox](https://docbox.ortusbooks.com/) to document the entire software.  All functions must be properly documented using the DocBox syntax: <https://docbox.ortusbooks.com/getting-started/annotating-your-code>

## License

orm4cf is licensed under the [Apache License, Version 2.0](LICENSE). By contributing, you agree that your contributions are licensed under the same license. The original copyright and attribution notices in [NOTICE](NOTICE) must be kept.

## Supporting the Original Authors

orm4cf builds on cborm, created by Ortus Solutions, Corp and its contributors. If orm4cf is useful to you, consider supporting their open source work as well:

- [Ortus Solutions on Patreon](https://www.patreon.com/ortussolutions)

## Contributors

Thank you to everyone who has contributed to orm4cf and to the original cborm project!

<a href="https://github.com/modules4cf/orm4cf/graphs/contributors">
<img src="https://contrib.rocks/image?repo=modules4cf/orm4cf"/>
</a>

Made with [contributors-img](https://contrib.rocks)
