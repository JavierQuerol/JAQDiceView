//
//  JAQDiceView.m
//  Pods
//
//  Created by Javier Querol on 19/11/14.
//
//

#import "JAQDiceView.h"
#import <GLKit/GLKit.h>

@interface JAQDiceView ()
@property (nonatomic, strong) SCNNode *dice1;
@property (nonatomic, strong) SCNNode *dice2;
@property (nonatomic, strong) SCNNode *camera;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timesStopped;
@end

@implementation JAQDiceView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	if (!self.tall) self.tall = 550;
	if (!self.floorImage) self.floorImage = [UIImage imageNamed:@"woodTile"];
	
	[self loadScene];
}

- (void)loadScene {
	self.timesStopped = 0;
	
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Dices" withExtension:@"dae"];
	SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:nil];;
	self.scene = scene;
	self.scene.physicsWorld.gravity = SCNVector3Make(0, -980, 0);
	
	SCNFloor *floorGeometry = [SCNFloor floor];
	floorGeometry.firstMaterial.diffuse.contents = self.floorImage;
	floorGeometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
	
	SCNNode *floorNode = [SCNNode node];
	floorNode.geometry = floorGeometry;
	floorNode.name = @"floor";
	floorNode.physicsBody = [SCNPhysicsBody staticBody];
	[scene.rootNode addChildNode:floorNode];
	
	_dice1 = [scene.rootNode childNodeWithName:@"Dice_White_1" recursively:YES];
	_dice1.physicsBody = [SCNPhysicsBody dynamicBody];
	
	_dice2 = [scene.rootNode childNodeWithName:@"Dice_White_2" recursively:YES];
	_dice2.physicsBody = [SCNPhysicsBody dynamicBody];
	
	_camera = [SCNNode node];
	_camera.camera = [SCNCamera camera];
	_camera.camera.zFar = 1000;
	_camera.position = SCNVector3Make(0, self.tall, 0);
	_camera.eulerAngles = SCNVector3Make(-(float)M_PI/2, 0, 0);
	[scene.rootNode addChildNode:_camera];
	
	SCNNode *diffuseLightFrontNode = [SCNNode node];
	diffuseLightFrontNode.light = [SCNLight light];
	diffuseLightFrontNode.light.type = SCNLightTypeOmni;
	diffuseLightFrontNode.position = SCNVector3Make(0, 300, -300);
	[scene.rootNode addChildNode:diffuseLightFrontNode];
	
	[self placeWallsInScene:scene];
	
	self.pointOfView = _camera;
	self.allowsCameraControl = NO;
}

- (void)placeWallsInScene:(SCNScene *)scene {
	SCNNode *left = [SCNNode node];
	left.position = SCNVector3Make(-(float)self.frame.size.width/3.5f, _camera.position.y/2, 0);
	left.geometry = [SCNBox boxWithWidth:1 height:_camera.position.y length:self.frame.size.height chamferRadius:0];
	[scene.rootNode addChildNode:left];
	
	SCNNode *front = [SCNNode node];
	front.position = SCNVector3Make(0, _camera.position.y/2, -(float)self.frame.size.height/2);
	front.geometry = [SCNBox boxWithWidth:self.frame.size.width height:_camera.position.y length:1 chamferRadius:0];
	[scene.rootNode addChildNode:front];
	
	SCNNode *right = [SCNNode node];
	right.position = SCNVector3Make((float)self.frame.size.width/3.5f, _camera.position.y/2, 0);
	right.geometry = [SCNBox boxWithWidth:1 height:_camera.position.y length:self.frame.size.height chamferRadius:0];
	[scene.rootNode addChildNode:right];
	
	SCNNode *back = [SCNNode node];
	back.position = SCNVector3Make(0, _camera.position.y/2, (float)self.frame.size.height/2);
	back.geometry = [SCNBox boxWithWidth:self.frame.size.height height:_camera.position.y length:1 chamferRadius:0];
	[scene.rootNode addChildNode:back];
	
	SCNNode *top = [SCNNode node];
	top.position = SCNVector3Make(0, _camera.position.y-30, 0);
	top.geometry = [SCNBox boxWithWidth:self.frame.size.width height:1 length:self.frame.size.height chamferRadius:0];
	[scene.rootNode addChildNode:top];
	
	[self applyRigidPhysics:left];
	[self applyRigidPhysics:front];
	[self applyRigidPhysics:right];
	[self applyRigidPhysics:back];
	[self applyRigidPhysics:top];
}

- (void)applyRigidPhysics:(SCNNode *)node {
	SCNPhysicsBody *rigidBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeStatic shape:[SCNPhysicsShape shapeWithNode:node options:nil]];
	node.physicsBody = rigidBody;
	node.opacity = 0.0f;
}

- (void)rollTheDice {
	int lowerBound = 20;
	int upperBound = 50;
	int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
	
	[_dice1.physicsBody applyTorque:SCNVector4Make(-rndValue, 20, 200, 110) impulse:YES];
	[_dice2.physicsBody applyTorque:SCNVector4Make(rndValue, -20, 200, 120) impulse:YES];
	
	self.timesStopped = 0;
	
	[self.timer invalidate];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkStatus:) userInfo:nil repeats:YES];
}

- (void)checkStatus:(id)sender {
	float result = [self rotatedVector:_dice1].x;
	if ((result>0.95 && result<1.05) ||
		(result<0.05 && result>-0.05) ||
		(result>-1.05 && result<-0.95)) {
		
		self.timesStopped++;
		
		if (self.timesStopped>10) {
			[self.timer invalidate];
			if ([self.delegate respondsToSelector:@selector(diceView:rolledWithFirstValue:secondValue:)]) {
				[self.delegate diceView:self
				   rolledWithFirstValue:[self boxUpIndex:self.dice1]
							secondValue:[self boxUpIndex:self.dice2]];
			}
		}
	} else {
		self.timesStopped = 0;
	}
}

- (NSUInteger)boxUpIndex:(SCNNode *)boxNode {
	GLKVector3 rotatedUp = [self rotatedVector:boxNode];
	GLKVector3 boxNormals[6] = {
		{{0,-1,0}},
		{{0,0,1}},
		{{-1,0,0}},
		{{1,0,0}},
		{{0,0,-1}},
		{{0,1,0}},
	};
	
	int bestIndex = 0;
	float maxDot = -1;
	
	for(int i=0; i<6; i++){
		float dot = GLKVector3DotProduct(boxNormals[i], rotatedUp);
		if(dot > maxDot){
			maxDot = dot;
			bestIndex = i;
		}
	}
	
	return bestIndex+1;
}

- (GLKVector3)rotatedVector:(SCNNode *)node {
	SCNVector4 rotation = node.presentationNode.rotation;
	SCNVector4 invRotation = rotation; invRotation.w = -invRotation.w;
	SCNVector3 up = SCNVector3Make(0,1,0);
	SCNMatrix4 transform = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z);
	GLKMatrix4 glkTransform = SCNMatrix4ToGLKMatrix4(transform);
	GLKVector3 glkUp = SCNVector3ToGLKVector3(up);
	return GLKMatrix4MultiplyVector3(glkTransform, glkUp);
}

@end
