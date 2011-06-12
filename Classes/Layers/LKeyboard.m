//
//	Created by mtt on 21/06/09
//
//	Project: intothefire
//	File: Keyboard.m
//
//	Last modified: 21/06/09
//
#import "StaticMethods.h"
#import "LKeyboard.h"
#import "StaticMethods.h"
#import "TouchDispatcher.h"
//#import "SGame.h"


@implementation LKeyboard


//@synthesize keyMgr;
@synthesize aDeactivatedKeys;

-(void) dealloc 
{
    if(aDeactivatedKeys) {
        [aDeactivatedKeys release];
        aDeactivatedKeys = nil;
    }
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"keyColour"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"keysFadeIn"
     object:nil];
    
    [super dealloc];
}

- (id) init 
{
    LOG(@"Keyboard layer");
    LOG_CURRENT_METHOD;
    
    self = [super init];
    if (self != nil) {
        
        aDeactivatedKeys = [[NSMutableArray alloc] init];

        // keys
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: plistPath];
        
        AtlasSpriteManager *keyMgr = [AtlasSpriteManager spriteManagerWithFile:@"keys.png" capacity:50];
        [self addChild:keyMgr z:4 tag:kMgrKeys];
        
        int i = 1; // counter
        int f = 0; // filter dupes
        for (id key in dictionary) 
        {
            //LOG(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
            
            NSDictionary *tempDict = [dictionary objectForKey:key];
            for (id nkey in tempDict ) 
            {
                if(f != i) {
                    [self addKey:i
                               x:[[tempDict objectForKey:@"x"] intValue]
                               y:[[tempDict objectForKey:@"y"] intValue]
                               w:[[tempDict objectForKey:@"w"] intValue]
                               h:[[tempDict objectForKey:@"h"] intValue]
                              pX:[[tempDict objectForKey:@"offsetX"] intValue]
                              pY:[[tempDict objectForKey:@"offsetY"] intValue]
                    ];
                    f = i;
                }
            }
            i++;
        }
    }
    return self;
}

- (void)onEnter 
{
    LOG_CURRENT_METHOD;
    
    [self setKeyTouchState: kKeyStateUngrabbed];
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deactivateKey:)
     name:@"keyColour"
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(fadeInKeys)
     name:@"keysFadeIn"
     object:nil]; 
    
    [super onEnter];
}

- (void)onExit 
{
    LOG_CURRENT_METHOD;
    
	[[TouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

#pragma mark -
#pragma mark customs

- (void)addKey:(int)kTag
             x:(int)x 
             y:(int)y
             w:(int)w
             h:(int)h
            pX:(int)pX
            pY:(int)pY 
{
    LOG(@"\r\n Key position:%d(x),%d(y) \r\n Key size: %d(w),%d(h)",x,y,w,h);

    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];
    
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(x,y,w,h) spriteManager:mgr];
	[mgr addChild:sprite z:4 tag:kTag];
    sprite.opacity = 0;
    sprite.position = ccp(adjustForStatusBar(pX), adjustForUpperLeftAnchor(pY+13)); //13 is a slight calc adjustment
}

- (void)fadeInKeys 
{
    LOG_CURRENT_METHOD;
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];
    id action = [FadeIn actionWithDuration:0.3f];
    
    for(AtlasSprite *item in [mgr children]) 
    { 
        LOG(@"Key Sprite: %d(tag), %.2f", item.tag, item.position.x);
        
        [item runAction: action];
        
        // !!! hack
        [item setVisible:YES];
        item.opacity = 255;
    }
}

- (void)deactivateKey:(NSNotification *)notification 
{
    LOG_CURRENT_METHOD;
    
    NSNumber *green = [notification object];
    LOG(@"Green? %d",[green intValue]);
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];

    if([green intValue] ==1) {
        // right
        //[[keyMgr getChildByTag: [self keyTagNumber]]runAction: [TintTo actionWithDuration:2 red:0 green:177 blue:0]]; // dark green
        [[mgr getChildByTag: [self keyTagNumber]]runAction: [TintTo actionWithDuration:0.8 red:209 green:229 blue:46]];
        
        @try {
            [aDeactivatedKeys addObject: [mgr getChildByTag: [self keyTagNumber]]];
        }
        @catch ( NSException *e ) {
            // TODO: 
        }
    } else {
        // wrong
        [[mgr getChildByTag: [self keyTagNumber]]runAction: [TintTo actionWithDuration:0.8 red:225 green:72 blue:7]];
        
        @try {
            [aDeactivatedKeys addObject: [mgr getChildByTag: [self keyTagNumber]]];
        }
        @catch ( NSException *e ) {
            // TODO: 
        }
    }
}

#pragma mark -
#pragma mark Custom Accessors
- (void)setKeyTouchState:(KeyState)s
{
    state = s;
}

- (KeyState)keyTouchState 
{
    return state;
}

- (void)setKeyTagNumber:(int)i 
{
    keyTag = i;
}

- (int)keyTagNumber 
{
    return keyTag;
}

#pragma mark -
#pragma mark touched stuff
-(CGRect) rect:(AtlasSprite *) item 
{ 
    CGSize s = [item contentSize]; 
    CGRect r = CGRectMake( item.position.x - s.width/2, 
                          item.position.y-s.height/2, 
                          s.width, s.height); 
    
    CGPoint offset = [self convertToWorldSpace:CGPointZero]; 
    r.origin.x += offset.x; 
    r.origin.y += offset.y; 
    
    return r; 
}

- (BOOL)containsTouchLocation:(UITouch *)touch 
{
    LOG_CURRENT_METHOD;
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];
    
    for(AtlasSprite *item in [mgr children]) 
    { 
        //LOG(@"Sprite: (x)%.2f, (y)%.2f | Touched: (x)%.2f, (y)%.2f", item.position.x, item.position.y, [self convertTouchToNodeSpace:touch].x, [self convertTouchToNodeSpace:touch].y);
        
        if(item.tag != 0xFFFFFFFF) {
            if(![aDeactivatedKeys containsObject: item]) {
                if(CGRectContainsPoint([self rect:item], [self convertTouchToNodeSpace:touch])) {
                    LOG(@"Child hit!");
                    [self setKeyTagNumber: item.tag];
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"keyPushed" object: [NSNumber numberWithInt: item.tag]];

                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    LOG_CURRENT_METHOD;
    
	if ([self keyTouchState] != kKeyStateUngrabbed) return NO;
	if ( ![self containsTouchLocation:touch] ) return NO;
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];
	
	[self setKeyTouchState: kKeyStateGrabbed];
    [[mgr getChildByTag: [self keyTagNumber]]runAction:[ScaleTo actionWithDuration:0.1 scale:1.3f]];
    
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    LOG_CURRENT_METHOD;
    
	NSAssert([self keyTouchState] == kKeyStateGrabbed, @"Key - Unexpected state!");	
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrKeys];

	[self setKeyTouchState: kKeyStateUngrabbed];
    [[mgr getChildByTag: [self keyTagNumber]] runAction:[ScaleTo actionWithDuration:0.1 scale:1.0f]];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {}


@end