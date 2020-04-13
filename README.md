# Icon
iPhone アプリに必要なアイコンを生成するコマンドラインツール

## How to use

-i: 大本の画像の指定
-o: 変換後にIconsのディレクトリを作成する先

仮に、デスクトップに大もとの画像（1024x1024.png）がDesktopにあって、出力もDesktopにする場合
main.swfit がある階層までいき、以下のような入力を行います。

```
$ swift main.swift -i ~/Desktop/1024x1024.png -o ~/Desktop
```

また、main.swiftの海藻で、以下の手順を行うと `icon` コマンドにすることができます。
main.swiftと同じ階層でなくても実行することができるようになります。

```
$ swiftc -o icon main.swift
$ cp -f icon /usr/local/bin/
$ cd ~
$ swift icon -i ~/Desktop/1024x1024.png -o ~/Desktop
```
