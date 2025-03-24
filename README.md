# HW JPEG Encoder (Google DSLX & Verilog HDL)
## Introduction
HW JPEG Encoder は、Google の DSLX と Verilog HDL を用いて実装されたハードウェア JPEG エンコーダです。
本プロジェクトは、ハードウェアにおける JPEG エンコード処理を実現するための設計実験として開発されました。
DSLX による高水準な記述と、Verilog HDL による低水準な実装の両面から、効率的かつ柔軟なハードウェア設計を追求しています。

※なお、本プロジェクトは教育・実験目的で作成されています。実際の製品向け機能や高速化は今後の検討課題となります。

## Directories
- HW_python_model:ハードウェア動作の Python モデルを格納します。エンコーダの挙動を Python 上でシミュレートするためのモデルや、動作検証用のコードが含まれています。
- cocotb_sim:cocotb フレームワークを用いたシミュレーション環境のファイル群です。Verilog HDL コードを Python ベースのテストベンチで検証するためのスクリプトや設定ファイルが格納されています。
- image:JPEG エンコードの入力または出力サンプルとなる画像ファイルを配置します。シミュレーションや動作検証時のテストケースとして利用されます。
- ir_dir:DSLX など高水準記述から生成された中間表現（Intermediate Representation, IR）ファイルを管理します。設計過程の中間成果物として、解析やデバッグに利用されます。
- python:プロジェクト全体で利用する補助的な Python スクリプトやツール群を配置します。シミュレーションの自動化、データ解析、結果の可視化などに使用されます。
- src:プロジェクトのソースコード全体をまとめたディレクトリです。DSLX で記述されたコードや、その他設計に必要なソースファイルが含まれます。
- verilog:ハードウェア JPEG エンコーダの Verilog HDL ソースコードを格納します。各モジュールの実装、テスト用トップモジュールなど、FPGA やシミュレーション向けの設計ファイルが集約されています。

## Image
Q=25 Output JPEG Image 
![サンプル画像](image/lena_q25_output.jpg "Output JPEG Image")
  
## Environment of Evaluation
### Simulation
Icarus Verilog and GtkWave on ubuntu linux

### FPGA
gowin GW5AST-LV138PG484 向けに合成可能でした。

## License
MIT License

## 日本語説明Note
https://note.com/dreamy_stilt3370/n/n9b90f30129b8

## Written by
NISHIHARU
https://note.com/dreamy_stilt3370

## Special Thanks
- Python JPEGエンコーダー https://github.com/fangwei123456/python-jpeg-encoder
- Python JPEGデコーダー https://github.com/yohhoy/picojdec
