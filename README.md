YRNavigationBarPure [中文介绍]()
============

As the container of UIViewController, UINavigationController has only one UINavigationBar. The setting of UIViewController determines the transition effect of UINavigationBar when pushing of poping. when one of the UIviewcontrollers sets the uinavigationbar to hidden , sometimes this transition effect is not so friendly.

YRNavigationBarPure hides the UINavigationBar through sendSubviewToBack:, and generates a screenshot of UINavigationbar for every UIViewController. When pushing or poping happens, the screenshot is added to the view of the UIViewController, so that each UIViewcontroller seems to have an independent UINavigationBar.

## Installtion

To integrate the lastest release version of YRNavigationBarPure into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
pod 'YRNavigationBarPure'
```

## Usage

Two extended properties have been added for UIViewController. You need to complete the navigation bar's settings in `viewDidLoad`. You only need to focus on the navigation bar style of the current UIViewController without worrying about restoring settings. `YRNavigationBarPure` will manage all this.

`prefersNavigationBarHidden` default is `NO`. Set this property to `YES` if your UIViewController needs to hide the navigation bar.
`interactivePopDisabled` default is `NO`. Set this property to `YES` if your UIViewController needs to disable side sliding.

UINavigationController has one extended a property

`allowFullScreenInteractivePop` default is `NO`, set to `YES` if you need to turn on the full screen swiping back

## Requirements
- iOS 9.0
## License
