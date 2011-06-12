//
//  Tui.m
//  intothefire
//
//  Created by mtt on 6/07/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import "Tui.h"


@implementation Tui


- (void)dealloc {
    
	[super dealloc];
}

- (id)initWtihTexture:(Texture2D *)tex {
	self = [super init];
	
	if (self) {
    /*
        spriteManager = [[AtlasSpriteManager alloc] initWithFile:filename 
                                                        capacity:200]; 
        [self addChild:spriteManager]; 
        aSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, width, 
                                                         height) spriteManager:spriteManager]; 
        AtlasAnimation *chargeA = [AtlasAnimation animationWithName:@"walk" 
                                                              delay:0.05f]; 
        for(int i=0;i<framecnt;i++) { 
            int x= i % columncnt; 
            int y= i / columncnt; 
            [chargeA addFrameWithRect: CGRectMake(x*width, y*height, width, 
                                                  height) ]; 
        } 
        charge = [RepeatForever actionWithAction:[Animate 
                                                  actionWithAnimation: chargeA]]; 
        [aSprite runAction:charge]; 
        [spriteManager addChild:aSprite];
     */
            }
    return self;
}

@end
