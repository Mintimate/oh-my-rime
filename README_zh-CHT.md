
![样式](demo.webp)

- [中文 - 简体文档](README.md)
- [中文 - 繁體文檔](README_zh-CHT.md)
- [English - Documentation](README_en.md)

一套快速初始化rime的模闆，因為平時我使用`oh-my-zsh`，在使用rime時候，有種用`omz`的感覺；所以我給它取名叫`oh-my-rime`，妳也可以叫它`薄荷拼音`，亦或者`Mint`。

## Oh-my-rime指南

rime配置教程：
- [跨平臺的開源輸入法Rime定製指南，打造強大的個性化輸入法](https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili視頻: https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Youtube視頻: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

如果你有QQ帳號，可以加入群聊（禁止廣告）: 703260572

**強烈建議[配合文檔](https://www.mintimate.cc)進行操作!!!**


### 安裝

以下教程，適用於Linux、macOS和Windows（Xp~）

0. 安裝[Rime輸入法](https://rime.im/)並註銷或重啟電腦；
1. 下載本倉庫所有配置文件到本地rime配置文件；
2. 重新部署Rime（Windows、Linux可能需要配置分詞依賴才可以使用EasyEN，參考：[EasyEn](https://github.com/BlindingDark/rime-easy-en)）　
3. 開始使用

## Tips
本地rime配置文件默認地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
- Linux
  - iBus:` ~/.config/ibus/rime`
  
本地rime日誌文件默認地址如下：
- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  - iBus:` /tmp`



## 配置文件說明

- `default.custom.yaml` 設置輸入法、如何切換輸入法、翻頁等
- `double_pinyin_flypy.custom.yaml` 雙拼方案，
- `squirrel.custom.yaml` 鼠須管( Mac 版本 )設置哪些軟件默認英文輸入，輸入法皮膚等
- `weasel.custom.yaml` 小狼毫( Win 版本 )設置哪些軟件默認英文輸入，輸入法皮膚等
- `custom_phrase.txt` 設置快捷輸入，修改完成後要重新部署才能生效

配置文件中大部分都有註釋。

------

## 支持

- [Mintimate's Blog: https://www.mintimate.cn](https://www.mintimate.cn)
- [Mintimate的爱发电: 加入电圈，支持创造!](https://afdian.net/a/mintimate)
- [Bilibili：@Mintimate](https://space.bilibili.com/355567627)
- [Youtube：@Mintimate](https://www.youtube.com/channel/UCI7LLdUGNzkcKOE7grAqCoA)


## 參考/致謝

1. [Rime-RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
2. [Rime/小狼豪/鼠須管 輸入法配置記](https://chenhe.me/post/oh-my-rime)
3. [rime-setting](https://github.com/Iorest/rime-setting)
4. [雾凇拼音 | 长期维护的简体词库](https://github.com/iDvel/rime-ice)

## 推薦項目
- [98五筆，十分好用的五筆輸入方案](http://www.98wubi.com/)
- [霧凇拼音，很優秀的中文詞庫](https://github.com/iDvel/rime-ice)


## ⭐⭐⭐

<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline&theme=dark" />
<source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
<img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
</picture>
