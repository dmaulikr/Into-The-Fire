//
//  CocosNode3d.m
//  cocos2d-iphone
//
//  Created by Cleave Pokotea on 5/03/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import "CocosNode3d.h"
#import "StaticMethods.h"


@implementation CocosNode3d


@synthesize opacity;
@synthesize currentPosition;
@synthesize currentRotation;
@synthesize name;
@synthesize textureName;

- (void)dealloc 
{
    if (vertices) { 

        free(vertices);
    }
    if (faces) {

        free(faces);
    }

    [textureAtlas release];
    [super dealloc];
}


- (id)initWithObjPath:(NSString *)path 
{
    LOG_CURRENT_METHOD;

    if ((self = [super init])) {
        LOG(@"path: %@", path);

        [self LoadObj: path];
    }
    
    return self;
}

- (id)initWithMtlPath:(NSString *)path 
{
    LOG_CURRENT_METHOD;
    
    if ((self = [super init])) {
        LOG(@"path: %@", path);
        
        [self LoadMtl: path];
    }
    
    return self;
}

- (void)draw 
{
    /*
     * This enables the use of an array of vertices
     *
     * Other glEnableClientState possibilities include: 
     * GL_COLOR_ARRAY, GL_SECONDARY_COLOR_ARRAY, GL_NORMAL_ARRAY,
     * GL_FOG_COORDINATE_ARRAY, GL_TEXTURE_COORD_ARRAY, GL_EDGE_FLAG_ARRAY
     */
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // Save the current transformation by pushing it on the stack
    glPushMatrix();

    // Load the identity matrix to restore to origin
    glLoadIdentity();

    /*
     * "Translate" means moving the model via x,y,z coordinates
     */
    glTranslatef(currentPosition.x, currentPosition.y, currentPosition.z);

    /*
     * Tumble effect
     *
     * Rotates model on the x axis, then y axis, then z axis.
     */
    glRotatef(currentRotation.x, 1.0, 0.0, 0.0);
    glRotatef(currentRotation.y, 0.0, 1.0, 0.0);
    glRotatef(currentPosition.z, 0.0, 0.0, 1.0);

    /*
     * glVertexPointer(size, type, stride, pointer
     *     
     * We tell OpenGL where the data is stored
     *
     * Other corresponding types:
     * glColorPointer(), glTexCoodPointer(), glSecondaryColorPointer(),
     * glNormalPoiter(), glFogCoordPointer(), glEdgeFlagPointer()
     *
     * Note: Normals always have size 3     
     */
    glVertexPointer(3, GL_FLOAT, 0, vertices); 
    
    //glNormalPointer(GL_FLOAT, 0, norms); 
    //glTexCoordPointer(2, GL_FLOAT, 0, texCoords); 

    // Loop through faces and draw them
    for (int i = 0; i < numberOfFaces; i++) 
    {
        glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, &faces[i]); 
    }

    glDisableClientState(GL_VERTEX_ARRAY);

    // Restore the current transformation by popping it off
    glPopMatrix();
    
    
    glBlendFunc(/*GL_SRC_ALPHA*/ GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}


- (GLuint)textureName 
{
    /*
     * ???
     */
    if(0 == textureName) { }
            
    return textureName;
}


- (CGSize)contentSize 
{
    return CGSizeMake(0,0);
}

#pragma mark -
#pragma mark Load OBJ
- (BOOL)LoadMtl:(NSString *)path 
{
    LOG_CURRENT_METHOD;
    
    NSString *objData = [NSString stringWithContentsOfFile:path];
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
    
    mtrl = malloc(sizeof(mttMtrl)); // !! Fix set to mtrl[1] because I'm lazy ;)
    
    for (NSString * line in lines) 
    { 
        if ([line hasPrefix:@"newmtl "])	{
            LOG(@"Name of the material");
            
        } else if ([line hasPrefix:@"Ka "]) {
            LOG(@"Ka spectral: specifies the ambient reflectivity using RGB values");
            
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineKa = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            mtrl[1].aCol.x = [[lineKa objectAtIndex:0] floatValue];
            mtrl[1].aCol.y = [[lineKa objectAtIndex:1] floatValue];
            mtrl[1].aCol.z = [[lineKa objectAtIndex:2] floatValue];         
        } else if ([line hasPrefix:@"Kd "]) {
            LOG(@"Kd spectral: specifies the diffuse reflectivity using RGB values");
            
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineKd = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            mtrl[1].dCol.x = [[lineKd objectAtIndex:0] floatValue];
            mtrl[1].dCol.y = [[lineKd objectAtIndex:1] floatValue];
            mtrl[1].dCol.z = [[lineKd objectAtIndex:2] floatValue];       
            
        } else if ([line hasPrefix:@"Ks "]) {
            LOG(@"Ks spectral: specifies the specular reflectivity using RGB values");
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineKs = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            mtrl[1].dCol.x = [[lineKs objectAtIndex:0] floatValue];
            mtrl[1].dCol.y = [[lineKs objectAtIndex:1] floatValue];
            mtrl[1].dCol.z = [[lineKs objectAtIndex:2] floatValue];       
            
        } else if ([line hasPrefix:@"Tr "]) {
            LOG(@"Tr spectral: specifies the transmission filter using RGB values");
            
            mtrl[1].Opacity = [[line substringFromIndex:3] floatValue];
        } else if ([line hasPrefix:@"Ns "]) {
            LOG(@"Ns: defines the focus of the specular highlight");
            
            mtrl[1].Reflect = [[line substringFromIndex:3] floatValue];
        } else if ([line hasPrefix:@"map_Ka "]) {
            LOG(@"map_Ka: specifies that a color texture file or a color procedural texture file is applied to the ambient reflectivity of the material");
            
            mtrl[1].aTextName[0] = [[line substringFromIndex:7] UTF8String];
        } else if ([line hasPrefix:@"map_Kd "]) {
            LOG(@"map_Kd: specifies that a color texture file or color procedural texture file is linked to the diffuse reflectivity of the material");
            
        } else if ([line hasPrefix:@"map_Ks "]) {
            LOG(@"map_ks: specifies that a color texture file or color procedural texture file is linked to the specular reflectivity of the materia");
            
        } else if ([line hasPrefix:@"Smooth "]) {
            
        } else if ([line hasPrefix:@"Normal "]) {
            
        }
        
    }
    
    return YES;
}

- (BOOL)LoadObj:(NSString *)path 
{
    LOG_CURRENT_METHOD;
    
    NSUInteger vertexCount = 0;
    NSUInteger texCount = 0;
    NSUInteger normsCount = 0;
    NSUInteger faceCount = 0;
    NSString *objData = [NSString stringWithContentsOfFile:path];
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];

    for (NSString * line in lines) 
    { 
        
        if ([line hasPrefix:@"v "]) {
            vertexCount++;
        } else if ([line hasPrefix:@"vt "]) {
            texCount++;
        } else if ([line hasPrefix:@"vn "]) {
            normsCount++;
        } else if ([line hasPrefix:@"f "]) {
            faceCount++;
        }
    }

    LOG(@"Vertices: %d, Texts: %d, Normals: %d, Faces: %d", vertexCount, texCount, normsCount, faceCount);
    vertices = malloc(sizeof(ccVertex3F) * vertexCount);
    texCords = malloc(sizeof(mttTexCoords) * texCount);
    norms = malloc(sizeof(ccVertex3F) * normsCount);
    faces = malloc(sizeof(mttFace) * faceCount);

    // Reuse our count variables for second time through
    vertexCount = 0;
    texCount = 0;
    normsCount = 0;
    faceCount = 0;
    for (NSString *line in lines) 
    {
        if ([line hasPrefix:@"v "])	{
            LOG(@"v");
            
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            vertices[vertexCount].x = [[lineVertices objectAtIndex:0] floatValue];
            vertices[vertexCount].y = [[lineVertices objectAtIndex:1] floatValue];
            vertices[vertexCount].z = [[lineVertices objectAtIndex:2] floatValue];
            
            vertexCount++;
        } else if ([line hasPrefix:@"vt "]) {
            LOG(@"vt");
            
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineVerticesTexts = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([lineVerticesTexts count] == 3) {
                texCords[texCount].u = [[lineVerticesTexts objectAtIndex:0] floatValue];;
                texCords[texCount].v = [[lineVerticesTexts objectAtIndex:1] floatValue];;
                texCords[texCount].w = [[lineVerticesTexts objectAtIndex:2] floatValue];;
            } else if ([lineVerticesTexts count] == 2) {
                texCords[texCount].u = [[lineVerticesTexts objectAtIndex:0] floatValue];;
                texCords[texCount].v = [[lineVerticesTexts objectAtIndex:1] floatValue];;
                texCords[texCount].w = 0.0f;
            }
            
            texCount++;
        } else if ([line hasPrefix:@"f "]) {
            LOG(@"f");
            
            NSString * lineTrunc = [line substringFromIndex:2];
            NSArray * faceIndexGroups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString * oneGroup = [faceIndexGroups objectAtIndex:0];
            NSArray * groupParts = [oneGroup componentsSeparatedByString:@"/"];
            faces[faceCount].v1 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1; // indices in file are 1-indexed, not 0 indexed
            oneGroup = [faceIndexGroups objectAtIndex:1];
            groupParts = [oneGroup componentsSeparatedByString:@"/"];
            faces[faceCount].v2 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;	
            
            oneGroup = [faceIndexGroups objectAtIndex:2];
            groupParts = [oneGroup componentsSeparatedByString:@"/"];
            faces[faceCount].v3 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
            
            faceCount++;
        }
    }

    numberOfFaces = faceCount;
    return YES;
}


// http://forums.macrumors.com/archive/index.php/t-547587.html
// perspective(85, 480/320, 0.01,10);
void perspective(double fovy, double aspect, double zNear, double zFar) 
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    double xmin, xmax, ymin, ymax;
    
    ymax = zNear * tan(fovy * M_PI / 360.0);
    ymin = -ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;
    
    glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
    
    glMatrixMode(GL_MODELVIEW);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);	
    
    glDepthMask(GL_TRUE);
}

void orthographic()	
{ 
    glMatrixMode(GL_PROJECTION);	
    glLoadIdentity();	
    glOrthof( 0, 320, 480, 0, 1, 0 );	
    glMatrixMode(GL_MODELVIEW);	
    glLoadIdentity();	
    glDepthMask(GL_FALSE);
}

@end
