//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: LoopingMenu.m
//
//	Last modified: 2/07/09
//

#import "LoopingMenu.h"
#import "InputController.h"

@interface Menu (Private)
// returns touched menu item, if any, implemented in Menu.m
-(MenuItem *) itemForTouch: (UITouch *) touch;
@end

@interface LoopingMenu (Animation)
- (void) updateAnimation;
@end

@implementation LoopingMenu


#pragma mark -
#pragma mark Menu
-(void) alignItemsVerticallyWithPadding:(float)padding 
{
	[self alignItemsHorizontallyWithPadding:padding];
}

-(void) alignItemsHorizontallyWithPadding:(float)padding 
{
    hPadding = padding;
    lowerBound = [(MenuItem*)[children objectAtIndex:0] contentSize].height / 2.0;
    [super alignItemsHorizontallyWithPadding:padding];
[self updateAnimation];}

-(void) registerWithTouchDispatcher 
{
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:false];
}

#pragma mark -
#pragma mark Touches
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if([[event allTouches] count] != 1)
        return false;
    moving = false;
    selectedItem = [super itemForTouch:touch];
    [selectedItem selected];
    
    state = kMenuStateTrackingTouch;
    return true;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if([[event allTouches] count] != 1)
    {
        [self ccTouchCancelled:touch withEvent:event];
        return;
    }
    
    if(!moving)
        [super ccTouchEnded:touch withEvent:event];
    else
        [self ccTouchCancelled:touch withEvent:event];
    moving = false;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event 
{
    [selectedItem unselected];
    
    state = kMenuStateWaiting;
    
    moving = false;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if([[event allTouches] count] != 1) {
        
        [self ccTouchCancelled:touch withEvent:event];
        return;
    }
    NSMutableSet* touches = [[[NSMutableSet alloc] initWithObjects:touch, nil] autorelease];
    
    CGPoint distance = icDistance(1, touches, event);
    
    if(icWasSwipeLeft(touches, event) && distance.y < distance.x) {
        
        moving = true;
        [selectedItem unselected];
        [self setPosition:ccpAdd([self position], ccp(-distance.x, 0))];
        
        MenuItem* leftItem = [children objectAtIndex:0];
        if([leftItem position].x + [self position].x + [leftItem contentSize].width / 2.0 < 0) {
            
            [leftItem retain];
            [children removeObjectAtIndex:0];
            MenuItem* lastItem = [children objectAtIndex:[children count] - 1];
            [leftItem setPosition:ccpAdd([lastItem position], ccp([lastItem contentSize].width / 2.0 + [leftItem contentSize].width / 2.0 + hPadding, 0))];
            [children addObject:leftItem];
            [leftItem autorelease];
        }
    } else if(icWasSwipeRight(touches, event) && distance.y < distance.x) {
        
        moving = true;
        [selectedItem unselected];
        [self setPosition:ccpAdd([self position], ccp(distance.x, 0))];
        
        MenuItem* lastItem = [children objectAtIndex:[children count] - 1];
        if([lastItem position].x + [self position].x - [lastItem contentSize].width / 2.0 > 480) {
            
            [lastItem retain];
            [children removeObjectAtIndex:[children count] - 1];
            MenuItem* firstItem = [children objectAtIndex:0];
            [lastItem setPosition:ccpSub([firstItem position], ccp([firstItem contentSize].width / 2.0 + [lastItem contentSize].width / 2.0 + hPadding, 0))];
            [children insertObject:lastItem atIndex:0];
            [lastItem autorelease];
        }
    } else if(!moving) {
        [super ccTouchMoved:touch withEvent:event];
    }
    
    [self updateAnimation];
}

@end

@implementation LoopingMenu (Animation)

-(void) updateAnimation
{
    static float quadraticCoefficient = -1.0/90000.0; //1/300^
    
    for(MenuItem<CocosNodeRGBA>* item in children)
    {
        float distance = fabsf([item position].x - 240.0 + [self position].x);
        
        if(distance > 240.0) {
            distance = 240.0;
        } else if(distance < 0.0) {
            distance = 0.0;
        }
        
        float ratio = quadraticCoefficient * (distance*distance) + 1;
        
        [item setScale: ratio];
        [item setOpacity:ratio * 255.0];
        [item setPosition:ccp([item position].x, -(lowerBound - [item contentSize].height * ratio / 2.0))];
    }
}

@end