//
//	Created by Cleave Pokotea on 25/02/09
//
//	Project: STM007
//	File: Game.m
//
//	Last modified: 25/02/09
//
#import "StaticMethods.h"
#import "SGame.h"
#import "LayerCamera.h"
#import "LScrollingBkgnd.h"
#import "LGameWorld.h"
#import "LHud.h"


@implementation SGame


- (void)dealloc 
{
    [sb release];
    [gameCamera release];
    [super dealloc];

}


- (id) init 
{
    LOG_CURRENT_METHOD;
    
    self = [super init];
    if (self != nil) {
        LOG(@"Game scene");
               
        /*/ Scrolling backgrounds - z:0  
        //Texture2D *tex = [[TextureMgr sharedTextureMgr] addPVRTCImage:@"main-parallax.pvrtc" bpp:4 hasAlpha:NO width:1024];
        Texture2D *tex = [[TextureMgr sharedTextureMgr] addPVRTCImage:@"backgrounds.pvrtc" bpp:4 hasAlpha:NO width:1024];
        sb = [[LScrollingBkgnd alloc]initWithTex:tex];
        [self addChild:sb z:0]; 
        
        // Camera -z:1
        gameCamera = [[LayerCamera alloc] initForLayer:sb layerSize:CGSizeMake(2048, 1024) cameraLocation:CGRectMake(0, 0, 320, 480)]; 
        [self addChild:gameCamera z:1 tag:1000]; 
        //*/
        
        // Game world - z:2
        LGameWorld * gw = [[LGameWorld alloc]init];
        [self addChild:gw z:2]; 
        [gw release];
    }
    return self;
}

#pragma mark -
#pragma mark Layer Scroll
- (void)changePosition:(float)f 
{
    
    //[gameCamera updateLayerPosition:ccp(f,0.0f)];
}

@end
