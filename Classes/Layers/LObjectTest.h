//
//  LObjectTest.h
//  intothefire
//
//  Created by mtt on 24/06/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Layer3d.h"


@interface LObjectTest: Layer3d {
    
    CocosNode3d * obj;
}

@property (nonatomic, retain) CocosNode3d * obj;


@end