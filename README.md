# pipeline

## 概要

パイプライン処理を行うマイクロプロセッサ．

## 環境

Icarus Verilog version 10.2  
GTKwave

## シミュレーション

`make`: サンプルプログラム1&sim;4をシミュレートする実行ファイルを生成．  
`make test`: サンプルプログラム1&sim;4のシミュレーション波形ファイルを生成．  
`open -a gtkwave sim*_pipe.vcd`: 波形ファイルを表示．

## 仕様

### ISA

ISAの仕様は「[実践 コンピュータアーキテクチャ](https://www.amazon.co.jp/dp/4339024376/ref=asap_bc?ie=UTF8)」（坂井修一，コロナ社）に準拠．

#### 命令形式

<div align="center">
<img src="https://github.com/darshimo/pipeline/blob/images/isa_form.png" width=70%>
</div>

#### 一覧

|ニーモニック|命令形式|OP|AUXの値|動作|説明|
|:-:|:-:|:-:|:-:|:-:|:-:|
|ADD|R|0|0|rd <- rs+rt||
|SUB|R|0|2|rd <- rs-rt|2の補数でrd <- rs+(~rt+1)|
|AND|R|0|8|rd <- rs&rt||
|OR|R|0|9|rd <- rs｜rt||
|XOR|R|0|10|rd <- rs^rt||
|NOR|R|0|11|rd <- ~(rs｜rt)||
|SLL|R|0|16|rd <- rs << aux[10:6]|論理左シフト|
|SRL|R|0|17|rd <- rs >> aux[10:6]|論理右シフト|
|SRA|R|0|18|rd <- rs >>> aux[10:6]|算術右シフト|
|ADDI|I|1|imm|rt <- rs+imm|符号拡張||
|LUI|I|3|imm|rt <- imm<<16|||
|ANDI|I|4|imm|rt <- rs&imm|ゼロ拡張||
|ORI|I|5|imm|rt <- rs｜imm|ゼロ拡張||
|XORI|I|6|imm|rt <- rs^imm|ゼロ拡張||
|LW|I|16|offset|rt <- mem[rs+offset]|符号拡張|Word(32bit)読み出し|
|LH|I|18|offset|rt <- mem[rs+offset]|符号拡張|Half Word(16bit)読み出し（なくてもよい）|
|LB|I|20|offset|rt <- mem[rs+offset]|符号拡張|Byte(8bit)読み出し（なくてもよい）|
|SW|I|24|offset|mem[rs+offset] <- rt|符号拡張|Word(32bit)書き込み|
|SH|I|26|offset|mem[rs+offset] <- rt|符号拡張|Half Word(16bit)書き込み（なくてもよい）|
|SB|I|28|offset|mem[rs+offset] <- rt|符号拡張|Byte(8bit)書き込み（なくてもよい）|
|BEQ|I|32|offset|if rs==rt then PC <- NPC+offset|符号拡張|等しければ相対アドレスジャンプ|
|BNE|I|33|offset|if rs!=rt then PC <- NPC+offset|符号拡張|等しくなければ相対アドレスジャンプ|
|BLT|I|34|offset|if rs<rt then PC <- NPC+offset|符号拡張|未満であれば相対アドレスジャンプ|
|BLE|I|35|offset|if rs<=rt then PC <- NPC+offset|符号拡張|以下であれば相対アドレスジャンプ|
|J|A|40|addr|PC <- addr|絶対アドレスジャンプ|
|JAL|A|41|addr|R31 <- NPC;PC <- addr|ジャンプアンドリンク|
|JR|R|42||PC <- rs|レジスタ間接ジャンプ|
|HALT|A|63||処理の停止|
