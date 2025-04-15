![样式](https://www.mintimate.cc/image/demo/guide.webp)

- [中文 - 简体简介](README.md)
- [中文 - 繁體簡介](README_zh-CHT.md)
- [English - Brief](README_en.md)

一套快速初始化rime的模板方案，因为平时我使用`oh-my-zsh`，希望大家在用这个模板的时候，有种用`omz`的感觉；所以我给它取名叫`oh-my-rime`，你也可以叫它`薄荷输入法`，亦或者`Mint Input`。

如果你下载遇到困难，使用GitHub Action推送的镜像仓库：

- [oh-my-rime: https://cnb.cool/Mintimate/rime/oh-my-rime](https://cnb.cool/Mintimate/rime/oh-my-rime)

或者，你只是想下载薄荷方案，并不需要用 Git 克隆仓库；那么下载遇到困难，可以使用 [CNB](https://cnb.cool/Mintimate/rime/oh-my-rime) 自动流水线打包的压缩包:

- [oh-my-rime.zip: https://cnb.cool/Mintimate/rime/oh-my-rime/-/releases/download/latest/oh-my-rime.zip](https://cnb.cool/Mintimate/rime/oh-my-rime/-/releases/download/latest/oh-my-rime.zip)

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
- 小鹤双拼-薄荷定制: 基于小鹤双拼，添加定制内容。支持输入音形(形码)、自然码辅助码或墨奇辅助码作为辅助输入；
- 薄荷拼音-小鹤混输: 全拼输入的同时，支持小鹤双拼；
- 地球拼音-薄荷定制: 基于地球拼音，添加定制内容，扩展海量词库；
- 五笔98-五笔小筑: 基于[98wubi](https://github.com/yanhuacuo/98wubi)的精简版本，期待大家的PR。如果想要更好的体验(五笔、拼音混输入等)，欢迎使用五笔98团队做的[五笔98](https://github.com/yanhuacuo/98wubi)；
- 五笔86-极点五笔: 基于[wubi86-jidian](https://github.com/KyleBing/rime-wubi86-jidian)的精简版本，期待大家的PR。如果想要更好的体验(五笔、拼音混输入等)，欢迎使用[rime-wubi86-jidian](https://github.com/KyleBing/rime-wubi86-jidian)；
- 仓九宫格-全拼输入: 基于「薄荷拼音-全拼输入」，适用于在iOS仓输入法内使用九宫格；如果有其他方案的九宫格需求，可以基于本方案修改。

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
  - Fcitx5 macOS: `~/.local/share/fcitx5/rime`
- Linux
  - iBus:`~/.config/ibus/rime`
  - Fcitx5: `~/.local/share/fcitx5/rime`
- Fctix5 Android(小企鹅入法): `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`

本地rime日志文件默认地址如下：

- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  - iBus:`/tmp`
  
仓输入法 Hamster 内如何使用九宫格输入？

薄荷方案内，基于[Hamster](https://github.com/imfuxiao/Hamster/) 九宫格布局和[雾凇九宫格](https://github.com/iDvel/rime-ice/blob/main/t9.schema.yaml)移植了九宫格。需要同时启用九宫格方案（输入方案设置）和九宫格布局（键盘设置 - 键盘布局 - 中文 9 键）。

如果你喜欢使用 Rime 打一些长句，那么强烈建议配合语言模型来使用。参考教程:
- [Rime 内如何配置语言模型 -- 薄荷输入配置教程](https://www.mintimate.cc/zh/guide/languageModel.html)

## 配置文件说明

- `default.yaml` 设置输入法、如何切换输入法、翻页等；建议自行创建`default.custom.yaml`来覆写薄荷配置的`default.yaml`.
- `squirrel.yaml` 鼠须管( Mac 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`squirrel.custom.yaml`来覆写。
- `weasel.yaml` 小狼毫( Win 版本 )设置哪些软件默认英文输入，输入法皮肤等；如需自定义，建议自行创建`weasel.custom.yaml`来覆写。

配置文件中大部分都有注释，配合教程：[配置覆写](https://www.mintimate.cc/zh/guide/configurationOverride.html)

## 词库定制以及更新

本仓库的词库目录[dicts](dicts)，主要有：

- [雾凇拼音词库](https://github.com/iDvel/rime-ice)
- [白霜词库词库](https://github.com/gaboolic/rime-frost)
- [98五笔词库](https://github.com/yanhuacuo/98wubi-tables)
- [86五笔词库](https://github.com/KyleBing/rime-wubi86-jidian)

详细说明：

```txt
dicts
├── custom_simple.dict.yaml    # 自定义词库（建议自己添加的词库可以放这里）
├── other_emoji.dict.yaml      # emoji 词库
├── other_kaomoji.dict.yaml    # 颜文字词库（按vv进行激活）
├── rime_ice.41448.dict.yaml   # 白霜词库（GitHub action自动更新）
├── rime_ice.8105.dict.yaml    # 白霜词库（GitHub action自动更新）
├── rime_ice.base.dict.yaml    # 白霜词库（GitHub action自动更新）
├── rime_ice.ext.dict.yaml     # 白霜词库（GitHub action自动更新）
├── rime_ice.cn_en.txt         # 白霜词库（GitHub action自动更新）
├── rime_ice.en.dict.yaml      # 白霜词库（GitHub action自动更新）
├── rime_ice.en_ext.dict.yaml  # 白霜词库（GitHub action自动更新）
├── rime_ice.others.dict.yaml  # 白霜词库（GitHub action自动更新）
├── terra_pinyin_base.dict.yaml     # 地球拼音自带词库
├── terra_pinyin_ext.dict.yaml      # 地球拼音自带词库
├── terra_rime_ice.base.dict.yaml   # 基于Python脚本自动转换词库，Action自动更新
├── wubi86_core.dict.yaml           # 86版五笔基础词库
└── wubi98_base.dict.yaml           # 98版五笔基础词库
```

后续更新词库；可以下载本仓库`dicts`内的文件，除了`custom_simple.dict.yaml`的文件，其他都进行覆盖替换即可。

如果想自己扩展词库，可以在输入法的字典配置文件内进行导入，比如「薄荷拼音-全拼输入」的字典配置文件[rime_mint.dict.yaml](rime_mint.dict.yaml)内：

```yaml
---
name: rime_mint                  # 注意name和文件名一致
version: "2024.02.11"
sort: by_weight
# 此处为 输入法所用到的词库，既补充拓展词库的地方
# 词库，由Github Robot自动更新
import_tables:
  - dicts/custom_simple          # 自定义
  - dicts/rime_ice.8105          # 白霜词库 常用字集合
  - dicts/rime_ice.41448         # 白霜词库 完整字集合
  - dicts/rime_ice.base          # 白霜词库 https://github.com/gaboolic/rime-frost
  - dicts/rime_ice.ext           # 白霜词库 https://github.com/gaboolic/rime-frost
  - dicts/other_kaomoji          # 颜文字表情（按`VV`呼出)
  - dicts/other_emoji            # Emoji(已禁用，目前Emoji是OpenCC生效)
  - dicts/rime_ice.others        # 白霜词库 others词库（用于自动纠错）
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
6. [86五笔极点码表](https://github.com/KyleBing/rime-wubi86-jidian)
7. [Extending RIME with Lua scripts](https://github.com/hchunhui/librime-lua/wiki/Scripting)
8. [白霜词库 | 基于雾凇拼音重制的，更纯净、词频准确、智能的词库](https://github.com/gaboolic/rime-frost)

## 推荐项目

- [98五笔，十分好用的98五笔输入方案](https://wubi98.github.io/)
- [86五笔极点码表，rime上的86五笔方案](https://github.com/KyleBing/rime-wubi86-jidian)
- [雾凇拼音，很优秀的中文词库](https://github.com/iDvel/rime-ice)

> 尤其是雾凇拼音，本方案配置中，大量参考参考了雾凇拼音。词库部分，在`2024-07-29`起，拼音词库使用白霜词库，此前使用雾凇拼音词库。

## ⭐⭐⭐

## Star History

<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline&theme=dark" />
<source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
<img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Mintimate/oh-my-rime&type=Timeline" />
</picture>
