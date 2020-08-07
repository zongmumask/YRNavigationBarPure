YRNavigationBarPure
============

UINavigationController作为容器所有的UIViewController都使用同一个UINavigationBar，UINavigatioBbar的转场效果由两个参与转场的UIViewController对UINavigationBar的设置决定。但是当其中有一个设置导航栏隐藏，有时这种转场效果就不是那么友好。

YRNavigationBarPure通过`sendSubviewToBack:`将UINavigationBar隐藏起来，并为每个UIViewcontroller生成一个UINavigationBar的截图，转场时将截图加在UIViewController的view上，让每个UIviewcontroller看起来拥有一个独立的UINavigationBar。

## 效果图

### 原生

![Pure](https://github.com/zongmumask/YRNavigationBarPure/blob/master/Screenshots/original_without_navigationbar_hidden.gif)

![Pure](https://github.com/zongmumask/YRNavigationBarPure/blob/master/Screenshots/original_with_navigatioinbar_hidden.gif)

### 现在

![](https://github.com/zongmumask/YRNavigationBarPure/blob/master/Screenshots/pure_without_navigationbar_hidden.gif)

![](https://github.com/zongmumask/YRNavigationBarPure/blob/master/Screenshots/pure_with_navigationbar_hidden.gif)

## 使用

为UIViewcController新增了两个扩展属性，需要在viewDidLoad里完成对导航栏的设置，你只需要关注当前UIViewController的导航栏样式而无需关心何时还原设置，YRNavigationBarPure会管理好这一切。

`yr_preferNavigationBarHidden`默认是`NO`， 如果你的UIViewController需要隐藏导航栏，则设置该属性为`YES`

```obje
self.yr_prefersNavigationBarHidden = YES;
```

`yr_interactivePopDisabled`默认是`NO`，如果你的UIViewController需要禁用侧滑，则设置该属性为`YES`

```objective-c
self.yr_interactivePopDisabled = YES;
```

为UINavigationController扩展了一个属性

`yr_allowFullScreenInteractivePop`默认是`NO`，如果你需要开启全屏幕侧滑返回则设置为`YES`

```objective-c
self.yr_allowFullScreenInteractivePop = YES;
```

## 安装

在`Podfile`中添加以下代码安装最新版本:

```ruby
pod 'YRNavigationBarPure'
```

然后终端运行命令:

```bash
$ pod install
```

## 系统要求

- iOS 9.0

## 许可证

YRNavigationBarPure是基于 MIT 许可证下发布的，详情请参见[LICENSE](https://github.com/zongmumask/YRNavigationBarPure/blob/master/LICENSE).

