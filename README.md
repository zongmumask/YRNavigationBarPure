## YRNavigationBarPure

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
