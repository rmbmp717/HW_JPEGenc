KASUMI: RISC-V RV32I 実装 (Verilog HDL)
概要
KASUMI は、Verilog HDL で実装された RISC-V RV32I プロセッサです。
本プロジェクトは大学の課題として作成されました。通常、RISC-V の設計には Chisel を用いるのが一般的ですが、担当教官の指示により「Chisel は使用せず、必ず Verilog HDL で設計すること」との要求があり、KASUMI はその要件を満たすために開発されました。

KASUMI は RV32I の基本命令をサポートしており、主にマイクロコントローラ用途を想定しています。OS 用のモードは未対応ですが、将来的には SETSUNA プロジェクトにおいて Supervisor モードや User モードの実装を検討しています。

また、プロセッサ名「KASUMI」は、虹ヶ咲スクールアイドル部のメンバーに影響を受けたものですが、一般的な動詞・名詞として選定されています。

ディレクトリ構成
core
KASUMI のコア部分の実装

cache
（開発中）キャッシュメモリの実装

test_mem
テスト用のレジスタファイルおよびブロックRAM

kasumi.v
（開発中）KASUMI のトップモジュール

kasumi_test.v
テスト用のトップモジュール

評価環境
シミュレーション
Icarus Verilog

GtkWave
※ ARM Mac (MacBook Pro 14") での動作確認済み

FPGA 実装
Zedboard (Xilinx Zynq シリーズ FPGA)

Vivado

ライセンス
本プロジェクトは MIT License の下でライセンスされています。
詳細は LICENSE ファイルを参照してください。

作成者
Prokuma
（奈良先端科学技術大学院大学 修士課程在学中）
