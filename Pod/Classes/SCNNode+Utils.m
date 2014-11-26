//
//  SCNNode+Utils.m
//  Pods
//
//  Created by Javier Querol on 25/11/14.
//
//

#import "SCNNode+Utils.h"
#import <GLKit/GLKit.h>

@implementation SCNNode (Utils)

- (NSUInteger)jaq_boxUpIndex {
	GLKVector3 rotatedUp = [self jaq_rotatedVector];
	GLKVector3 boxNormals[6] = {
		{{0,-1,0}},
		{{0,0,1}},
		{{-1,0,0}},
		{{1,0,0}},
		{{0,0,-1}},
		{{0,1,0}},
	};
	
	NSUInteger bestIndex = 0;
	float maxDot = -1;
	
	for (NSInteger i=0; i<6; i++) {
		float dot = GLKVector3DotProduct(boxNormals[i], rotatedUp);
		if(dot > maxDot){
			maxDot = dot;
			bestIndex = i;
		}
	}
	
	return ++bestIndex;
}

- (GLKVector3)jaq_rotatedVector {
	SCNVector4 rotation = self.presentationNode.rotation;
	SCNVector4 invRotation = rotation; invRotation.w = -invRotation.w;
	SCNVector3 up = SCNVector3Make(0,1,0);
	SCNMatrix4 transform = SCNMatrix4MakeRotation(invRotation.w, invRotation.x, invRotation.y, invRotation.z);
	GLKMatrix4 glkTransform = SCNMatrix4ToGLKMatrix4(transform);
	GLKVector3 glkUp = SCNVector3ToGLKVector3(up);
	return GLKMatrix4MultiplyVector3(glkTransform, glkUp);
}

@end
