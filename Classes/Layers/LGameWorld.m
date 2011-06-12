//
//  LGameWorld.m
//  intothefire
//
//  Created by mtt on 2/07/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//
#import "StaticMethods.h"
#import "LGameWorld.h"
#import "TouchDispatcher.h"
#import "Tui.h"
#import "LClouds.h"
#import "LHangman.h"


@implementation LGameWorld


- (void)dealloc 
{
    [Tui release];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"closeGameBoard"
     object:nil];
    
    [super dealloc];
}

- (id) init 
{
    LOG_CURRENT_METHOD;
    
    self = [super init];
    if (self != nil) {
        LOG(@"Game world");
        
        Texture2D *tex = [[TextureMgr sharedTextureMgr] addImage:@"game_assets.png"];
        AtlasSpriteManager *baseMgr = [AtlasSpriteManager spriteManagerWithTexture: tex capacity:50];
        [self addChild:baseMgr z:0 tag:kMgrAssests];
        
        // background
        AtlasSprite *bkgnd = [AtlasSprite spriteWithRect:CGRectMake(1,164,480,320) spriteManager:baseMgr];
        [baseMgr addChild:bkgnd z:1];
        bkgnd.position = ccp(240,160);
        
        // main pieces
        [self addPuzzle:baseMgr];
        [self addQuestion:baseMgr];
        [self addPlus:baseMgr];

        // characters
        tui = [[Tui alloc] init];
        
        LClouds *cloud = [[LClouds alloc] init];
        [self addChild:cloud z:99];
        [cloud release];
    }
    return self;
}

- (void)onEnter 
{
    LOG_CURRENT_METHOD;
        
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(closeKeyboard)
     name:@"closeGameBoard"
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
#pragma mark Customs
/* 
 * A farked up work-a-round to a farked up implementation of Atlas Sprites
 */
- (void)addPuzzle:(AtlasSpriteManager *)baseMgr 
{
    AtlasSprite *puzzle = [AtlasSprite spriteWithRect:CGRectMake(718,1,52,53) spriteManager:baseMgr];
    [baseMgr addChild:puzzle z:10 tag:kGameWorldPuzzle];
    puzzle.position = ccp(30,adjustForUpperLeftAnchor(30.0));
    puzzle.scale = 0.6f;
}

- (void)addQuestion:(AtlasSpriteManager *)baseMgr 
{
    //AtlasSprite *question = [AtlasSprite spriteWithRect:CGRectMake(626,1,40,60) spriteManager:baseMgr]; // short
    AtlasSprite *question = [AtlasSprite spriteWithRect:CGRectMake(780,88,40,60) spriteManager:baseMgr]; // shorter
    [baseMgr addChild:question z:10 tag:kGameWorldQuestion];
    question.position = ccp(452,adjustForUpperLeftAnchor(33.0));
    question.scale = 0.6f;
}

- (void)addPlus:(AtlasSpriteManager *)baseMgr 
{
    AtlasSprite *plusPiece = [AtlasSprite spriteWithRect:CGRectMake(887,1,51,51) spriteManager:baseMgr]; 
    [baseMgr addChild:plusPiece z:10 tag:kGameWorldPlus];
    plusPiece.position = ccp(450, 30);
    plusPiece.scale = 0.6f;
}

- (void)addReturn:(AtlasSpriteManager *)baseMgr 
{
    //AtlasSprite *gbReturn = [AtlasSprite spriteWithRect:CGRectMake(812,1,74,56) spriteManager:baseMgr]; 
    AtlasSprite *gbReturn = [AtlasSprite spriteWithRect:CGRectMake(939,1,74,56) spriteManager:baseMgr]; 
    [baseMgr addChild:gbReturn z:10 tag:kGameWorldReturn];
    //gbReturn.position = ccp(240, adjustForUpperLeftAnchor(205));
    gbReturn.position = ccp(203, adjustForUpperLeftAnchor(205));
    gbReturn.scale = 0.6f;
    gbReturn.opacity = 0;
}

- (void)addSpeech:(AtlasSpriteManager *)baseMgr 
{
    //AtlasSprite *speech = [AtlasSprite spriteWithRect:CGRectMake(906,88,85,72) spriteManager:baseMgr]; // plain
    AtlasSprite *speech = [AtlasSprite spriteWithRect:CGRectMake(514,403,87,74) spriteManager:baseMgr];
    [baseMgr addChild:speech z:10 tag:kGameWorldSpeech];
    //speech.position = ccp(240, adjustForUpperLeftAnchor(205));
    speech.position = ccp(281.5, adjustForUpperLeftAnchor(205));
    speech.scale = 0.55f;
    speech.opacity = 0;
}

// TODO: !!
- (void)loadLevelFile 
{
    LOG_CURRENT_METHOD;
    
    //NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    
    [gb loadLevelWordList:@"words001" guesses:6];
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];    
    id puzzleSprite = [mgr getChildByTag:kGameWorldPuzzle];
    [puzzleSprite runAction: [FadeOut actionWithDuration:0.4f]];
    [mgr removeChild:puzzleSprite cleanup:YES];
    
    id questionSprite = [mgr getChildByTag:kGameWorldQuestion];
    [questionSprite runAction: [FadeOut actionWithDuration:0.4f]];
    [mgr removeChild:questionSprite cleanup:YES];
    
    id ps = [mgr getChildByTag:kGameWorldPlus];
    [ps runAction: [FadeOut actionWithDuration:0.4f]];
    [mgr removeChild:ps cleanup:YES];
    
}

- (void)setupGameBoard 
{
    gb = [[LHangman alloc] init];
    [self addChild: gb z:500];
}

- (void)setupRandomWord
{
    [gb chooseRandomWord];
}

- (void)releaseGameBoard 
{
    [self removeChild:gb cleanup:NO];
    [gb release];
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests]; 
    id returnSprite = [mgr getChildByTag:kGameWorldReturn];
    [mgr removeChild:returnSprite cleanup:YES];
    
    id speechSprite = [mgr getChildByTag:kGameWorldSpeech];
    [mgr removeChild:speechSprite cleanup:YES];
    
    [self addPuzzle:mgr];
	[self addQuestion:mgr];
    [self addPlus:mgr];
}

- (void)closeKeyboard 
{
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];
    [self addReturn:mgr];
    [self addSpeech:mgr];
    
    id returnSprite = [mgr getChildByTag:kGameWorldReturn];
    [gb hideKeyboard];
    id fadeInReturn = [Sequence actions: 
                 [DelayTime actionWithDuration:0.5], 
                 [FadeIn actionWithDuration:0.3f],
                 nil];
    
    [returnSprite runAction: fadeInReturn];
    
    id speechSprite = [mgr getChildByTag:kGameWorldSpeech];
    id fadeInSpeech = [Sequence actions: 
                  [DelayTime actionWithDuration:0.5], 
                  [FadeIn actionWithDuration:0.3f],
                  nil];
    
    [speechSprite runAction: fadeInSpeech];
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
    
    id action = [Sequence actions: 
                 [CallFunc actionWithTarget:self selector:@selector(setupGameBoard)], 
                 [DelayTime actionWithDuration:0.5], 
                 [CallFunc actionWithTarget:self selector:@selector(loadLevelFile)], 
                 [CallFunc actionWithTarget:self selector:@selector(setupRandomWord)], 
                 nil];
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];
    for(AtlasSprite *item in [mgr children]) 
    { 
        if(item.tag != 0xFFFFFFFF) {
            if(CGRectContainsPoint([self rect:item], [self convertTouchToNodeSpace:touch])) {
                LOG(@"Child hit!");
                
                switch (item.tag) {
                    case kGameWorldPuzzle:                        
                        [self runAction:action]; // delay between init and action
                        break;
                    case kGameWorldQuestion:
                        [gb hideKeyboard];
                        break;
                    case kGameWorldReturn:
                        [self releaseGameBoard];
                        break;

                    default:
                        break;
                }                
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    LOG_CURRENT_METHOD;
    
	if (![self containsTouchLocation:touch]) {
        return NO;
    }
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {}

@end
