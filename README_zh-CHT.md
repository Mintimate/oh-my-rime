![樣式](./demo.webp)

- [中文 - 簡體簡介](README.md)
- [中文 - 繁體簡介](README_zh-CHT.md)
- [English - Brief](README_en.md)

一套快速初始化rime的模闆方案，因為平時我使用`oh-my-zsh`，希望大家在用這個模闆的時候，有種用`omz`的感覺；所以我給它取名叫`oh-my-rime`，妳也可以叫它`薄荷輸入法`，亦或者`Mint Input`。

如果妳下載遇到睏難，使用GitHub Action推送的鏡像倉庫：

- [oh-my-rime: https://cnb.cool/Mintimate/rime/oh-my-rime](https://cnb.cool/Mintimate/rime/oh-my-rime)

或者，妳只是想下載薄荷方案，併不需要用 Git 克隆倉庫；那麽下載遇到睏難，可以使用 [CNB](https://cnb.cool/Mintimate/rime/oh-my-rime) 自動流水線打包的壓縮包:

- [oh-my-rime.zip: https://cnb.cool/Mintimate/rime/oh-my-rime/-/releases/download/latest/oh-my-rime.zip](https://cnb.cool/Mintimate/rime/oh-my-rime/-/releases/download/latest/oh-my-rime.zip)

2025-07-09 破壞性變更: 
- 詞庫從白霜詞庫切換到萬象詞庫以提升地球拼音的體驗，同時更加兼容萬象模型的掛載。
- 詞庫內拼音文件更名為`rime_mint`開頭，方便後續維護。

因為破壞性變更，當前還需要解決問題:
- [x] 切換為萬象詞庫後，用戶詞典(.userdb)需要腳本刷寫。否則音調無法顯示。提供[離線工具以方便用戶遷移](https://www.mintimate.cc/zh/guide/faQ.html#%E7%94%A8%E6%88%B7%E8%AF%8D%E5%85%B8%E9%9F%B3%E6%A0%87%E8%BD%AC%E5%86%99)。
- [x] 萬象預編輯腳本和糾錯腳本沖突問題已經解決，但是糾錯樣式和萬象詞庫的樣式一致，無法區分，考慮後續是否調整。

## Oh-my-rime指南

Rime 配置教程：

- [跨平臺的開源輸入法Rime定制指南，打造強大的個性化輸入法](https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili視訊(macOS/Windows/Linux): https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Bilibili視訊(iOS/Android): https://www.bilibili.com/video/BV1Mr42137Ns](https://www.bilibili.com/video/BV1Mr42137Ns)
- [Youtube視頻: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

如果妳有QQ帳號，可以加入群聊（禁止廣告）: 703260572

**強烈建議[配合文檔: https://www.mintimate.cc](https://www.mintimate.cc)進行操作!!!**
> 項目文檔 CDN 加速及安全防護由 [Tencent EdgeOne](https://edgeone.ai/zh?from=github) 贊助。<br/><img src="https://edgeone.ai/media/34fe3a45-492d-4ea4-ae5d-ea1087ca7b4b.png" alt="Tencent EdgeOne" height="20">


本輸入方案內包含：

- 薄荷拼音-全拼輸入: 全拼輸入，適合的人群最多，所以也是預設的輸入；
- 小鶴雙拼-薄荷定制: 基於小鶴雙拼，添加定制內容。支援輸入音形(形碼)、自然碼輔助碼或墨奇輔助碼作為輔助輸入；
- 薄荷拼音-小鶴混輸: 全拼輸入的同時，支援小鶴雙拼；
- 地球拼音-薄荷定制: 基於地球拼音，添加定制內容，擴展海量詞庫；
- 五筆98-五筆小築: 基於[98wubi](https://github.com/yanhuacuo/98wubi)的精簡版本，期待大家的PR。如果想要更好的體驗(五筆、拼音混輸入等)，歡迎使用五筆98團隊做的[五筆98](https://github.com/yanhuacuo/98wubi)；
- 五筆86-極點五筆: 基於[wubi86-jidian](https://github.com/KyleBing/rime-wubi86-jidian)的精簡版本，期待大家的PR。如果想要更好的體驗(五筆、拼音混輸入等)，歡迎使用[rime-wubi86-jidian](https://github.com/KyleBing/rime-wubi86-jidian)；
- 倉九宮格-全拼輸入: 基於「薄荷拼音-全拼輸入」，適用於在iOS倉輸入法內使用九宮格；如果有其他方案的九宮格需求，可以基於本方案修改。

妳可以在安裝後，使用『Ctrl』+『~』進行切換。（預設激活的是『薄荷拼音-全拼輸入』）。

目前薄荷內自帶兩套皮膚： 水鴨繫列、青澀繫列。大家可以在鼠須管和小狼毫的個性化配置內自由選擇激活，也可以使用自己的配色（推薦[使用 custom 對薄荷配置進行覆寫](https://www.mintimate.cc/zh/guide/configurationOverride.html#%E4%BF%AE%E6%94%B9%E8%96%84%E8%8D%B7%E8%BE%93%E5%85%A5%E6%B3%95%E7%9A%84%E9%85%8D%E7%BD%AE)）。

![顯示效果](https://www.mintimate.cc/image/demo/themeOfOhMyRime.webp)

### 安裝

以下教程，適用於Linux、macOS和Windows（Xp~）

1. 安裝[Rime輸入法](https://rime.im/)併登出或重啟電腦；
2. 下載本倉庫所有配置文件到在地rime配置文件；
3. 重新部署Rime
4. 開始使用
5. 根據自己習慣，進行二次修改

> 需要註意: Windows 7 和 Windows Xp只能使用 0.14.3 版本的Weasel，無法使用本輸入方案的全部功能，需要手動更新librime支援庫：[WinXP和Win7使用薄荷輸入法](https://www.mintimate.cc/zh/guide/faQ.html#winxp%E5%92%8Cwin7%E4%BD%BF%E7%94%A8%E8%96%84%E8%8D%B7%E8%BE%93%E5%85%A5%E6%B3%95)

## Tips

在地rime配置文件預設地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
  - Fcitx5 macOS: `~/.local/share/fcitx5/rime`
- Linux
  - iBus:`~/.config/ibus/rime`
  - Fcitx5: `~/.local/share/fcitx5/rime`
- Fctix5 Android(小企鵝入法): `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`

在地rime日誌文件預設地址如下：

- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  - iBus:`/tmp`
  
倉輸入法 Hamster 內如何使用九宮格輸入？

薄荷方案內，基於[Hamster](https://github.com/imfuxiao/Hamster/) 九宮格佈局和[霧凇九宮格](https://github.com/iDvel/rime-ice/blob/main/t9.schema.yaml)移植了九宮格。需要同時啟用九宮格方案（輸入方案設定）和九宮格佈局（鍵盤設定 - 鍵盤佈局 - 中文 9 鍵）。

如果妳喜歡使用 Rime 打一些長句，那麽強烈建議配合語言模型來使用。參考教程:
- [Rime 內如何配置語言模型 -- 薄荷輸入配置教程](https://www.mintimate.cc/zh/guide/languageModel.html)

## 配置文件說明

- `default.yaml` 設定輸入法、如何切換輸入法、翻頁等；建議自行創建`default.custom.yaml`來覆寫薄荷配置的`default.yaml`.
- `squirrel.yaml` 鼠須管( Mac 版本 )設定哪些軟體預設英文輸入，輸入法皮膚等；如需自定義，建議自行創建`squirrel.custom.yaml`來覆寫。
- `weasel.yaml` 小狼毫( Win 版本 )設定哪些軟體預設英文輸入，輸入法皮膚等；如需自定義，建議自行創建`weasel.custom.yaml`來覆寫。

配置文件中大部分都有註釋，配合教程：[配置覆寫](https://www.mintimate.cc/zh/guide/configurationOverride.html)

## 詞庫定制以及更新

本倉庫的詞庫目錄[dicts](dicts)，主要有：

- [霧凇拼音詞庫](https://github.com/iDvel/rime-ice)
- [白霜詞庫](https://github.com/gaboolic/rime-frost)
- [萬象詞庫](https://github.com/amzxyz/RIME-LMDG)
- [98五筆詞庫](https://github.com/yanhuacuo/98wubi-tables)
- [86五筆詞庫](https://github.com/KyleBing/rime-wubi86-jidian)

詳細說明：

```txt
dicts
├── custom_simple.dict.yaml    # 自定義詞庫（建議自己添加的詞庫可以放這裏）
├── other_emoji.dict.yaml      # emoji 詞庫
├── other_kaomoji.dict.yaml    # 顏文字詞庫（按vv進行激活）
├── rime_ice.ext.dict.yaml     # 白霜詞庫（GitHub action自動更新）
├── rime_ice.cn_en.txt         # 白霜詞庫（GitHub action自動更新）
├── rime_ice.en.dict.yaml      # 白霜詞庫（GitHub action自動更新）
├── rime_ice.en_ext.dict.yaml  # 白霜詞庫（GitHub action自動更新）
├── rime_ice.others.dict.yaml  # 白霜詞庫（GitHub action自動更新）
├── rime_mint.base.dict.yaml            # 萬象詞庫（GitHub action自動更新）
├── rime_mint.chars.dict.yaml           # 萬象詞庫（GitHub action自動更新）
├── rime_mint.correlation.dict.yaml     # 萬象詞庫（GitHub action自動更新）
├── rime_mint.ext.dict.yaml             # 萬象詞庫（GitHub action自動更新）
├── wubi86_core.dict.yaml           # 86版五筆基礎詞庫
└── wubi98_base.dict.yaml           # 98版五筆基礎詞庫
```

後續更新詞庫；可以下載本倉庫`dicts`內的文件，除了`custom_simple.dict.yaml`的文件，其他都進行覆蓋替換即可。

如果想自己擴展詞庫，可以在輸入法的字典配置文件內進行導入，比如「薄荷拼音-全拼輸入」的字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)內：

```yaml
---
name: rime_mint                  # 註意name和文件名一致
version: "2025.07.06"
sort: by_weight
use_preset_vocabulary: false
# 此處為 輸入法所用到的詞庫，既補充拓展詞庫的地方
# 霧凇拼音詞庫，由Github Robot自動更新
import_tables:
  - dicts/custom_simple          # 自定義
  - dicts/rime_mint.chars        # 單字詞庫（萬象拼音詞庫基礎版本）
  - dicts/rime_mint.base         # 基礎詞庫（萬象拼音詞庫基礎版本）
  - dicts/rime_mint.correlation  # 關聯詞庫（萬象拼音詞庫基礎版本）
  - dicts/rime_mint.ext          # 聯想詞庫（萬象拼音詞庫基礎版本）
  - dicts/other_kaomoji          # 顏文字錶情（按`VV`呼出)
  - dicts/rime_ice.others        # 霧凇拼音 others詞庫（用於自動糾錯）
  # 20240608 Emoji完全交由OpenCC，不再使用字典作為補充
  # - dicts/other_emoji            # Emoji(僅僅作為補充，實際使用一般是OpenCC生效)
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
6. [86五筆極點碼錶](https://github.com/KyleBing/rime-wubi86-jidian)
7. [Extending RIME with Lua scripts](https://github.com/hchunhui/librime-lua/wiki/Scripting)
8. [白霜詞庫 | 基於霧凇拼音重制的，更純凈、詞頻准確、智能的詞庫](https://github.com/gaboolic/rime-frost)
9. [萬象詞庫 | Rime輸入法文法模型全流程構建教程，全局帶聲調詞庫，最全聲調標註工具鏈](https://github.com/amzxyz/RIME-LMDG)

## 推薦項目

- [98五筆，十分好用的98五筆輸入方案](https://wubi98.github.io/)
- [86五筆極點碼錶，rime上的86五筆方案](https://github.com/KyleBing/rime-wubi86-jidian)
- [霧凇拼音，很優秀的中文詞庫](https://github.com/iDvel/rime-ice)
- [萬象拼音，強大到復雜的拼音方案](https://github.com/amzxyz/rime_wanxiang)

> 薄荷的詞庫: ① 在`2024-07-29`起，拼音詞庫使用白霜詞庫，此前使用霧凇拼音詞庫；② 在`2025-07-09`起，詞庫使用萬象拼音詞庫。

## Star History

<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline&theme=dark" />
<source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
<img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
</picture>

## Contributors ✨
<a href="https://github.com/Mintimate/oh-my-rime/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Mintimate/oh-my-rime" />
</a>
