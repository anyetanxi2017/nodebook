[toc]

#       vim tab设置为4个空格 开启 行号    

```
vim /etc/vimrc

set ts=4
set expandtab
set autoindent
set nu

set smartindent
set shiftwidth=4
```

# vim 常用设置

```
set nocompatible "去掉有关vi一致性模式，避免以前版本的bug和局限
set nu! "显示行号
set guifont=Luxi/ Mono/ 9 " 设置字体，字体名称和字号
filetype on "检测文件的类型
set history=1000 "记录历史的行数
set background=dark "背景使用黑色
syntax on "语法高亮度显示
set autoindent "vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进）
set cindent "（cindent是特别针对 C语言语法自动缩进）
set smartindent "依据上面的对齐格式，智能的选择对齐方式，对于类似C语言编写上有用
set tabstop=4 "设置tab键为4个空格，
set shiftwidth =4 "设置当行之间交错时使用4个空格
set ai! " 设置自动缩进
set showmatch "设置匹配模式，类似当输入一个左括号时会匹配相应的右括号
set guioptions-=T "去除vim的GUI版本中得toolbar
set vb t_vb= "当vim进行编辑时，如果命令错误，会发出警报，该设置去掉警报
set ruler "在编辑过程中，在右下角显示光标位置的状态行
set nohls "默认情况下，寻找匹配是高亮度显示，该设置关闭高亮显示
set incsearch "在程序中查询一单词，自动匹配单词的位置；如查询desk单词，当输到/d时，会自动找到第一个d开头的单词，当输入到/de时，会自动找到第一个以ds开头的单词，以此类推，进行查找；当找到要匹配的单词时，别忘记回车
set backspace=2 " 设置退格键可用
```



# 折叠代码

- 折叠所有代码 zM
- 打开所有代码 zR
- 折叠一小块代码 zc
- 打开一小块代码 zo

# 光标移动

- 上下左右移动
  - h 左
  - l 右
  - j 上
  - k 下
- 以单词为单位进行移动
  - e 下一个单词结尾处
  - w 下一个单词开始处
  - b 上一个单词开始处
- 移动到行首行尾
  - ^ 行首第一个单词
  - 0 行首
  - $ 行尾
 - 移动到文本开头和文本结尾
  - gg 文本开头
  - G 文本结尾
- 利用行号移动到某一行 :123
- 翻页
  - ctrl+b (上一页)
  - ctrl+f (下一页)
- 滚屏
  - ctrl+y 向上
  - ctrl+e 向下
- 标记mark
  - ma 对某处进行标记
  - 'a 移动到a处首行
  - `a 移动到标记位置 

# 正则替换

原字符串 `customer={0}&banktype={1}&amount={2}&orderid={3}&asynbackurl={4}&request_time={5}&key={6}`

目标字符串 `customer=%s&banktype=%s&amount=%s&orderid=%s&asynbackurl=%s&request_time=%s&key=%s`

命令 `:%s/{\d}/%s/g` 使用该命令即可将 {0} {1}… 替换成 %s  其中 \d 是正则标识，代表 0-9的数字


## 元字符一览

- . 匹配任意一个字符
- [abc] 匹配方括号中的任意一个字符。可以使用-表示字符范围，如[a-z0-9]匹 配小写字母和阿拉伯数字。
- [^abc] 在方括号内开头使用^符号，表示匹配除方括号中字符之外的任意字符。
- \d 匹配阿拉伯数字，等同于[0-9]。
- \D 匹配阿拉伯数字之外的任意字符，等同于[^0-9]。
- \x 匹配十六进制数字，等同于[0-9A-Fa-f]。
- \X 匹配十六进制数字之外的任意字符，等同于[^0-9A-Fa-f]。
- \w 匹配单词字母，等同于[0-9A-Za-z_]。
- \W 匹配单词字母之外的任意字符，等同于[^0-9A-Za-z_]。
- \t 匹配<TAB>字符。
- \s 匹配空白字符，等同于[ \t]。
- \S 匹配非空白字符，等同于[^ \t]。

> 另外，如果要查找字符 *、.、/等，则需要在前面用 \ 符号，表示这不是元字符，而只是普通字符而已。

- \* 匹配 * 字符。
- \. 匹配 . 字符。
- \/ 匹配 / 字符。
- \\ 匹配 \ 字符。
- \[ 匹配 [ 字符。

## 表示数量的元字符

- * 匹配0-任意个
- \+ 匹配1-任意个
- \? 匹配0-1个
- \{n,m} 匹配n-m个
- \{n} 匹配n个
- \{n,} 匹配n-任意个
- \{,m} 匹配0-m个

## 表示位置的符号

- $ 匹配行尾
- ^ 匹配行首
- \< 匹配单词词首
- \> 匹配单词词尾

