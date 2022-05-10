# okblogcard.vim
this tools make blogcard html code from url

urlからブログカード用htmlコードを生成するvimスクリプト

url先のページにogpがある場合、それを読む。


## 必要な他のvimスクリプト

「webapi-vim」が必要

「okblogger.vim」が便利

## 事前の準備

同梱のokblogcard.cssの内容をblogで読み込んでおく。
(blobberの場合、「htmlの編集」に入って、head部分に適当にコピペ)


## 使い方

対象URLだけが書いてある行にカーソルを合せて、
<code>okblogcard#drawcard()</code>関数を呼ぶ。

```
:call okblogcard#drawcard()
```

実際には、vimrcでキーを割り当てておくと便利

```vim

" URLの行をブログカードを表現するhtmlに変換
nnoremap <silent><leader>bc :call okblogcard#drawbcard()<CR>
```
