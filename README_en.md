
![style](demo.webp)

- [中文 - 简体文档](README.md)
- [中文 - 繁體文檔](README_zh-CHT.md)
- [English - Documentation](README_en.md)

A template for quickly initializing Rime. Since I use `oh-my-zsh` normally and get a similar feeling when using Rime, I named it `oh-my-rime`. You can also call it `BoHe PinYin` or `Mint`.

## Oh-my-rime guide

rime configuration tutorial:
- [Cross-platform open source input method Rime customization guide, create a powerful personalized input method] (https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili Video: https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Youtube Video: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

You have a QQ account, you can join the group chat(No Ads!): 703260572

**It is strongly recommended to refer to the [documentation ↗](https://www.mintimate.cc) for operation!!!**

### Install

The following tutorials are available for Linux, macOS and Windows (Xp~)

0. Install [Rime Input Method](https://rime.im/) and log out or restart the computer;
1. Download all the configuration files of this warehouse to the local rime configuration file;
2. Redeploy Rime (Windows and Linux may need to configure word segmentation dependencies to use EasyEN, reference: [EasyEn](https://github.com/BlindingDark/rime-easy-en))
3. Get started

## Tips
The default address of the local rime configuration file is as follows

-Windows
  - Weasel: `%APPDATA%\Rime`
-Mac OS X
  - Squirrel: `~/Library/Rime`
- Linux
  - iBus: `~/.config/ibus/rime`
  
The default address of the local rime log file is as follows:
-Windows
  - Weasel: `%TEMP%`
-Mac OS X
  - Squirrel: `$TMPDIR`
- Linux
  -iBus:`/tmp`



## Configuration file description

- `default.custom.yaml` set the input method, how to switch the input method, turn the page, etc.
- `double_pinyin_flypy.custom.yaml` double pinyin scheme,
- `squirrel.custom.yaml` mouse whisker tube (Mac version) to set which software defaults to English input, input method skin, etc.
- `weasel.custom.yaml` Xiaolanghao (Win version) sets which software defaults to English input, input method skin, etc.
- `custom_phrase.txt` set shortcut input, after the modification is completed, it needs to be re-deployed to take effect

Most of the configuration files are commented.

------

## Support

- [Mintimate's Blog: https://www.mintimate.cn](https://www.mintimate.cn)
- [Mintimate's 爱发电: Join the electric circle and support creation!](https://afdian.net/a/mintimate)
- [Bilibili: @Mintimate](https://space.bilibili.com/355567627)
- [Youtube: @Mintimate](https://www.youtube.com/channel/UCI7LLdUGNzkcKOE7grAqCoA)


## References/Acknowledgments

1. [Rime-RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
2. [Rime/Xiaolanghao/Shuxuguan Input Method Configuration Notes](https://chenhe.me/post/oh-my-rime)
3. [rime-setting](https://github.com/Iorest/rime-setting)
4. [rime-ice | The long-term maintenance version of Simplified Chinese Characters](https://github.com/iDvel/rime-ice)

## Other Recommended
- [98 Wubi, a very useful Wubi input program](http://www.98wubi.com/)
- [Rime Pinyin, an excellent Chinese thesaurus](https://github.com/iDvel/rime-ice)

## ⭐⭐⭐

[![⭐⭐⭐](https://starchart.cc/Mintimate/oh-my-rime.svg)](https://starchart.cc/Mintimate/oh-my-rime)
