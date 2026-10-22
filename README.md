# 人际塔罗启示

一款以 SwiftUI 构建的塔罗牌体验，带领用户设定问题、洗牌与切牌、抽牌，并查看牌面解读。

## 环境要求

- macOS 26.5 或更新版本
- Xcode 27.1 或更新版本

## 构建

在 Xcode 中打开 `Tarot.xcodeproj`，选择 `Tarot` scheme 和 macOS 目标，然后运行或归档。

也可以在终端构建：

```sh
xcodebuild -project Tarot.xcodeproj -scheme Tarot -configuration Release -destination 'platform=macOS' -derivedDataPath /tmp/TarotDerived CODE_SIGNING_ALLOWED=NO build
```

发布页提供可直接安装的 macOS DMG。

## 许可

本项目采用 MIT License，详见 [LICENSE](LICENSE)。
