# やる気の出ない日ログ

「今日はやる気が出なかった」を1タップで記録する、シンプルなiOSアプリです。
励ましません。分析しません。評価もしません。
ボタンを押すと、その日付がログとして残ります。


なぜか、CSV出力機能はついています。
記録は端末内に保存され、CSVとして書き出すこともできます。


日付更新は午前3時に設定しています。


## 概要
- 日ごとの「やる気が出なかった日」を記録
- 累計日数・今月の日数・連続日数を表示
- 記録一覧の削除対応
- CSVエクスポート対応

## 使い方
1. アプリを起動
2. `今日、やる気が出なかった` ボタンを押して記録
3. 必要に応じて一覧から削除、`CSV出力` で保存

## 技術スタック
- Swift
- SwiftUI
- UserDefaults（ローカル保存）
- FileDocument / fileExporter（CSV出力）

## 開発環境
- Xcode（iOSアプリプロジェクト）
- プロジェクト: `YarukilLog.xcodeproj`

##  App Store リンク
https://apps.apple.com/jp/app/%E3%82%84%E3%82%8B%E6%B0%97%E3%81%AE%E5%87%BA%E3%81%AA%E3%81%84%E6%97%A5%E3%83%AD%E3%82%B0-%E5%BA%83%E5%91%8A%E3%81%AA%E3%81%97/id6758742783

## プライバシーポリシー
https://sites.google.com/view/hamakazesoft-yarukidenailog/%E3%83%9B%E3%83%BC%E3%83%A0


## ライセンス
MIT License


This project is licensed under the MIT License.
See LICENSE for details.

