//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: SMainMenu.m
//
//	Last modified: 2/07/09
//

#import "SMainMenu.h"


@implementation SMainMenu

- (id) init {
    self = [super init];
    if (self != nil) {
        SMainMenuLayer *layer = [SMainMenuLayer node];
		[self addChild:layer];
    }
    return self;
}

@end


/*
 ********************************************************
 
 ********************************************************
 */


@implementation SMainMenuLayer

- (id) init {
    self = [super init];
    if (self != nil) {
       
    }
    return self;
}

@end