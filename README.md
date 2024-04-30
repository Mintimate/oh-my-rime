![样式](demo.webp)

- [中文 - 简体简介](README.md)
- [中文 - 繁體簡介](README_zh-CHT.md)
- [English - Brief](README_en.md)

一套快速初始化rime的模板方案，因为平时我使用`oh-my-zsh`，希望大家在用这个模板的时候，有种用`omz`的感觉；所以我给它取名叫`oh-my-rime`，你也可以叫它`薄荷输入法`，亦或者`Mint Input`。

如果你下载遇到困难，使用GitHub Action推送的镜像仓库：
- [oh-my-rime: https://gitlab.mintimate.cn/Mintimate/oh-my-rime](https://gitlab.mintimate.cn/Mintimate/oh-my-rime)

## Oh-my-rime指南

Rime 配置教程：

- [跨平台的开源输入法Rime定制指南，打造强大的个性化输入法](https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili视频(macOS/Windows/Linux): https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Bilibili视频(iOS/Android): https://www.bilibili.com/video/BV1Mr42137Ns](https://www.bilibili.com/video/BV1Mr42137Ns)
- [Youtube視頻: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

如果你有QQ帐号，可以加入群聊（禁止广告）: 703260572

**强烈建议[配合文档: https://www.mintimate.cc](https://www.mintimate.cc)进行操作!!!**

本输入方案内包含： 
- 薄荷拼音-全拼输入: 全拼输入，适合的人群最多，所以也是默认的输入；
- 小鹤双拼-薄荷定制: 基于小鹤双拼，添加定制内容。支持输入音形(形码)；
- 薄荷拼音-小鹤混输: 全拼输入的同时，支持小鹤双拼；
- 地球拼音-薄荷定制: 基于地球拼音，添加定制内容，扩展海量词库；
- 五笔九八-薄荷简版: 基于五笔98的精简版本，期待大家的PR；
- 仓九宫格-全拼输入: 基于「薄荷拼音-全拼输入」，适用于在iOS仓输入法内使用九宫格。

你可以在安装后，使用『Ctrl』+『~』进行切换。（默认激活的是『薄荷拼音-全拼输入』）。

目前薄荷内自带两套皮肤： 水鸭系列、青涩系列。大家可以在鼠须管和小狼毫的个性化配置内自由选择激活，也可以使用自己的配色（推荐[使用 custom 对薄荷配置进行覆写](https://www.mintimate.cc/zh/guide/configurationOverride.html#%E4%BF%AE%E6%94%B9%E8%96%84%E8%8D%B7%E8%BE%93%E5%85%A5%E6%B3%95%E7%9A%84%E9%85%8D%E7%BD%AE)）。

![显示效果](https://www.mintimate.cc/image/demo/themeOfOhMyRime.webp)


### 安装

以下教程，适用于Linux、macOS和Windows（Xp~）

1. 安装[Rime输入法](https://rime.im/)并注销或重启电脑；
2. 下载本仓库所有配置文件到本地rime配置文件；
3. 重新部署Rime
4. 开始使用
5. 根据自己习惯，进行二次修改

> 需要注意: Windows 7 和 Windows Xp只能使用 0.14.3 版本的Weasel，无法使用本输入方案的全部功能，需要手动更新librime支援库：[WinXP和Win7使用薄荷输入法](https://www.mintimate.cc/zh/guide/faQ.html#winxp%E5%92%8Cwin7%E4%BD%BF%E7%94%A8%E8%96%84%E8%8D%B7%E8%BE%93%E5%85%A5%E6%B3%95)

## Tips

本地rime配置文件默认地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
- Linux
  - iBus:` ~/.config/ibus/rime`
  - Fcitx5: `~/.local/share/fcitx5/rime`
- Fctix5 Android(小企鹅入法): `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`

本地rime日志文件默认地址如下：

- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  - iBus:` /tmp`
  
如果你需要在同文输入法内使用，需要一个键盘模板和皮肤，可以使用: [薄荷输入法的”蓝水鸭“和”黑水鸭“皮肤布局](https://www.mintimate.cc/zh/demo/diffAppearance.html#android%E5%A4%96%E8%A7%82)

仓输入法 Hamster 内如何使用九宫格输入？

薄荷方案内，基于[Hamster](https://github.com/imfuxiao/Hamster/) 九宫格布局和[雾凇九宫格](https://github.com/iDvel/rime-ice/blob/main/t9.schema.yaml)移植了九宫格。需要同时启用九宫格方案（输入方案设置）和九宫格布局（键盘设置 - 键盘布局 - 中文 9 键）。

## 配置文件说明

- `default.custom.yaml` 设置输入法、如何切换输入法、翻页等
- `squirrel.yaml` 鼠须管( Mac 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`squirrel.custom.yaml`来覆写。 
- `weasel.yaml` 小狼毫( Win 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`weasel.custom.yaml`来覆写。

配置文件中大部分都有注释，配合教程：[配置覆写](https://www.mintimate.cc/zh/guide/configurationOverride.html)

## 词库定制以及更新

本仓库的词库目录[dicts](dicts)，主要有：
- [雾凇拼音词库](https://github.com/iDvel/rime-ice)
- [98五笔词库](https://github.com/yanhuacuo/98wubi-tables)

详细说明：
```txt
dicts
├── custom_simple.dict.yaml    # 自定义词库（建议自己添加的词库可以放这里）
├── other_emoji.dict.yaml      # emoji 词库
├── other_kaomoji.dict.yaml    # 颜文字词库（按vv进行激活）
├── rime_ice.41448.dict.yaml   # 雾凇词库（GitHub action自动更新）
├── rime_ice.8105.dict.yaml    # 雾凇词库（GitHub action自动更新）
├── rime_ice.base.dict.yaml    # 雾凇词库（GitHub action自动更新）
├── rime_ice.ext.dict.yaml     # 雾凇词库（GitHub action自动更新）
├── rime_ice.cn_en.txt         # 雾凇词库（GitHub action自动更新）
├── rime_ice.en.dict.yaml      # 雾凇词库（GitHub action自动更新）
├── rime_ice.en_ext.dict.yaml  # 雾凇词库（GitHub action自动更新）
├── rime_ice.others.dict.yaml  # 雾凇词库（GitHub action自动更新）
├── terra_pinyin_base.dict.yaml     # 地球拼音自带词库
├── terra_pinyin_ext.dict.yaml      # 地球拼音自带词库
├── terra_rime_ice.base.dict.yaml   # 基于Python脚本自动转换雾凇并Action自动更新
└── wubi98_base.dict.yaml           # 五笔基础词库
```

后续更新词库；可以下载本仓库`dicts`内的文件，除了`custom_simple.dict.yaml`的文件，其他都进行覆盖替换即可。

如果想自己扩展词库，可以在输入法的字典配置文件内进行导入，比如薄荷拼音字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)内：
```yaml
---
name: rime_mint                  # 注意name和文件名一致
version: "2024.02.11"
sort: by_weight
# 此处为 输入法所用到的词库，既补充拓展词库的地方
# 雾凇拼音词库，由Github Robot自动更新
import_tables:
  - dicts/custom_simple          # 自定义
  - dicts/rime_ice.8105          # 霧凇拼音 常用字集合
  - dicts/rime_ice.41448         # 霧凇拼音 完整字集合
  - dicts/rime_ice.base          # 雾凇拼音 https://github.com/iDvel/rime-ice
  - dicts/rime_ice.ext           # 雾凇拼音 https://github.com/iDvel/rime-ice
  - dicts/other_kaomoji          # 颜文字表情（按`vv`呼出)
  - dicts/other_emoji            # Emoji(仅仅作为补充，实际使用一般是OpenCC生效)
  - dicts/rime_ice.others        # 雾凇拼音 others词库（用于自动纠错）
...
```

------

## 支持

- [Mintimate's Blog: https://www.mintimate.cn](https://www.mintimate.cn)
- [Mintimate的爱发电: 加入电圈，支持创造!](https://afdian.net/a/mintimate)
- [Bilibili：@Mintimate](https://space.bilibili.com/355567627)
- [Youtube：@Mintimate](https://www.youtube.com/channel/UCI7LLdUGNzkcKOE7grAqCoA)

## 参考/致谢

1. [Rime-RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
2. [Rime/小狼豪/鼠须管 输入法配置记](https://chenhe.me/post/oh-my-rime)
3. [rime-setting](https://github.com/Iorest/rime-setting)
4. [雾凇拼音 | 长期维护的简体词库](https://github.com/iDvel/rime-ice)
5. [rime-radical-pinyin | Rime 部件拆字输入方案（全拼双拼）](https://github.com/mirtlecn/rime-radical-pinyin)

## 推荐项目

- [98五笔，十分好用的五笔输入方案](http://www.98wubi.com/)
- [雾凇拼音，很优秀的中文词库](https://github.com/iDvel/rime-ice)

> 尤其是雾凇拼音，本方案配置中，大量参考参考了雾凇拼音。词库部分，使用Python同步雾凇拼音的基础词库并启用雾凇拼音默认没有启用的ext扩展词库。

## ⭐⭐⭐

## Star History

<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline&theme=dark" />
<source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
<img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
</picture>
