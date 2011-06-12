//
//	Created by mtt on 8/07/09
//
//	Project: intothefire
//	File: LClouds.m
//
//	Last modified: 8/07/09
//
#import "StaticMethods.h"
#import "LClouds.h"

#define CLOUD_TAG kCloudSprite

@implementation LClouds

- (void)dealloc 
{
    [super dealloc];
}


- (id)init 
{
    self = [super init];
    if (self != nil) {
        
        Texture2D *lTex = [[TextureMgr sharedTextureMgr] addImage:@"game_assets.png"];
        AtlasSpriteManager *cloudMgr = [AtlasSpriteManager spriteManagerWithTexture: lTex capacity: 30];
        [self addChild: cloudMgr z:5  tag:kMgrAssests];
        
        //sdrand(time(NULL));
        
        for (int i = 0; i < 30; i++) 
        { 
            AtlasSprite *cloud = [AtlasSprite spriteWithRect: CGRectMake(626,88,153,75) spriteManager: cloudMgr];
            [cloudMgr addChild:cloud z:2 tag:CLOUD_TAG+i];
            //int randomOpacity = ufrand(random() % 125);
            //int randomX = ufrand(random() % 750);
            //int randomY = ufrand(random() % 200)-50;arc4random() % 74;
            
            int randomOpacity = ufrand(arc4random() % 135);
            int randomX = arc4random() % 750;
            int randomY = ufrand(arc4random() % 151); // arc4random() % 201 == random between 0 & 200 (excludes 201)
            cloud.opacity = randomOpacity; 
            cloud.position = ccp(randomX, adjustForUpperLeftAnchor(randomY)); 
        } 
        
        [self schedule: @selector(step:)];
    }
    return self;
}

- (void)step:(ccTime) delta 
{
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];
    for(AtlasSprite *item in [mgr children]) 
    { 
        float x = item.position.x + 0.3f;
        if (x >= 750) {
            
            x = -250;
        }
        item.position = ccp(x, item.position.y);
    }  
}

@end