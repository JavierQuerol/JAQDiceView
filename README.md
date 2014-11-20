# JAQDiceView

Click play to watch the video

[![Video](http://s27.postimg.org/ovoy8ze7n/dice_Video.jpg)](https://www.youtube.com/watch?v=t8Iq_QZ9XEA&feature=youtu.be)

[![Version](https://img.shields.io/cocoapods/v/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![License](https://img.shields.io/cocoapods/l/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![Platform](https://img.shields.io/cocoapods/p/JAQDiceView.svg?style=flat)](http://cocoadocs.org/docsets/JAQDiceView)
[![GitHub Issues](http://img.shields.io/github/issues/javierquerol/JAQDiceView.svg?style=flat)](http://github.com/javierquerol/JAQDiceView/issues)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

- Add a **JAQDiceView** to your ViewController
- Implement the **JAQDiceProtocol**

```objective-c
@interface JAQViewController () <JAQDiceProtocol>
@property (nonatomic, weak) IBOutlet JAQDiceView *playground;
@end

@implementation JAQViewController

- (void)diceView:(JAQDiceView *)view rolledWithFirstValue:(int)firstValue secondValue:(int)secondValue {
	NSLog(@"%i",firstValue+secondValue);
}

- (IBAction)rollDice:(id)sender {
	[self.playground rollTheDice];
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

