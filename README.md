# JSLocker

<p align="center">
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-red.svg"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/swift%20version-5.0-orange.svg"></a>
<a href="https://github.com/spirit-jsb/JSLocker/"><img src="https://img.shields.io/cocoapods/v/JSLocker.svg?style=flat"></a>
<a href="https://github.com/spirit-jsb/JSLocker/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/JSLocker.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/JSLocker"><img src="https://img.shields.io/cocoapods/p/JSLocker.svg?style=flat"></a>
</p>

## 示例代码

如需要运行示例项目，请 `clone` 当前 `repo` 到本地，然后从根目录下执行 `JSLocker.xcworkspace`，打开项目后切换 `Scheme` 至 `JSLocker-Demo` 即可。

## 基本使用
```swift
public enum JSLockerPresentationDirection: Int {
    case down
    case up
}

public enum JSLockerResizingBehavior: Int {
    case none
    case dismiss
    case dismissOrExpand
}

@objc public protocol JSLockerControllerDelegate: class {
    
    @objc optional func lockerControllerDidChangeExpandedState(_ controller: JSLockerController)
    @objc optional func lockerControllerWillDismiss(_ controller: JSLockerController)
    @objc optional func lockerControllerDidDismiss(_ controller: JSLockerController)
}
```

```swift
public init(sourceView: UIView, sourceRect: CGRect, origin: CGFloat = -1.0, direction: JSLockerPresentationDirection)

public init(barButtonItem: UIBarButtonItem, origin: CGFloat = -1.0, direction: JSLockerPresentationDirection)
```

基本使用方法请参考示例代码。

## Swift 版本依赖
| Swift | JSLocker |
| ------| ---------|
| 5.0   | >= 1.0.0 |

## 限制条件
* **iOS 9.0** and Up
* **Xcode 10.0** and Up
* **Swift Version = 5.0**

## 安装

`JSLocker` 可以通过 [CocoaPods](https://cocoapods.org) 获得。安装只需要在你项目的 `Podfile` 中添加如下字段：

```ruby
pod 'JSLocker', '~> 1.0.0'
```

## 作者

spirit-jsb, sibo_jian_29903549@163.com

## 许可文件

`JSLocker` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。