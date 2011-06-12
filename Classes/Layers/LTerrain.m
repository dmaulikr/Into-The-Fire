//
//	Created by Cleave Pokotea on 5/03/09
//
//	Project: 3dNode
//	File: LModels.m
//
//	Last modified: 5/03/09
//

#import "LTerrain.h"
#import "StaticMethods.h"
#import "CEnums.h"
#import "glu.h"

const GLfloat triVerticies[] = {
0.0f, 1.0f, 0.0f,
-1.0f, -1.0f, 0.0f,
1.0f, -1.0f, 0.0f,
/*
// FRONT
0, 0, -10,
4, 0, -10,
0, 5, -10,
4, 5, -10,
// BACK
0, 0, -15,
4, 0, -15,
0, 5, -15,
4, 5, -15,
// LEFT
0, 0, -15,
0, 5, -15,
0, 0, -10,
0, 5, -10,
// RIGHT
4, 0, -15,
4, 5, -15,
4, 0, -10,
4, 5, -10,
// TOP
0, 5, -15,
4, 5, -15,
0, 5, -10,
4, 5, -10,
// BOTTOM
0, 0, -15,
4, 0, -15,
0, 0, -10,
4, 0, -10,
*/
};

const GLfloat tvtest[] = {
// FRONT
0, 0, -10,
4, 0, -10,
0, 5, -10,

0.000000 ,-10.000000 ,10.000000,
0.000000 ,-9.000000 ,10.000000,
1.000000 ,-8.000000 ,10.000000,
1.000000 ,-7.000000 ,10.000000, 
2.000000 ,-6.000000 ,10.000000, 

0.000000 ,1.000000 ,-31.000000, 
1.000000 ,25.000000 ,-31.000000, 
2.000000 ,26.000000 ,-31.000000, 
3.000000 ,27.000000 ,-31.000000, 
4.000000 ,28.000000 ,-31.000000, 
5.000000 ,29.000000 ,-31.000000, 
6.000000 ,30.000000 ,-31.000000, 
7.000000 ,-31.000000 ,-31.000000, 
8.000000 ,32.000000 ,-31.000000, 
9.000000 ,-33.000000 ,-31.000000, 
10.000000 ,-34.000000 ,-31.00000, 
11.000000 ,35.000000 ,-31.000000, 
12.000000 ,36.000000 ,-31.000000, 
13.000000 ,-37.000000 ,-31.000000, 
14.000000 ,-38.000000 ,-31.000000, 
15.000000 ,-39.000000 ,-31.000000, 
16.000000 ,-40.000000 ,-31.000000, 
17.000000 ,-41.000000 ,-31.000000, 
18.000000 ,-42.000000 ,-31.000000, 
19.000000 ,-43.000000 ,-31.000000, 
20.000000 ,-44.000000 ,-31.000000, 
21.000000 ,-45.000000 ,-31.000000, 
22.000000 ,-46.000000 ,-31.000000, 
23.000000 ,4.000000 ,-31.000000, 
24.000000 ,48.000000 ,-31.000000, 
25.000000 ,49.000000 ,-31.000000, 
26.000000 ,50.000000 ,-31.000000, 
27.000000 ,51.000000 ,-31.000000, 
28.000000 ,5.000000 ,-31.000000, 
29.000000 ,-53.000000 ,-31.000000, 
30.000000 ,-54.000000 ,-31.000000, 
31.000000 ,55.000000 ,-31.000000,
};

const GLubyte triColors[] = {
255, 0, 0,
0,255,0,
0, 0, 255
};

static const ccVertex3F normals[] = {
{0.0, 0.0, 1.0},
{0.0, 0.0, 1.0},
{0.0, 0.0, 1.0},
};
static const TextureCoord3D texCoords[] = {
{0.666667,0.333333},
{0.666667,0.666667},
{0.333334,0.666667},
{0.666667,0.333333},
{0.333334,0.666667},
{0.333333,0.333333},
{0.666667,1.000000},
{0.666667,0.666667},
{1.000000,0.666667},
{0.666667,1.000000},
{1.000000,0.666667},
{1.000000,1.000000},
{0.666667,0.000000},
{0.666667,0.333333},
{0.333333,0.000000},
{0.666667,0.333333},
{0.333333,0.333333},
{0.333333,0.000000},
{0.333333,0.333333},
{0.333333,0.666667},
{0.000000,0.333333},
{0.333333,0.666667},
{0.000000,0.666667},
{0.000000,0.333333},
{0.333333,0.333333},
{0.000000,0.333333},
{0.333333,0.000000},
{0.000000,0.333333},
{0.000000,0.000000},
{0.333333,0.000000},
{0.666667,1.000000},
{0.333333,1.000000},
{0.333333,0.666667},
{0.666667,1.000000},
{0.333333,0.666667},
{0.666667,0.666667},
};
/*
0.0, 1.0,
1.0, 0.0,
0.0, 0.0,
};
*/

const GLubyte indices [] = {1, 2, 0, 3};
#define LINES 1

@implementation LTerrain


@synthesize plane;

-(void) dealloc {

    [tex release];
    [super dealloc];
}    

-(id) init {
    LOG(@"LTerrain Layer: Loading terrain");
    LOG_CURRENT_METHOD;
    
    if( ! (self=[super init]) ) {
        return nil;
    }
    
    /*
     All we do within the loop is set the coordinate of each vertex, 
     using the x and z positions from our loop and the y position from 
     our gfTerrainHeights array. We are building the vertex array as a 
     one-dimensional array rather than using two dimensions. The 
     reason for this is that we will later need to specify an index 
     for each vertex, and we are only able to use a single number for 
     this. To build the two-dimensional data into a one-dimensional 
     array, we multiply the z array index by the number of elements 
     in the x part of the array (TERRAIN_X), resulting in the index 
     being calculated as follows:
     
     x	z	result
     0	0	0 + (0*4) = 0
     1	0	1 + (0*4) = 1
     2	0	2 + (0*4) = 2
     3	0	3 + (0*4) = 3
     0	1	0 + (1*4) = 4
     1	1	1 + (1*4) = 5
     2	1	2 + (1*4) = 6
     3	1	3 + (1*4) = 7
     0	2	0 + (2*4) = 8
     ...	...	...
     2	3	2 + (3*4) = 14
     3	3	3 + (3*4) = 15
     */     
    
    int z = 1;
    int x = 9;
    for(z=0;z < MAP_Z; z++) {
        
        for(x=0;x < MAP_X; x++) {
            terrain[x][z][0] = x; //x
            terrain[x][z][1] = (x + (z*4)); //y = height
            terrain[x][z][2] = -z; //z
            
            LOG(@"%f ,%f ,%f ", terrain[x][z][0],terrain[x][z][1],terrain[x][z][2] );
        }
    }
    int s=0;
    for(int y=0;y < 4;y++) {
        for(z=0;z < 64; z++) {
            if(y==0) {
                if(s==0) {
                    texOrd0[z] = 0.0f;
                    s=1;
                }else if (s==1) {
                    texOrd0[z] = 0.0f;
                    s=0;
                }
            }
            
            if(y==1) {
                if(s==0) {
                    texOrd1[z] = 1.0f;
                    s=1;
                }else if (s==1) {
                    texOrd1[z] = 0.0f;
                    s=0;
                }
            }
            
            if(y==2) {
                if(s==0) {
                    texOrd2[z] = 0.0f;
                    s=1;
                }else if (s==1) {
                    texOrd2[z] = 1.0f;
                    s=0;
                }
            }
            
            if(y==3) {
                if(s==0) {
                    texOrd3[z] = 1.0f;
                    s=1;
                }else if (s==1) {
                    texOrd3[z] = 1.0f;
                    s=0;
                }
            }
        }
    }
    //LOG(@"texOrd0: %@", texOrd0);
    //LOG(@"t: %@", [terrain arrayRepresentation]);

    tex = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"green.jpg" ofType:nil]]];
    return self;
}

// Updates the OpenGL view when the timer fires
- (void)draw {
    glMatrixMode(GL_MODELVIEW);
    
    // Turn necessary features on
    glEnable(GL_TEXTURE_2D);

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glLoadIdentity();
    
    //gluLookAt(0, 0, [Camera getZEye],0, 0, 0,0.0f, 1.0f, 0.0f);
    //glTranslatef(0.0, 0.0, -3.0);
    
    //*
    glBindTexture(GL_TEXTURE_2D, [tex name]);
    //glVertexPointer(3, GL_FLOAT, 0, triVerticies);
    glVertexPointer(3, GL_FLOAT, 0, tvtest);
    //glVertexPointer(3, GL_FLOAT, 0, terrain);
	glNormalPointer(GL_FLOAT, 0, normals);
    //glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glTexCoordPointer(2, GL_FLOAT, 0, texOrd3);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 64);
    //glDrawArrays(GL_TRIANGLES, 0, 64);
    
    //glTranslatef(-3.0f,-3.0f,-60.0f);
    
    for (int i = 0; i < 10; i++) {
    glDrawArrays(LINES ? GL_LINE_STRIP : GL_TRIANGLE_STRIP, i * 36, 36);
    }
     //*/
    /*
    float lookX = (MAP_X*MAP_SCALE)/2.0f;
    float lookY = 150.0f;
    float lookZ = -(MAP_Z*MAP_SCALE)/2.0f;
    
    gluLookAt(0.0, 0.0, -5.0, lookX, lookY, lookZ, 0.0, 1.0, 0.0);
    glBindTexture(GL_TEXTURE_2D, tex.name);
    
    for (int z=0;z<MAP_Z-1;z++) {
        for (int x=0;x<MAP_X-1;x++) {
            glVertexPointer(3, GL_FLOAT, 0, terrain[x][z]);
            glTexCoordPointer(2, GL_FLOAT, 0, texOrd0);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 32);
            

            glVertexPointer(3, GL_FLOAT, 0, terrain[x+1][z]);
            glTexCoordPointer(2, GL_FLOAT, 0, texOrd1);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 32);
            
            glVertexPointer(3, GL_FLOAT, 0, terrain[x][z+1]);
            glTexCoordPointer(2, GL_FLOAT, 0, texOrd2);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 32);
            
            glVertexPointer(3, GL_FLOAT, 0, terrain[x+1][z+1]);
            glTexCoordPointer(2, GL_FLOAT, 0, texOrd3);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 32);
 
        }
    }
    */
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    //glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
}

@end