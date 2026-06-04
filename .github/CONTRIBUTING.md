# Contributing to Veil

The following is a set of development guidelines for Veil.

## Scope

- Bug reports
- Documentation improvements
- Code

## Before You Start

Regardless of the type of contribution, you'll need a GitHub account and a fork of the repository:

1. Fork the repository on GitHub
2. Clone your fork locally

   ```bash
   git clone https://github.com/YOUR_USERNAME/Veil.git
   ```

3. Navigate to the cloned directory
4. Create a branch for your changes

   ```bash
   git checkout -b your-branch-name
   ```

5. When ready, open a pull request against `vivalucas/Veil:main`

## Non-technical contributions

### Reporting bugs

Before submitting a bug report, please search the [issue tracker][it] and check [Frequent Issues][fq] — your problem may already be known with a workaround available.

We want to fix all issues as soon as possible, but before fixing a bug we need to be able to reproduce them first. Our bug report template will guide you through the information we need. Issues without enough information to reproduce the problem may be closed until more details are provided.

If the app crashed — attaching a log file will help us significantly, you can find these in Veil's settings under the General tab.

### Documentation improvements

If you find something unclear, incomplete, or out of date in any of the project's docs, a pull request to fix it is welcome.

This includes but is not limited to:

- Fixing typos or unclear wording
- Keeping the README up to date
- Adding new entries to [Frequent Issues][fq]
- Improving this and other guides.

## Technical contributions

### Prerequisites

- Xcode 26+
- macOS 26+

### Getting Started

1. Open `Veil.xcodeproj` in Xcode 26 or later

   ```bash
   open Veil.xcodeproj
   ```

2. Build and run the app (`Cmd+R`) to confirm everything works before making changes

### Code Style

Veil uses [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to enforce consistent code style.

Before submitting changes, run:

```bash
swiftformat .
swiftlint lint
```

Pull requests are checked by CI before merge.

### Pull Requests

Open a pull request via the [Veil pull requests page][pr] and select the [appropriate template][prt] — it will guide you through the required information and checklist.

[fq]: ../FREQUENT_ISSUES.md
[it]: https://github.com/vivalucas/Veil/issues
[pr]: https://github.com/vivalucas/Veil/pulls
[prt]: https://github.com/vivalucas/Veil/blob/main/.github/pull_request_template.md
