
![样式](demo.jpg)

- [中文 - 简体文档](README.md)
- [中文 - 繁體文檔](README_zh-CHT.md)
- [English - Documentation](README_en.md)

## Oh-my-rime指南

rime配置教程：
- [跨平台的开源输入法Rime定制指南，打造强大的个性化输入法](https://www.mintimate.cn/2023/03/18/rimeQuickInit)
- [Bilibili視頻: https://www.bilibili.com/video/BV12M411T7gf](https://www.bilibili.com/video/BV12M411T7gf)
- [Youtube視頻: https://www.youtube.com/watch?v=yc4AivDDpMM](https://www.youtube.com/watch?v=yc4AivDDpMM)

如果你有QQ帐号，可以加入群聊（禁止广告）: 703260572
(哈哈，QQ群我才创建，目前人很少；甚至可能就我一个人(╯—﹏—)╯（ ┷━━━┷ )

### 安装

以下教程，适用于Linux、macOS和Windows（Xp~）

0. 安装[Rime输入法](https://rime.im/)并注销或重启电脑；
1. 下载本仓库所有配置文件到本地rime配置文件；
2. 重新部署Rime（Windows、Linux可能需要配置分词依赖才可以使用EasyEN，参考：[EasyEn](https://github.com/BlindingDark/rime-easy-en)）
3. 开始使用

## Tips
本地rime配置文件默认地址，如下

- Windows
  - Weasel: `%APPDATA%\Rime`
- Mac OS X
  - Squirrel: `~/Library/Rime`
- Linux
  - iBus:` ~/.config/ibus/rime`
  
本地rime日志文件默认地址如下：
- Windows
  - Weasel: `%TEMP%`
- Mac OS X
  - Squirrel: `$TEMPDIR`
- Linux
  - iBus:` /tmp`



## 配置文件说明

- `default.custom.yaml` 设置输入法、如何切换输入法、翻页等
- `double_pinyin_flypy.custom.yaml` 双拼方案，
- `squirrel.custom.yaml` 鼠须管( Mac 版本 )设置哪些软件默认英文输入，输入法皮肤等
- `weasel.custom.yaml` 小狼毫( Win 版本 )设置哪些软件默认英文输入，输入法皮肤等
- `custom_phrase.txt` 设置快捷输入，修改完成后要重新部署才能生效

配置文件中大部分都有注释。

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
