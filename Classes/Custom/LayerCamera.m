//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: LayerCamera.m
//
//	Last modified: 2/07/09
//
#import "StaticMethods.h"
#import "LayerCamera.h"
#import "InputController.h"


@interface LayerCamera (Private)

-(float) scaleFromWidth:(float) width;
-(float) widthFromScale:(float) scale;
-(void) updateCameraPosition:(CGPoint) position;
-(void) updateCameraScale:(float) scale;

@end


@implementation LayerCamera

#pragma mark -
#pragma mark ctor

-(id) init
{
#ifdef ASSERT_DEBUG
	{
		@throw [[[NSException alloc] initWithName:@"LayerCamera::init" reason:@"Wrong ctor" userInfo:nil] autorelease];
	}
#endif
	return self;
}

-(id) initForLayer:(CocosNode*) mTargetLayer layerSize:(CGSize) mSize cameraLocation:(CGRect) mlocation
{
	return [self initForLayer:mTargetLayer layerSize:mSize cameraLocation:mlocation :false];
}

-(id) initForLayer:(CocosNode*) mTargetLayer layerSize:(CGSize) mSize cameraLocation:(CGRect) mlocation :(bool) movable
{
	self = [super init];
	if(self == nil) {
#ifdef ASSERT_DEBUG
		{
			@throw [[[NSException alloc] initWithName:@"LayerCamera::initForLayer" reason:@"is nil" userInfo:nil] autorelease];
		}
#endif
		return self;
	}
	
	targetLayer = mTargetLayer;
	layerSize = mSize;
	viewportSize = [[Director sharedDirector] winSize];
	
	[self setPosition:mlocation.origin];
	[self setScale:[self scaleFromWidth:mlocation.size.width]];
	
	isTouchEnabled = movable;
	
	[self updateLayerZoom:mlocation.size.width];
	[self updateLayerPosition:[self position]];
	
	[self schedule:@selector(tick:)];
	
	return self;
}

#pragma mark -
#pragma mark Layer

-(void) tick:(ccTime) time
{
	[self updateCameraScale:[self scale]];
	[self updateCameraPosition:[self position]];
}

#pragma mark -
#pragma mark CocosNode

-(BOOL) ccTouchesMoved:(NSSet *) touches withEvent:(UIEvent *)event {
    LOG_CURRENT_METHOD;
    
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return kEventIgnored;
	
	{
		CGPoint previousLocation = icPreviousFingerLocation(1,touches,event);
		CGPoint location = icPreviousFingerLocation(2,touches,event);
		float initialDistance = icDistanceBetweenTwoPoints(previousLocation,location);
		
		previousLocation = icFingerLocation(1,touches,event);
		location = icFingerLocation(2,touches,event);
		float endDistance = icDistanceBetweenTwoPoints(previousLocation,location);
		
		if(fabsf(initialDistance - endDistance) > 5)
		{
			float zoomDistance = fabsf(initialDistance - endDistance);
			
			if(icWasZoomIn(touches,event))
			{
				[self updateLayerZoom:[self widthFromScale:[self scale]] - zoomDistance];
			}
			else if(icWasZoomOut(touches,event))
			{
				[self updateLayerZoom:[self widthFromScale:[self scale]] + zoomDistance];
			}			
		}
	}
	
	{
		CGPoint distance = icDistance(1,touches,event);
		CGPoint cameraMovement = CGPointZero;
		if(icWasDragLeft(touches,event)) {
            
			cameraMovement = ccpAdd(cameraMovement, ccp(distance.x, 0));
		} else if(icWasDragRight(touches,event)) {
            
			cameraMovement = ccpSub(cameraMovement, ccp(distance.x, 0));
		}
		
		if(icWasDragUp(touches,event)) {
            
			cameraMovement = ccpSub(cameraMovement, ccp(0, distance.y));
		} else if(icWasDragDown(touches,event)) {
            
			cameraMovement = ccpAdd(cameraMovement, ccp(0, distance.y));
		}
		
		[self setPosition:ccpAdd(cameraMovement, [self position])];
		[self updateLayerPosition:[self position]];
	}
	return kEventHandled;
}

#pragma mark -
#pragma mark LayerCamera

-(void) updateLayerPosition:(CGPoint) mPosition
{
	float newX = mPosition.x;
	float newY = mPosition.y;
	
	float cameraWidth = [self scale] * viewportSize.width;
	
	if(newX < (-layerSize.width + cameraWidth) / 2.0) {
		newX =  (-layerSize.width + cameraWidth) / 2.0;
	} else if(newX > (layerSize.width - cameraWidth) / 2.0) {
		newX = (layerSize.width - cameraWidth) / 2.0;
    }
	
	if(newY < (-layerSize.height + cameraWidth) / 2.0) {
		newY =  (-layerSize.height + cameraWidth) / 2.0;
	} else if(newY > (layerSize.height - cameraWidth) / 2.0) {
		newY = (layerSize.height - cameraWidth) / 2.0;
    }
	
	CGPoint cPosition = ccp(newX, newY);
	[self setPosition: cPosition];
	[self updateCameraPosition:cPosition];
}

-(void) updateLayerZoom:(float) mWidth
{
	float width = mWidth;
	
	if(width > layerSize.width) {
        
		width = layerSize.width;
	} else if(width < viewportSize.width) {
        
		width = viewportSize.width;
	}
	
	float zoom = [self scaleFromWidth:width];
	[self setScale:zoom];
	[self updateCameraScale:zoom];
}


-(CGPoint) pointTranslate:(CGPoint) point
{
	CGPoint nPoint = ccpSub(point, [targetLayer transformAnchor]);
	CGPoint translatedPoint = ccpAdd(nPoint, [self position]);
	CGPoint toScale = ccpMult(translatedPoint, 1.0/[targetLayer scale]);
	return toScale;
}

@end

@implementation LayerCamera (Private)

-(float) scaleFromWidth:(float) width
{
	return 1.0 / (width / viewportSize.width);
}

-(float) widthFromScale:(float) scale
{
	return 1.0 / scale * viewportSize.width;
}

-(void) updateCameraPosition:(CGPoint) cPosition
{	
	[targetLayer setPosition:CGPointMake([targetLayer transformAnchor].x * [targetLayer scale] -cPosition.x, 
										 [targetLayer transformAnchor].y * [targetLayer scale] -cPosition.y)];
}

-(void) updateCameraScale:(float) cScale
{
	[targetLayer setScale:cScale];
}

@end
