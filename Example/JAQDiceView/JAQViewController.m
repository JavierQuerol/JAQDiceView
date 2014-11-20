//
//  JAQViewController.m
//  JAQDiceView
//
//  Created by Javier Querol on 11/19/2014.
//  Copyright (c) 2014 Javier Querol. All rights reserved.
//

#import "JAQViewController.h"
#import <JAQDiceView.h>

@interface JAQViewController () <JAQDiceProtocol>
@property (nonatomic, weak) IBOutlet JAQDiceView *playground;
@property (nonatomic, weak) IBOutlet UILabel *result;
@end

@implementation JAQViewController

- (void)diceView:(JAQDiceView *)view rolledWithFirstValue:(NSInteger)firstValue secondValue:(NSInteger)secondValue {
	self.result.text = [NSString stringWithFormat:@"%li",firstValue+secondValue];
	[self addPopAnimationToLayer:self.result.layer withBounce:0.1 damp:0.02];
}

- (IBAction)rollDice:(id)sender {
	[self.playground rollTheDice];
}

- (void)addPopAnimationToLayer:(CALayer *)aLayer withBounce:(CGFloat)bounce damp:(CGFloat)damp {
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	animation.duration = 1;
	
	NSInteger steps = 100;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
	double value = 0;
	CGFloat e = 2.71f;
	for (int t=0; t<100; t++) {
		value = pow(e, -damp*t) * sin(bounce*t) + 1;
		[values addObject:[NSNumber numberWithDouble:value]];
	}
	animation.values = values;
	[aLayer addAnimation:animation forKey:@"appearAnimation"];
}

@end
