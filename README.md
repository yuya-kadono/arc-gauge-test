# arc-gauge-test

Qt Quick (QML) で実装した半円弧ゲージのプロトタイプです。  
`ArcItem`（Qt Design Studio の Studio Components）と `PathAngleArc`（Qt Quick Shapes）の 2 種類の実装を比較しながら、クリッピング・マーカー・ラベルなどのレイアウト計算を検証します。

## 概要

| 項目 | 内容 |
|------|------|
| フレームワーク | Qt 6.5 以降 / Qt Quick / Qt Quick Shapes |
| ビルドシステム | CMake |
| ウィンドウサイズ | 800 × 600 px |
| スクリーン数 | 3（下部ドットで切り替え） |

### 各スクリーン

- **Screen01** — `ArcItem` を使ったゲージ。現在値・上限／下限マーカー・クリップ幅・弧パラメーターをコントロールパネルでリアルタイム調整できます。
- **Screen02** — Screen01 と同じパラメーターを持つ `ArcItem` ベースの別レイアウト。ゲージ周辺の導出ジオメトリ（innerR・arcH・rightMargin など）を画面上に表示します。
- **Screen03** — `PathAngleArc`（Qt Quick Shapes）への移植版。Screen02 と同じ計算ロジックを `radiusX` / `startAngle` / `sweepAngle` に変換して描画します。

## ビルド方法

```bash
cmake -B build -DCMAKE_PREFIX_PATH=<Qt インストールパス>
cmake --build build
```

Qt Design Studio で開く場合は `ArcGaugeTest.qmlproject` を使用してください。

## ドキュメント

弧ゲージのレイアウト計算（角度変換・半径導出・クリップ幅の最小値など）の詳細は [`docs/arc-gauge-calculation.md`](docs/arc-gauge-calculation.md) を参照してください。

## ライセンス

[LICENSE](LICENSE) を参照してください。