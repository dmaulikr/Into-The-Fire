//
//  intothefireAppDelegate.m
//  intothefire
//
//  Created by mtt on 28/05/09.
//  Copyright Make Things Talk 2009. All rights reserved.
//

#import "intothefireAppDelegate.h"
#import "cocos2d.h"
#import "StaticMethods.h"
#import "SGame.h"
#import "LayerCamera.h"


@implementation intothefireAppDelegate


@synthesize window;


-(void)dealloc 
{
    [[Director sharedDirector] release];
	[window release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    LOG_CURRENT_METHOD;
    
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];

	[[Director sharedDirector] setDeviceOrientation: CCDeviceOrientationLandscapeLeft];
    
#ifdef DEBUG
	[[Director sharedDirector] setDisplayFPS:YES];
#endif
    
	[[Director sharedDirector] attachInWindow:window];

	[window makeKeyAndVisible];
	
	[[Director sharedDirector] runWithScene: [self loadScene:kSplash]];
    //[[Director sharedDirector] runWithScene: [self loadScene:kSceneGame]];

}

-(void) applicationWillResignActive:(UIApplication *)application 
{
	[[Director sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application 
{
	[[Director sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	[[Director sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application 
{
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark -
#pragma mark The others

- (Scene *)loadScene:(NSInteger)sceneId 
{
    LOG_CURRENT_METHOD;
    
	Scene *scene = nil;
	
	//anti piracy
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *info = [bundle infoDictionary];
	
	if ([info objectForKey: @"SignedIdentity"] != nil){
        
		[scene removeAllChildrenWithCleanup:YES];
	}
    
    switch (sceneId) {

        case kSplash:
            scene = [SGame node];
            break;
		case kSceneMenu:
			//scene = [MenuScene node];
			break;
		case kSceneGame:
            scene = [[Scene alloc] init]; 
            Layer * mainLayer = [[Layer alloc] init]; 
            [scene addChild: mainLayer z:1 tag:100]; 
			//Sprite *mainBGImage = [Sprite spriteWithFile:@"main-parallax.png"]; 
            Texture2D *tex = [[TextureMgr sharedTextureMgr] addPVRTCImage:@"main-parallax.pvrtc" bpp:4 hasAlpha:NO width:1024];
            Sprite *mainBGImage = [Sprite spriteWithTexture:tex];
            
            [mainLayer addChild: mainBGImage z:2 tag:110]; 
            LayerCamera * mainCamera = [[LayerCamera alloc] initForLayer:mainLayer 
                                                 layerSize:CGSizeMake(1024, 1024) cameraLocation:CGRectMake(0, 0, 320, 
                                                                                                          480) :true]; 
            [scene addChild:mainCamera z:3 tag:1000]; 
			break;
		case kSceneScore:
			//scene = [HighScore node];
			break;
            
		case kSceneInfo:
			//scene = [InfoScene node];
			break;
            
		case kSceneEnd:
			//scene = [EndScene node];
			break;
	}
	
	return scene;
}




@end
