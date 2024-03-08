
![样式](demo.webp)

- [中文 - 简体文档](README.md)
- [中文 - 繁體文檔](README_zh-CHT.md)
- [English - Documentation](README_en.md)

一套快速初始化rime的模闆，因為平時我使用`oh-my-zsh`，在使用rime時候，有種用`omz`的感覺；所以我給它取名叫`oh-my-rime`，妳也可以叫它`薄荷輸入法`，亦或者`Mint Input`。

如果妳下載遇到睏難，使用GitHub Action推送的鏡像倉庫：
- [oh-my-rime: https://gitlab.mintimate.cn/Mintimate/oh-my-rime](https://gitlab.mintimate.cn/Mintimate/oh-my-rime)

## Oh-my-rime指南

rime配置教程：
- [跨平臺的開源輸入法Rime定製指南，打造強大的個性化輸入法](https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili視頻: https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Youtube視頻: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

如果你有QQ帳號，可以加入群聊（禁止廣告）: 703260572

**強烈建議[配合文檔](https://www.mintimate.cc)進行操作!!!**

本輸入方案內包含： 
- 薄荷拼音-全拼輸入: 全拼輸入，適合的人群最多，所以也是預設的輸入；
- 小鶴雙拼-薄荷定制: 基於小鶴雙拼，添加定制內容。支援輸入音形(形碼)；
- 薄荷拼音-小鶴混輸: 全拼輸入的同時，支援小鶴雙拼；
- 地球拼音-薄荷定制: 基於地球拼音，添加定制內容，擴展海量詞庫；
- 五筆九八-薄荷簡版: 基於五筆98的精簡版本，期待大家的PR。

妳可以在安裝後，使用『Ctrl』+『~』進行切換。（預設激活的是『薄荷拼音』）。

### 安裝

以下教程，適用於Linux、macOS和Windows（Xp~）

0. 安裝[Rime輸入法](https://rime.im/)並註銷或重啟電腦；
1. 下載本倉庫所有配置文件到本地rime配置文件；
2. 重新部署Rime
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
- `squirrel.custom.yaml` 鼠須管( Mac 版本 )設置哪些軟件默認英文輸入，輸入法皮膚等
- `weasel.custom.yaml` 小狼毫( Win 版本 )設置哪些軟件默認英文輸入，輸入法皮膚等

配置文件中大部分都有註釋。

## 詞庫定制以及更新

本倉庫的詞庫目錄[dicts](dicts)，主要有：
- [霧凇拼音詞庫](https://github.com/iDvel/rime-ice)
- [98五筆詞庫](https://github.com/yanhuacuo/98wubi-tables)

詳細說明：
```txt
dicts
├── custom_simple.dict.yaml    # 自定義詞庫（建議自己添加的詞庫可以放這裏）
├── other_emoji.dict.yaml      # emoji 詞庫
├── other_kaomoji.dict.yaml    # 顏文字詞庫（按vv進行激活）
├── rime_ice.41448.dict.yaml   # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.8105.dict.yaml    # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.base.dict.yaml    # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.ext.dict.yaml     # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.cn_en.txt         # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.en.dict.yaml      # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.en_ext.dict.yaml  # 霧凇詞庫（GitHub action自動更新）
├── rime_ice.others.dict.yaml  # 霧凇詞庫（GitHub action自動更新）
├── terra_pinyin_base.dict.yaml     # 地球拼音自帶詞庫
├── terra_pinyin_ext.dict.yaml      # 地球拼音自帶詞庫
├── terra_rime_ice.base.dict.yaml   # 基於Python腳本自動轉換霧凇併Action自動更新
└── wubi98_base.dict.yaml           # 五筆基礎詞庫
```

後續更新詞庫；可以下載本倉庫`dicts`內的文件，除了`custom_simple.dict.yaml`的文件，其他都進行覆蓋替換即可。

如果想自己擴展詞庫，可以在輸入法的字典配置文件內進行導入，比如薄荷拼音字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)內：
```yaml
---
name: rime_mint                  # 註意name和文件名一致
version: "2024.02.11"
sort: by_weight
# 此處為 輸入法所用到的詞庫，既補充拓展詞庫的地方
# 霧凇拼音詞庫，由Github Robot自動更新
import_tables:
  - dicts/custom_simple          # 自定義
  - dicts/rime_ice.8105          # 霧凇拼音 常用字集合
  - dicts/rime_ice.41448         # 霧凇拼音 完整字集合
  - dicts/rime_ice.base          # 霧凇拼音 https://github.com/iDvel/rime-ice
  - dicts/rime_ice.ext           # 霧凇拼音 https://github.com/iDvel/rime-ice
  - dicts/other_kaomoji          # 顏文字錶情（按`vv`呼出)
  - dicts/other_emoji            # Emoji(僅僅作為補充，實際使用一般是OpenCC生效)
  - dicts/rime_ice.others        # 霧凇拼音 others詞庫（用於自動糾錯）
...
```

------

## 支援

- [Mintimate's Blog: https://www.mintimate.cn](https://www.mintimate.cn)
- [Mintimate的愛發電: 加入電圈，支援創造!](https://afdian.net/a/mintimate)
- [Bilibili：@Mintimate](https://space.bilibili.com/355567627)
- [Youtube：@Mintimate](https://www.youtube.com/channel/UCI7LLdUGNzkcKOE7grAqCoA)

## 參考/致謝

1. [Rime-RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
2. [Rime/小狼豪/鼠須管 輸入法配置記](https://chenhe.me/post/oh-my-rime)
3. [rime-setting](https://github.com/Iorest/rime-setting)
4. [霧凇拼音 | 長期維護的簡體詞庫](https://github.com/iDvel/rime-ice)
5. [rime-radical-pinyin | Rime 部件拆字輸入方案（全拼雙拼）](https://github.com/mirtlecn/rime-radical-pinyin)

## 推薦項目

- [98五筆，十分好用的五筆輸入方案](http://www.98wubi.com/)
- [霧凇拼音，很優秀的中文詞庫](https://github.com/iDvel/rime-ice)

## ⭐⭐⭐

<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline&theme=dark" />
<source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
<img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
</picture>
