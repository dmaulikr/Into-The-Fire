//
//  LObjectTest.m
//  intothefire
//
//  Created by mtt on 24/06/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//

#import "LObjectTest.h"
#import "StaticMethods.h"


@implementation LObjectTest


@synthesize obj;

-(void) dealloc {
    
    [super dealloc];
}

-(id) init {
    LOG(@"LModels Layer: Loading or model");
    LOG_CURRENT_METHOD;
    
    if( ! (self=[super init]) ) {
        return nil;
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"pod" ofType:@"obj"];
    CocosNode3d * obj1 = [[CocosNode3d alloc] initWithObjPath:path];
    
    NSString * path2 = [[NSBundle mainBundle] pathForResource:@"pod" ofType:@"mtl"];
    CocosNode3d * obj2 = [[CocosNode3d alloc] initWithMtlPath:path];
    
    ccVertex3F pos;
    pos.z = -8.0;
    pos.y = 3.0;
    pos.x = 0.0;
    obj.currentPosition = pos;
    self.obj = obj1;
    [obj1 release];
    
    return self;
}

// Updates the OpenGL view when the timer fires
- (void)draw {
    
    static GLfloat rota = 0.0;
    
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // black bkgnd
    //
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_LIGHTING);
    //
    //glPushMatrix(); // resets to portrait
    glLoadIdentity(); 
    
    glColor4f(0.0, 0.5, 1.0, 1.0);
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_POLYGON_OFFSET_FILL);
    glEnable(GL_BLEND);
    glEnable(GL_TEXTURE_2D);
    
    [obj draw];
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime) {
        
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rota += 50 * timeSinceLastDraw;	
        
        ccVertex3F rot;
        rot.x = rota;
        rot.y = rota;
        rot.z = rota;
        obj.currentRotation = rot;
    }
    
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
    
    glBlendFunc(/*GL_SRC_ALPHA*/ GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}

@end