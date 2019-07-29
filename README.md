# pipeline

## 概要

パイプライン処理を行うマイクロプロセッサ．

## 環境

Icarus Verilog version 10.2  
GTKwave

## シミュレーション

`make`: サンプルプログラム1~4をシミュレートする実行ファイルを生成．  
`make test`: サンプルプログラム1~4のシミュレーション波形ファイルを生成．  
`open -a gtkwave sim*_pipe.vcd`: 波形ファイルを表示．