//
//  LFlag.h
//  intothefire
//
//  Created by mtt on 1/07/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Layer3d.h"
#import "CEnums.h"


#define MAP_X 10
#define MAP_Z 36


@interface LFlag: Layer3d {
@private
    
    GLfloat terrainPoints[MAP_X][MAP_Z][3];
    GLfloat terrainCoords[MAP_X][MAP_Z][2];    
    Texture2D *tex;
    
    GLfloat eye[3];					// Where we are viewing from
	GLfloat center[3];				// Where we are looking towards
}

- (void)handleTouches;

@end