//
//	Created by Cleave Pokotea on 5/03/09
//
//	Project: 3dNode
//	File: LModels.h
//
//	Last modified: 5/03/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Layer3d.h"
#import "CEnums.h"

//The Deij-Taamara Algorithm
#define MAP_X 10
#define MAP_Z 36

@interface LTerrain : Layer3d {
@private
    
    GLfloat terrain[MAP_X][MAP_Z][3];
    GLfloat texOrd0[32];
    GLfloat texOrd1[32];
    GLfloat texOrd2[32];
    GLfloat texOrd3[32];
    
    GLfloat terrainPoints[MAP_X][MAP_Z][3];
    GLfloat terrainCoords[MAP_X][MAP_Z][2];    
    GLfloat wrapValue;
    CocosNode3d * plane;
    Texture2D *tex;
}

@property (nonatomic, retain) CocosNode3d * plane;


@end