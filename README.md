# JAQDiceView

Click play to watch the video

[![Video](http://s15.postimg.org/4yh8hzbyz/dice.jpg)](http://youtu.be/N7EBVIwJeAg)

[![Version](https://img.shields.io/cocoapods/v/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![License](https://img.shields.io/cocoapods/l/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![Platform](https://img.shields.io/cocoapods/p/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![GitHub Issues](http://img.shields.io/github/issues/javierquerol/JAQDiceView.svg?style=flat)](http://github.com/javierquerol/JAQDiceView/issues)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

> Don't use the simulator, always use a device, as it uses a lot of GPU, performance is really bad on simulator

- Add a **JAQDiceView** to your ViewController
- Implement the **JAQDiceProtocol**

```objective-c
@interface JAQViewController () <JAQDiceProtocol>
@property (nonatomic, weak) IBOutlet JAQDiceView *playground;
@end

@implementation JAQViewController

- (void)diceView:(JAQDiceView *)view rolledWithFirstValue:(NSInteger)firstValue secondValue:(NSInteger)secondValue {
	NSLog(@"%li",firstValue+secondValue);
}

- (IBAction)rollDice:(id)sender {
	[self.playground rollTheDice:sender];
}

@end
```

## Requirements
iOS 8 (SceneKit works on >=iOS8)

## Installation

JAQDiceView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "JAQDiceView"

## Contribution
Feel free to contribute

## Author

Javier Querol

[![Twitter](http://img.shields.io/badge/contact-@javierquerol-blue.svg?style=flat)](http://twitter.com/javierquerol)
[![Email](http://img.shields.io/badge/email-querol.javi@gmail.com-blue.svg?style=flat)](mailto:querol.javi@gmail.com)
## License

JAQDiceView is available under the MIT license. See the LICENSE file for more info.

