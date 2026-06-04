# Veil

Veil is a macOS menu bar manager for hiding, showing, organizing, and customizing menu bar items.

[简体中文](README.md) | [English](README.en.md) | [日本語](README.ja.md)

<br>

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/vivalucas/Veil/releases/latest)
[![CI](https://img.shields.io/github/actions/workflow/status/vivalucas/Veil/ci.yml?style=flat-square)](https://github.com/vivalucas/Veil/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2026%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/github/license/vivalucas/Veil?style=flat-square)](LICENSE)

## Overview

Veil keeps a crowded macOS menu bar manageable. It lets you choose which menu bar items stay visible, which ones stay hidden, and when hidden items should appear again.

Veil is designed for users who want a quieter menu bar without losing access to the tools that live there. It supports direct menu bar organization, profiles, hotkeys, and automation through URL schemes.

## Features

- Hide and show menu bar items.
- Keep rarely used items in an always-hidden section.
- Reveal hidden items by hover, click, scroll, swipe, or hotkey.
- Use Veil Bar to display hidden items separately, including on MacBooks with a notch.
- Rearrange menu bar items with drag and drop.
- Save and restore menu bar layouts with profiles.
- Search menu bar items.
- Automate common actions with `veil://` URLs and hooks.
- Check for and install updates in the app through Sparkle.

## Install

Download the latest Veil release from the [releases page](https://github.com/vivalucas/Veil/releases/latest), open the DMG, and move `Veil.app` into `/Applications`.

Veil is currently distributed without Apple Developer ID notarization. On first launch, macOS may show a warning such as "app is damaged" or "cannot verify developer." If that happens, remove the quarantine attribute:

```sh
xattr -cr /Applications/Veil.app
```

Then launch Veil again from `/Applications`.

## Automation

Veil supports URL scheme automation through `veil://`. The detailed command reference is in [docs/URI_SCHEMES.md](docs/URI_SCHEMES.md).

Examples:

```sh
open "veil://open-settings"
open "veil://toggle-veilbar"
open "veil://toggle?key=useIceBar"
```

## Troubleshooting

Common setup and menu bar arrangement issues are covered in [FREQUENT_ISSUES.md](FREQUENT_ISSUES.md).

## Development

Requirements:

- macOS 26 or later
- Xcode 26 or later
- SwiftLint
- SwiftFormat

Open the project in Xcode:

```sh
open Veil.xcodeproj
```

Run tests from macOS:

```sh
xcodebuild test \
  -project Veil.xcodeproj \
  -scheme Veil \
  -destination 'platform=macOS'
```

The internal development knowledge base lives in `project-log/` while the repository is private. Before making the repository public, `project-log/` should be removed from public history and added to `.gitignore`.

## License

Veil is available under the [GPL-3.0 license](LICENSE).

Veil includes work derived from [Ice](https://github.com/jordanbaird/Ice) by Jordan Baird. The GPL-3.0 license and original attribution are preserved.
