//
//  LFlag.m
//  intothefire
//
//  Created by mtt on 1/07/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import "LFlag.h"
#import "StaticMethods.h"
#import "CEnums.h"
#import "glu.h"

#define LINES 1
#define PIOVER180 0.01745329252

@implementation LFlag


-(void) dealloc {
    
    [tex release];
    [super dealloc];
}    

-(id) init {
    LOG(@"LFlag Layer: Loading flag");
    LOG_CURRENT_METHOD;
    
    if( ! (self=[super init]) ) {
        return nil;
    }
    eye[0] = 5.0;
    eye[1] = 1.5;
    eye[2] = 2.0;
    
    center[0] = -5.0;
    center[1] = 1.5;
    center[2] = -10.0;
    
    int x;
    int y;
    int aPos;
    
    for(y=0;y<10;y++) {
        for(x=0,aPos=0;x<18;x++) {
            terrainPoints[y][aPos][0] = (float)x;
            terrainPoints[y][aPos][1] = (float)y + 1;
            terrainPoints[y][aPos][2] = (float)sin(x*20.0f*PIOVER180)*1.5f;
            
            terrainCoords[y][aPos][0] = x*1.0f/18.0f;
            terrainCoords[y][aPos][1] = (y+1)*1.0f/10.0f;
            
            terrainPoints[y][aPos+1][0] = (float)x;
            terrainPoints[y][aPos+1][1] = (float)y;
            terrainPoints[y][aPos+1][2] = (float)sin(x*20.0f*PIOVER180)*1.5f;
            
            terrainCoords[y][aPos+1][0] = x*1.0f/18.0f;
            terrainCoords[y][aPos+1][1] = (y+1)*1.0f/10.0f;
            
            LOG(@"P: %f ,%f ,%f", terrainPoints[y][aPos][0],terrainPoints[y][aPos][1],terrainPoints[y][aPos][2]);
            LOG(@"C: %f ,%f", terrainCoords[y][aPos][0],terrainCoords[y][aPos][1]);
            
            
        }
    }
    
    tex = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"green.jpg" ofType:nil]]];
    return self;
}

// Updates the OpenGL view when the timer fires
- (void)draw {
    /*
    glMatrixMode(GL_PROJECTION); 
    glLoadIdentity(); 
    gluPerspective(50.0, 1.0, 3.0, 7.0); 
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(4.0, 2.0, 1.0, 0.0, 0.0, 0.0, 2.0, 1.0, -1.0);
     */
    glMatrixMode(GL_MODELVIEW);
    const GLfloat floorVertices[] = {
        -1.0, 1.0, 0.0,     // Top left
        -1.0, -1.0, 0.0,    // Bottom left
        1.0, -1.0, 0.0,     // Bottom right
        1.0, 1.0, 0.0       // Top right
    };
	const GLfloat floorTC[] = {
		0.0, 1.0,
		0.0, 0.0,
		1.0, 0.0,
		1.0, 1.0
	};
    
    // Turn necessary features on
    glEnable(GL_TEXTURE_2D);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glBindTexture(GL_TEXTURE_2D, [tex name]);    
    //glVertexPointer(3, GL_FLOAT, 0, terrainPoints);
	//glTexCoordPointer(2, GL_FLOAT, 0, terrainCoords);
    glVertexPointer(3, GL_FLOAT, 0, floorVertices);
    glTexCoordPointer(2, GL_FLOAT, 0, floorTC);
    
    [self handleTouches];
    gluLookAt(eye[0], eye[1], eye[2], center[0], center[1], center[2], 0.0, 1.0, 0.0);
    for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 10; j++) {
            glPushMatrix();
            {
                glTranslatef(10.0+(j*-2.0), -2.0, -2.0+(i*-2.0));
                glRotatef(-90.0, 1.0, 0.0, 0.0);
                glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
                //glDrawArrays(GL_TRIANGLE_STRIP, 0, 36);
            }
            glPopMatrix();
        }
    } 
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    //glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
}

#pragma mark Touch Handling

- (void)handleTouches {
    
    GLfloat vector[3];
    
    vector[0] = center[0] - eye[0];
    vector[1] = center[1] - eye[1];
    vector[2] = center[2] - eye[2];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    LOG_CURRENT_METHOD;
    return NO;
}

- (BOOL)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    LOG_CURRENT_METHOD;
    return NO;
}

@end