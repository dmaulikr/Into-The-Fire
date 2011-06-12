//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: LScrollingBkgnd.m
//
//	Last modified: 2/07/09
//
#import "StaticMethods.h"
#import "LScrollingBkgnd.h"
#import "SGame.h"


@implementation LScrollingBkgnd


- (void)dealloc {
    
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        LOG(@"Call initWithTex:(Texture2d *)tex");
    }
    return self;
}

// Texture is 1024 wide. Layer is 2048 wide
- (id)initWithTex:(Texture2D *)tex {
    
    if ((self = [super init])) {
        
        AtlasSpriteManager *keyMgr = [AtlasSpriteManager spriteManagerWithTexture: tex capacity:3];
        [self addChild:keyMgr z:0 tag:0];        
        
        AtlasSprite *bg= [AtlasSprite spriteWithRect:CGRectMake(0,0,1024,262) spriteManager:keyMgr];
        [bg setPosition: ccp(0,58)];
        //[bg setRGB:214 :56 :18];
        [keyMgr addChild:bg z:0];
        //Sprite *bg = [Sprite spriteWithTexture:tex];
        //[bg setPosition: ccp(0,0)];
        //[self addChild: bg];
        
        
        AtlasSprite *bg2= [AtlasSprite spriteWithRect:CGRectMake(0,0,1024,262) spriteManager:keyMgr];
        [bg2 setPosition: ccp(1024,58)];
        //[bg2 setRGB:214 :56 :18];
        [keyMgr addChild:bg2 z:0];
        //Sprite *bg2 = [Sprite spriteWithTexture:tex];
        //[bg2 setPosition: ccp(1024,0)];
        //[self addChild: bg2];
        
        x = -272.0f;
        [self schedule: @selector(update:)];
    }
    
    return self;
}

- (void)update:(ccTime)dt {
    [(SGame*)parent changePosition:x];
    
    if(x > 752.0f) {
        x = -272.0f;
    }else{
        x = x + 0.25f;
    }
}


@end