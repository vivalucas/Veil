# Veil

Veil は、メニューバー項目の非表示、表示、整理に集中した macOS 用メニューバー折りたたみツールです。

[简体中文](README.md) | [English](README.en.md) | [日本語](README.ja.md)

<br>

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/vivalucas/Veil/releases/latest)
[![CI](https://img.shields.io/github/actions/workflow/status/vivalucas/Veil/ci.yml?style=flat-square)](https://github.com/vivalucas/Veil/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2026%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/github/license/vivalucas/Veil?style=flat-square)](LICENSE)

## 概要

Veil は、混雑した macOS メニューバーを扱いやすくします。どの項目を表示したままにするか、どの項目を隠すかを選べ、メニューバーの空きが足りないときは優先度の低い項目を自動的に隠し領域へ折りたたみます。

Veil は、メニューバーをすっきりさせながら、そこにあるツールへのアクセスを失いたくないユーザー向けに作られています。現在の画面は Folding、Layout、Permissions、About の 4 つの入口に集中しています。

## 機能

- メニューバー項目の表示と非表示。
- 空きが足りないときに、あふれた項目を自動的に折りたたみ。
- 使用頻度の低い項目を常に非表示のセクションに保持。
- ホバー、クリック、スクロール、スワイプで隠した項目を表示。
- ドラッグ＆ドロップでメニューバー項目を並べ替え。
- Sparkle によりアプリ内でアップデートを確認、インストール。

## インストール

[Releases ページ](https://github.com/vivalucas/Veil/releases/latest)から最新の Veil をダウンロードし、DMG を開いて `Veil.app` を `/Applications` に移動してください。

Veil は現在 Apple Developer ID による notarization なしで配布されています。初回起動時に macOS が「アプリが破損している」または「開発元を確認できない」と表示する場合があります。その場合は quarantine 属性を削除してください。

```sh
xattr -cr /Applications/Veil.app
```

その後、`/Applications` から Veil を再度起動してください。

## 権限

Veil が起動時に必要とするのは、メニューバー項目の読み取りと移動に使うアクセシビリティ権限だけです。画面収録権限は任意で、Layout のプレビューなどメニューバーアイコン画像が必要な機能でのみ使います。この権限がなくても基本的な折りたたみは動作します。

## 高度なインターフェース

Veil は互換性のために一部の `veil://` URL scheme を保持しています。これは現在の簡素化された主要 UI の一部ではありません。詳しいコマンドリファレンスは [docs/URI_SCHEMES.md](docs/URI_SCHEMES.md) にあります。

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
