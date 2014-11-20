//
//  JAQDiceView.h
//  Pods
//
//  Created by Javier Querol on 19/11/14.
//
//

#import <SceneKit/SceneKit.h>

@class JAQDiceView;

@protocol JAQDiceProtocol <NSObject>
- (void)diceView:(JAQDiceView *)view rolledWithFirstValue:(int)firstValue secondValue:(int)secondValue;
@end

@interface JAQDiceView : SCNView

@property (nonatomic, weak) id<JAQDiceProtocol> delegate;
@property (nonatomic, assign) float tall;
@property (nonatomic, strong) UIImage *floorImage;

- (void)rollTheDice;

@end

