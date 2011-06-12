//
//  CocosNode3d.h
//  cocos2d-iphone
//
//  Created by Cleave Pokotea on 5/03/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/glext.h>
#import "TextureAtlas.h"
#import "CocosNode.h"


typedef struct {
    char Name[32];
        
    ccVertex3F aCol;
    ccVertex3F dCol;
    ccVertex3F sCol;
        
    float Reflect;
    float Opacity;
        
    char aTextName[255];
    char dTextName[255];
    char sTextName[255];
        
    int NormType;
    int SmthType;
} mttMtrl;

typedef struct {
    
    float u;
    float v;
    float w;
} mttTexCoords;

typedef struct {
    
    GLushort v1;
    GLushort v2;
    GLushort v3;
    GLushort v4;
} mttFace;


@class Texture2D;


@interface CocosNode3d : CocosNode{

    mttMtrl *mtrl;
    
    ccVertex3F *vertices;
    mttTexCoords *texCords;
    ccVertex3F *norms;
    mttFace *faces;
    
    int numberOfFaces;
    ccVertex3F currentPosition;
    ccVertex3F currentRotation;

    // Using Cocos2d to handle loading
    TextureAtlas * textureAtlas;

    /*
     * Texture support for loaded models
     */
    NSString * name; // file name of image for ambient
    Texture2D * texture;
    GLuint textureName;
    BOOL blendu;
    BOOL blendv;

    // cc -- color correction, ignored for now
    BOOL clamp;
    NSString * channel; // the chanel of the image to use in bump, transp, spec, disp and decal
    GLfloat bumpMultiplier; // used to multiply the bump value

    // mm -- specify the base and gain for the texture
    ccVertex3F offset;
    ccVertex3F textureScale;
    ccVertex3F turbulance;
    // texres - ignored for now

    /*
     * Required by CocosNodeOpacity
     */
    /// texture opacity
    GLubyte opacity;	
}


/// property of opacity. Conforms to CocosNodeOpacity protocol
@property (readwrite,assign) GLubyte opacity;
@property ccVertex3F currentPosition;
@property ccVertex3F currentRotation;
@property(retain) NSString * name;
@property(assign) GLuint textureName;

- (GLuint)textureName;


/* returns the content size of the Atlas in pixels
 * Conforms to CocosNodeSize protocol
 */
-(CGSize) contentSize;


- (id)initWithObjPath:(NSString *)path;
- (id)initWithMtlPath:(NSString *)path;
- (BOOL)LoadMtl:(NSString *)path;
- (BOOL)LoadObj:(NSString *)path;


@end




