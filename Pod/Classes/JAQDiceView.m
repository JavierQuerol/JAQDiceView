//
//  JAQDiceView.m
//  Pods
//
//  Created by Javier Querol on 19/11/14.
//
//

#import "JAQDiceView.h"
#import "SCNNode+Utils.h"

@interface JAQDiceView ()
@property (nonatomic, strong) SCNNode *dice1;
@property (nonatomic, strong) SCNNode *dice2;
@property (nonatomic, strong) SCNNode *camera;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timesStopped;

@property (nonatomic, copy) IBInspectable NSString *floorImageName;
@end

@implementation JAQDiceView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.backgroundColor = [UIColor blackColor];
	
	if (!self.maximumJumpHeight) self.maximumJumpHeight = 120;
	if (!self.squareSizeHeight || self.squareSizeHeight<30) self.squareSizeHeight = 60;
	if (self.floorImageName) self.floorImage = [UIImage imageNamed:self.floorImageName];
	
	[self loadScene];
}

- (void)loadScene {
	NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"JAQDiceView" withExtension:@"bundle"];
	NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
	
	NSURL *url = [bundle URLForResource:@"Dices" withExtension:@"dae"];
	self.scene = [SCNScene sceneWithURL:url options:nil error:nil];
	
	if (!self.floorImage) self.floorImage = [UIImage imageNamed:@"woodTile"
													   inBundle:bundle
								  compatibleWithTraitCollection:nil];
	self.timesStopped = 0;
	self.scene.physicsWorld.gravity = SCNVector3Make(0, -980, 0);
	
	SCNFloor *floorGeometry = [SCNFloor floor];
	floorGeometry.firstMaterial.diffuse.contents = self.floorImage;
	floorGeometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
	
	SCNNode *floorNode = [SCNNode node];
	floorNode.geometry = floorGeometry;
	floorNode.physicsBody = [SCNPhysicsBody staticBody];
	[self.scene.rootNode addChildNode:floorNode];
	
	self.dice1 = [self.scene.rootNode childNodeWithName:@"Dice_1" recursively:YES];
	self.dice1.physicsBody = [SCNPhysicsBody dynamicBody];
	
	self.dice2 = [self.scene.rootNode childNodeWithName:@"Dice_2" recursively:YES];
	self.dice2.physicsBody = [SCNPhysicsBody dynamicBody];
	
	self.camera = [SCNNode node];
	self.camera.camera = [SCNCamera camera];
	self.camera.camera.zFar = self.maximumJumpHeight*2;
	self.camera.eulerAngles = SCNVector3Make(-M_PI/2, 0, 0);
	self.camera.position = SCNVector3Make(0, self.maximumJumpHeight-20, 0);
	if (self.cameraPerspective) {
		self.camera.rotation = SCNVector4Make(-1, 0, 0, M_PI/3);
		self.camera.position = SCNVector3Make(0, self.maximumJumpHeight-20, 60);
	}
	[self.scene.rootNode addChildNode:self.camera];
	
	SCNNode *diffuseLightFrontNode = [SCNNode node];
	diffuseLightFrontNode.light = [SCNLight light];
	diffuseLightFrontNode.light.type = SCNLightTypeOmni;
	diffuseLightFrontNode.position = SCNVector3Make(0, self.maximumJumpHeight, self.maximumJumpHeight/3);
	[self.scene.rootNode addChildNode:diffuseLightFrontNode];
	
	[self placeWallsInScene:self.scene sizeBox:self.squareSizeHeight];
	
	self.pointOfView = self.camera;
	self.allowsCameraControl = YES;
}

- (void)placeWallsInScene:(SCNScene *)scene sizeBox:(CGFloat)size {
	SCNNode *left = [SCNNode node];
	left.position = SCNVector3Make(-size/2, size/2, 0);
	left.geometry = [SCNBox boxWithWidth:1 height:size length:size chamferRadius:0];
	[scene.rootNode addChildNode:left];
	
	SCNNode *front = [SCNNode node];
	front.position = SCNVector3Make(0, size/2, -size/2);
	front.geometry = [SCNBox boxWithWidth:size height:size length:1 chamferRadius:0];
	[scene.rootNode addChildNode:front];
	
	SCNNode *right = [SCNNode node];
	right.position = SCNVector3Make(size/2, size/2, 0);
	right.geometry = [SCNBox boxWithWidth:1 height:size length:size chamferRadius:0];
	[scene.rootNode addChildNode:right];
	
	SCNNode *back = [SCNNode node];
	back.position = SCNVector3Make(0, size/2, size/2);
	back.geometry = [SCNBox boxWithWidth:size height:size length:1 chamferRadius:0];
	[scene.rootNode addChildNode:back];
	
	SCNNode *top = [SCNNode node];
	top.position = SCNVector3Make(0, size, 0);
	top.geometry = [SCNBox boxWithWidth:size height:1 length:size chamferRadius:0];
	[scene.rootNode addChildNode:top];
	
	[self applyRigidPhysics:left];
	[self applyRigidPhysics:front];
	[self applyRigidPhysics:right];
	[self applyRigidPhysics:back];
	[self applyRigidPhysics:top];
}

- (void)applyRigidPhysics:(SCNNode *)node {
	node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeStatic
											  shape:[SCNPhysicsShape shapeWithNode:node options:nil]];
	node.opacity = 0.0f;
}

- (CGFloat)randomJump {
	int lowerBound = 260;
	int upperBound = 320;
	return lowerBound + arc4random() % (upperBound - lowerBound);
}

- (IBAction)rollTheDice:(id)sender {
	[self.dice1.physicsBody applyTorque:SCNVector4Make([self randomJump], -12, 0, 10) impulse:YES];
	[self.dice2.physicsBody applyTorque:SCNVector4Make([self randomJump], +10, 0, 10) impulse:YES];
	
	self.timesStopped = 0;
	
	[self.timer invalidate];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkStatus:) userInfo:nil repeats:YES];
}

- (void)checkStatus:(id)sender {
	float result = [self.dice1 jaq_rotatedVector].x;
	if ((result>0.95 && result<1.05) ||
		(result<0.05 && result>-0.05) ||
		(result>-1.05 && result<-0.95)) {
		
		self.timesStopped++;
		
		int threshold = 5;
		
#if TARGET_IPHONE_SIMULATOR
		threshold = 20;
#endif
		if (self.timesStopped>threshold) {
			[self.timer invalidate];
			if ([self.delegate respondsToSelector:@selector(diceView:rolledWithFirstValue:secondValue:)]) {
				[self.delegate diceView:self
				   rolledWithFirstValue:[self.dice1 jaq_boxUpIndex]
							secondValue:[self.dice2 jaq_boxUpIndex]];
			}
		}
	} else {
		self.timesStopped = 0;
	}
}

@end
