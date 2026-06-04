# Veil

Veil は、メニューバー項目の非表示、表示、整理、カスタマイズを行う macOS 用メニューバーマネージャーです。

[简体中文](README.md) | [English](README.en.md) | [日本語](README.ja.md)

<br>

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/vivalucas/Veil/releases/latest)
[![CI](https://img.shields.io/github/actions/workflow/status/vivalucas/Veil/ci.yml?style=flat-square)](https://github.com/vivalucas/Veil/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2026%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/github/license/vivalucas/Veil?style=flat-square)](LICENSE)

## 概要

Veil は、混雑した macOS メニューバーを扱いやすくします。どの項目を表示したままにするか、どの項目を隠すか、隠した項目をいつ再表示するかを選べます。

Veil は、メニューバーをすっきりさせながら、そこにあるツールへのアクセスを失いたくないユーザー向けに作られています。メニューバー項目の直接整理、プロファイル、ホットキー、URL scheme による自動化に対応しています。

## 機能

- メニューバー項目の表示と非表示。
- 使用頻度の低い項目を常に非表示のセクションに保持。
- ホバー、クリック、スクロール、スワイプ、ホットキーで隠した項目を表示。
- Veil Bar で隠した項目を別表示。ノッチ付き MacBook にも対応。
- ドラッグ＆ドロップでメニューバー項目を並べ替え。
- プロファイルでメニューバーレイアウトを保存、復元。
- メニューバー項目を検索。
- `veil://` URL と hooks で一般的な操作を自動化。
- Sparkle によりアプリ内でアップデートを確認、インストール。

## インストール

[Releases ページ](https://github.com/vivalucas/Veil/releases/latest)から最新の Veil をダウンロードし、DMG を開いて `Veil.app` を `/Applications` に移動してください。

Veil は現在 Apple Developer ID による notarization なしで配布されています。初回起動時に macOS が「アプリが破損している」または「開発元を確認できない」と表示する場合があります。その場合は quarantine 属性を削除してください。

```sh
xattr -cr /Applications/Veil.app
```

その後、`/Applications` から Veil を再度起動してください。

## 自動化

Veil は `veil://` URL scheme による自動化に対応しています。詳しいコマンドリファレンスは [docs/URI_SCHEMES.md](docs/URI_SCHEMES.md) にあります。

例：

```sh
open "veil://open-settings"
open "veil://toggle-veilbar"
open "veil://toggle?key=useIceBar"
```

## トラブルシューティング

よくあるセットアップやメニューバー整理の問題は [FREQUENT_ISSUES.md](FREQUENT_ISSUES.md) にまとめています。

## 開発

必要環境：

- macOS 26 以降
- Xcode 26 以降
- SwiftLint
- SwiftFormat

Xcode でプロジェクトを開く：

```sh
open Veil.xcodeproj
```

macOS でテストを実行：

```sh
xcodebuild test \
  -project Veil.xcodeproj \
  -scheme Veil \
  -destination 'platform=macOS'
```

リポジトリが private の間、内部開発ナレッジベースは `project-log/` にあります。リポジトリを public にする前に、`project-log/` を公開履歴から削除し、`.gitignore` に追加してください。

## ライセンス

Veil は [GPL-3.0 license](LICENSE) の下で利用できます。

Veil には Jordan Baird による [Ice](https://github.com/jordanbaird/Ice) から派生した作業が含まれています。GPL-3.0 ライセンスと元の attribution は保持されています。
