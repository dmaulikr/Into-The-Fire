//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: LayerCamera.h
//
//	Last modified: 2/07/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface LayerCamera : Layer {
    
	CocosNode* targetLayer; 
	CGSize layerSize;
	CGSize viewportSize;
}
-(id) initForLayer:(CocosNode*) target layerSize:(CGSize) mSize cameraLocation:(CGRect) mlocation;
-(id) initForLayer:(CocosNode*) target layerSize:(CGSize) mSize cameraLocation:(CGRect) mlocation :(bool) movable;
-(void) updateLayerPosition:(CGPoint) mPosition;
-(void) updateLayerZoom:(float) width;

@end