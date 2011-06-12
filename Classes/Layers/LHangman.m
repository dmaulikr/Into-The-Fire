//
//	Created by mtt on 22/06/09
//
//	Project: intothefire
//	File: LGameBoard.m
//
//	Last modified: 22/06/09
//
#import "StaticMethods.h"
#import "LHangman.h"
#import "LKeyboard.h"


#define SCREEN_HEIGHT 213
#define SCREEN_WIDTH 480
#define MASK_TAG kGameBoardMask
#define MASK_SPACE 2.5
#define IMAGE_WIDTH 50
#define IMAGE_HEIGHT 63
#define DOUBLE_LETTER 1.25


@implementation LHangman

//@synthesize bgKeyboard;

- (void)dealloc 
{
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"keyPushed"
     object:nil];
    
    if(alreadyGuessed) {
		[alreadyGuessed release];
		alreadyGuessed = nil;
	}
	
	if(hiddenWord) {
		[hiddenWord release];
		hiddenWord = nil;
	}
    
    [wordList release];
    [super dealloc];
}

- (id) init 
{
    LOG_CURRENT_METHOD;
    
    self = [super init];
    if (self != nil) {
        LOG(@"Game scene");
        
        numberOfDoubleLetters = 0;
        maxGuesses = 3;
        numberOfWrongGuesses = 0;
        replaceMaskSolve = NO;
        
        Texture2D *bTex = [[TextureMgr sharedTextureMgr] addImage:@"game_assets.png"];
        AtlasSpriteManager *bgMgr = [AtlasSpriteManager spriteManagerWithTexture: bTex capacity: 50];
        [self addChild: bgMgr z: 2 tag: kMgrAssests];
        
        Texture2D *lTex = [[TextureMgr sharedTextureMgr] addImage:@"letters.png"];
        AtlasSpriteManager *letterMgr = [AtlasSpriteManager spriteManagerWithTexture: lTex capacity: 30];
        [self addChild: letterMgr z:3  tag: kMgrLetters];
        
        // keyboard
        //bgKeyboard = [AtlasSprite spriteWithRect: CGRectMake(514,164,480,106) spriteManager: baseMgr]; // plain
        //bgKeyboard.position = ccp(240, -107); // plain
        bgKeyboard = [AtlasSprite spriteWithRect: CGRectMake(514,271,480,130) spriteManager: bgMgr];
        [bgMgr addChild: bgKeyboard z:2 tag: kGameBoardKeyboard];
        bgKeyboard.position = ccp(240, -131);
    }
    return self;
}

- (void)onEnter 
{
    LOG_CURRENT_METHOD;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(guess:)
     name:@"keyPushed"
     object:nil]; 
    
    [super onEnter];
}

#pragma mark -
#pragma mark Levels
- (void)loadLevelWordList:(NSString *)level guesses:(int)maximumNumberOfGuesses 
{
    LOG_CURRENT_METHOD;
    
    maxGuesses = maximumNumberOfGuesses;
    wordList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: level ofType:@"plist"]];
}

#pragma mark -
#pragma mark Resets
- (void)resetArrays 
{
	if (alreadyGuessed) {
		[alreadyGuessed release];
		alreadyGuessed = nil;
	}
	alreadyGuessed = [[NSMutableDictionary alloc] init];
	
	if (hiddenWord) {
		[hiddenWord release];
		hiddenWord = nil;
	}
	//hiddenWord = [[NSMutableDictionary alloc] init];
    hiddenWord = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark The others
- (void)loadKeys 
{
    LOG_CURRENT_METHOD;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"keysFadeIn" object: [NSNumber numberWithBool: YES]];
}

- (void)showKeyboard 
{
    LOG_CURRENT_METHOD;
    
    // Keyboard
    lk = [[LKeyboard alloc]init];
    [self addChild:lk z:3];
    
    //IntervalAction *move = [MoveTo actionWithDuration: 1.2 position: ccp(240, adjustForUpperLeftAnchor(266.5))]; // plain

    id action = [Sequence actions: 
                 [DelayTime actionWithDuration:0.2], 
                 [MoveTo actionWithDuration:0.4 position:ccp(240, adjustForUpperLeftAnchor(255))], 
                 [CallFunc actionWithTarget:self selector:@selector(loadKeys)], 
                 nil];
    
    [bgKeyboard runAction:action];
}

- (void)hideKeyboard 
{
    LOG_CURRENT_METHOD;
    
    // Keyboard
    [self removeChild:lk cleanup:YES];
    
    id action = [Sequence actions:
                 [DelayTime actionWithDuration:0.2],
                 //[MoveTo actionWithDuration: 2 position: ccp(240, -107)], // plain
                 [MoveTo actionWithDuration:0.4 position:ccp(240, -131)],
                 nil];
    
    [bgKeyboard runAction:action];
}

#pragma mark -
#pragma mark Words
- (void)chooseRandomWord 
{
    LOG_CURRENT_METHOD;
	
    //srandom(time(NULL));
	//int randomNumber = (random() % ([wordList count] - 1)) + 1;
    
    //sdrand(time(NULL));
    //int randomNumber = ufrand(arc4random() % ([wordList count] + 1));
    int randomNumber = arc4random() % ([wordList count] - 1)+1;
    LOG(@"Random number: %d (%d)", randomNumber, ([wordList count] - 1)+1);
    
    
    NSDictionary *wordDict = [wordList objectAtIndex:randomNumber];
    [self meaning:[wordDict objectForKey:@"meaning"]];
    [self newWord:[wordDict objectForKey:@"word"]];
    [self wordToMask];
    //[wordDict objectForKey:@"audio"]
}

- (void)meaning:(NSString *)msg 
{
    LOG_CURRENT_METHOD;
        
    if(!msgLabel) {
        msgLabel = [[Label alloc] initWithString:@"" dimensions:CGSizeMake(1000, 20 + 5)
                                       alignment:UITextAlignmentCenter
                                        fontName:@"Marker Felt"
                                        fontSize: 24];
        [self addChild:msgLabel z:101];       
        [msgLabel setPosition: ccp(SCREEN_WIDTH/2, adjustForUpperLeftAnchor(170))];
        msgLabel.opacity = 0;
    }
    
    [msgLabel setVisible:YES];
    [msgLabel setString:msg];
    [msgLabel setRGB:70 :78 :92]; // depreciated v0.9 replace with -> [msgLabel setColor:ccColor3B(70,78,92)]; 
    [msgLabel runAction:[FadeIn actionWithDuration:0.8]];
}

- (void)newWord:(NSString *)word 
{
    LOG_CURRENT_METHOD;
    
    [self resetArrays];
    //int objPosition = 1;
    int objPosition = 0;
    BOOL cycle = YES;
    
    for(int i=0; i < [word length]; i++) 
    {
        // cycle through char of word
        unichar firstChar = [word characterAtIndex:i];
        NSString *singleToken = [NSString stringWithCharacters: &firstChar length:1];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        
        if(!cycle) {
            
            if([[word substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"_"]) {
                // pass
            } else if([singleToken isEqualToString:@"h"]) {
                // pass
            } else if([singleToken isEqualToString:@"g"]) {
                // pass
            } else {
                cycle = YES;
            }
        }
        
        // test for pairs
        if([singleToken isEqualToString:@"_"]) {
            
            [tempDict setObject: [word substringWithRange:NSMakeRange(i+1, 1)] forKey:@"value"];
            [tempDict setValue: [NSNumber numberWithInt:1] forKey:@"length"];
            [tempDict setValue: [NSNumber numberWithBool:YES] forKey:@"macronised"];
            [tempDict setValue: [NSNumber numberWithBool:NO] forKey:@"picked"];
            //[hiddenWord setObject: tempDict forKey: [NSNumber numberWithInt:objPosition]];
            [hiddenWord insertObject:tempDict atIndex: objPosition];
            objPosition++;
            cycle = NO;
            
        } else if([singleToken isEqualToString:@"w"]) {
            LOG(@"w");
            if([[word substringWithRange:NSMakeRange(i+1, 1)] isEqualToString:@"h"]) {
                LOG(@"wh");
                
                [tempDict setObject: @"wh" forKey:@"value"];
                [tempDict setValue: [NSNumber numberWithInt:2] forKey:@"length"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey: @"macronised"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey:@"picked"];
                //[hiddenWord setObject: tempDict forKey: [NSNumber numberWithInt:objPosition]];
                [hiddenWord insertObject:tempDict atIndex: objPosition];
                numberOfDoubleLetters++;
                objPosition++;
                cycle = NO;
            }
        } else if([singleToken isEqualToString:@"n"]) {
            
            if([[word substringWithRange:NSMakeRange(i+1, 1)] isEqualToString:@"g"]) {
                
                [tempDict setObject: @"ng" forKey:@"value"];
                [tempDict setValue: [NSNumber numberWithInt:2] forKey:@"length"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey: @"macronised"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey:@"picked"];
                //[hiddenWord setObject: tempDict forKey: [NSNumber numberWithInt:objPosition]];
                [hiddenWord insertObject:tempDict atIndex: objPosition];
                numberOfDoubleLetters++;
                objPosition++;
                cycle = NO;
            }
        } 
        
        if(cycle) {
            // test singles
            if([singleToken isEqualToString:@"."]) {
                
                [tempDict setObject: @" " forKey:@"value"];
                [tempDict setValue: [NSNumber numberWithInt:1] forKey:@"length"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey: @"macronised"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey:@"picked"];
                //[hiddenWord setObject: tempDict forKey: [NSNumber numberWithInt:objPosition]];
                [hiddenWord insertObject:tempDict atIndex: objPosition];
                objPosition++;
            } else {
                
                [tempDict setObject: singleToken forKey:@"value"];
                [tempDict setValue: [NSNumber numberWithInt:1] forKey:@"length"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey: @"macronised"];
                [tempDict setValue: [NSNumber numberWithBool:NO] forKey:@"picked"];
                //[hiddenWord setObject: tempDict forKey: [NSNumber numberWithInt:objPosition]];
                [hiddenWord insertObject:tempDict atIndex: objPosition];
                objPosition++;
            }
        }
        
        // clean
        [tempDict release];
        tempDict = nil;
    }
    //stringLength = objPosition-1;
    stringLength = objPosition;
    LOG(@"Hidden Word: %@\r\n String length: %d", hiddenWord, stringLength);
}

- (CGPoint)rowStartPoint 
{
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
    /*
     * The basics
     * # of singles
     * # of doubles
     * total length of singles
     * total length of doubles
     */
    int stringLengthAdjusted = stringLength - numberOfDoubleLetters;
    int singleMaskTotalWidth = IMAGE_WIDTH * stringLengthAdjusted; // singles
    int doubleMaskTotalWidth = (IMAGE_WIDTH * DOUBLE_LETTER) * numberOfDoubleLetters; // doubles
    
    float totalMaskWidth = singleMaskTotalWidth + doubleMaskTotalWidth;
    float totalSpaceWidth = MASK_SPACE * (stringLength - 1);
    
    /*
     * Test # of cols vs. # of characters
     */
    if(SCREEN_WIDTH / IMAGE_WIDTH > stringLengthAdjusted) {
        LOG(@"singleLine");
        
        float leftovers = SCREEN_WIDTH - (totalMaskWidth + totalSpaceWidth);
        LOG(@"leftovers: %f, mask width: %f, space width: %f", leftovers, totalMaskWidth, totalSpaceWidth);
        
        x = leftovers / 2;
        y = (320 - SCREEN_HEIGHT) + IMAGE_HEIGHT;
                
    } else if((SCREEN_WIDTH/IMAGE_WIDTH)*2 > stringLengthAdjusted) {
        LOG(@"doubleLine");

    } else if((SCREEN_WIDTH/IMAGE_WIDTH)*3 > stringLengthAdjusted) {
        LOG(@"trippleLine");
        
    } else {
        LOG(@"Too big!");
    }        
    
    return CGPointMake(x,y);
}

- (void)wordToMask 
{
    CGPoint rsp = [self rowStartPoint];
    float spriteCenterXStart = rsp.x;
    float spriteCenterX = spriteCenterXStart;
    float spriteCenterYStart = rsp.y + (IMAGE_HEIGHT / 2);
    //LOG(@"x: %f, y: %f", rsp.x, rsp.y);
    LOG(@"sprite x center: %f (start)", spriteCenterX);
    
    float maskScale;
    
    //for(int i=1; i < stringLength+1; i++) {
    for(int i=0; i < stringLength; i++) 
    {
        //NSDictionary *tempDict = [hiddenWord objectForKey:[NSNumber numberWithInt:i]];
        NSDictionary *tempDict = [hiddenWord objectAtIndex:i];
        int maskX = 0;

        LOG(@"%@ (%d)", [tempDict objectForKey:@"value"], i);
        
        if([[tempDict objectForKey:@"length"] intValue] == 2) {
            
            //if(i == 1) {
            if(i == 0) {
                
                spriteCenterX = spriteCenterX + ((IMAGE_WIDTH * DOUBLE_LETTER) / 2); // start
                maskX = spriteCenterX;
            } else {
                
                maskX = spriteCenterX;
            }
            spriteCenterX = spriteCenterX + (IMAGE_WIDTH / 2) + ((IMAGE_WIDTH * DOUBLE_LETTER) / 2) + MASK_SPACE;
            maskScale = DOUBLE_LETTER;
        } else {
            
            //if(i == 1) {
            if(i == 0) {
                
                spriteCenterX = spriteCenterX + (IMAGE_WIDTH / 2); // start
                maskX = spriteCenterX;
            } else {
                
                maskX = spriteCenterX;
            }
            spriteCenterX = spriteCenterX + IMAGE_WIDTH + MASK_SPACE;
            maskScale = 1.0;
        }

        NSString *x = [NSString stringWithFormat:@"%@", [tempDict objectForKey:@"value"]];
        if(![x isEqualToString:@" "]) {
            
            [self placeWordMask: i 
                             mX: maskX
                             mY: spriteCenterYStart
                         mScale: maskScale
            ];
            
        } else {
    
            spriteCenterX = spriteCenterX + MASK_SPACE;
        }
    }
    [self showKeyboard];
}

- (void)placeWordMask:(int)i mX:(float)x mY:(float)y mScale:(float)s 
{
    LOG(@"Mask tag + int: %d", i);
    
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];
    //Sprite *letterMask = [Sprite spriteWithFile:@"single_letter_mask.png"];
    //[self addChild:letterMask z:i tag:MASK_TAG + i];
    AtlasSprite *letterMask = [AtlasSprite spriteWithRect: CGRectMake(667,1,50,63) spriteManager: mgr];  
    [mgr addChild: letterMask z:i tag:MASK_TAG + i];
    letterMask.position = ccp(x, y);
    letterMask.scaleX=s;
    
#ifdef DEBUG
    for(AtlasSprite *item in [mgr children]) 
    { 
        LOG(@"Mask Sprite: (x)%.2f, (y)%.2f, (tag)%d", item.position.x, item.position.y, item.tag);
    }
#endif
}

- (void)guess:(NSNotification *)notification 
{
    LOG_CURRENT_METHOD;
        
    NSString *g = [self tagToString: [notification object]];
	int numberOfMatches = 0;
	
	if (![alreadyGuessed objectForKey:g]) {	
        
		[alreadyGuessed setObject:g	forKey:g];
    } 
    
	if (maxGuesses > 0) {
        
        if([self isGuessInHiddenWord: g]) {
            LOG(@"Got a match! %@", g);
            
            // add score (10+)
            
            // deactivate key (green)
            [[NSNotificationCenter defaultCenter] postNotificationName: @"keyColour" object: [NSNumber numberWithBool: YES]];
            
            if ([self isHiddenWordMatched]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName: @"closeGameBoard" object: [NSNumber numberWithBool: YES]];
            }

            numberOfMatches++;
        }
		
		if (numberOfMatches == 0) {
			maxGuesses--;
			
			// baloon animation frame 3, 2, 1?
            
            
            // deactivate key (red)
            [[NSNotificationCenter defaultCenter] postNotificationName: @"keyColour" object: [NSNumber numberWithBool: NO]];
			
			if (maxGuesses == 0) {	
                LOG(@"Bugger boo");
                
                // solve
                [self solve];
                
                // delete life
                
                // close keyboard
                [self hideKeyboard]; 
                
                // restore game state
                [[NSNotificationCenter defaultCenter] postNotificationName: @"closeGameBoard" object: [NSNumber numberWithBool: YES]];                
			}
		}
	}
}

- (BOOL)isGuessInHiddenWord:(NSString *)g 
{
    LOG_CURRENT_METHOD;
    
    int matches = 0;
    BOOL matchFound = NO;
    //for (id key in hiddenWord) {
    for(int i = 0; i < [hiddenWord count]; i++) 
    {
        //NSDictionary *tempDict = [hiddenWord objectForKey:key];
        NSDictionary *tempDict = [hiddenWord objectAtIndex:i];
        for (id nkey in tempDict ) 
        {
            NSString *hiddenWordValue = [NSString stringWithFormat:@"%@", [tempDict objectForKey:@"value"]];
            LOG(@"hidden word value: %@, guess: %@", hiddenWordValue, g);
            
            // check if macronised
            LOG(@"macrnised value: %d", [[tempDict objectForKey:@"macronised"] boolValue]);
            if([[tempDict objectForKey:@"macronised"] intValue] == 1) {
                if([g length] > 1 && [[g substringWithRange:NSMakeRange(0, 1)] isEqualToString: hiddenWordValue]) {
                    LOG(@"(macron) match found");
                    matchFound = YES;   
                }
            }  
                
            if([[tempDict objectForKey:@"macronised"] intValue] == 0) {
                if([hiddenWordValue isEqualToString: g]) {
                    LOG(@"(non macron) match found");
                    matchFound = YES;
                }
            } 
        }
        
        if(matchFound) {
            // set letter
            [self replaceMask:g mask:i];
            
            // update dict
            [tempDict setValue: [NSNumber numberWithBool:YES] forKey:@"picked"];
            matchFound = NO;
            matches++;
        }
    }
    
    LOG(@"returning match value: %d", matchFound);
    //LOG(@"HW: %@", hiddenWord);
    if(matches > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isHiddenWordMatched 
{
    LOG_CURRENT_METHOD;
    
    BOOL wordMatched = NO;
    int totalPicked = 0;
    //for (id key in hiddenWord) {
    for(int i = 0; i < [hiddenWord count]; i++) 
    {
        //NSDictionary *tempDict = [hiddenWord objectForKey:key];
        NSDictionary *tempDict = [hiddenWord objectAtIndex:i];
        
        if([[tempDict objectForKey:@"picked"] intValue] == 1) {
            
            totalPicked++;                
        }
    }
    
    LOG(@"Total Picked: %d, String Length: %d", totalPicked, stringLength);
    if(totalPicked == stringLength) {
        wordMatched = YES;
    }
    
    return wordMatched;
}

- (NSString *)tagToString:(NSNumber *)t 
{
    LOG(@"Pushed key: %@", t);
    
    // keys
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    NSEnumerator * e = [dictionary keyEnumerator];
    
    // Convert tagNumber to key string value
    id obj;
    int i = 1;
    NSString *tagStringvalue;
    while (obj = [e nextObject]) 
    {
        //LOG(@"Key: %@\nTag: %@", obj, tagNumber);
        if ([t intValue]==i) {
            LOG(@"Key: %@", obj);
            
            tagStringvalue = [NSString stringWithFormat:@"%@", obj];
        }
        i++;
    }
    
    return tagStringvalue;
}

- (void)replaceMask:(NSString *)s mask:(int)m 
{
    LOG(@"string: %@, sprite: %d", s, m);   
    
    AtlasSpriteManager *amgr = (AtlasSpriteManager*) [self getChildByTag:kMgrAssests];
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kMgrLetters];
    AtlasSprite *maskLetter;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"letters" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: plistPath];
    NSEnumerator * e = [dictionary keyEnumerator];
    
    id obj;
    int letterTag = MASK_TAG + m + 100;
    while (obj = [e nextObject]) 
    {
        LOG(@"Replace Mask: %@", [NSString stringWithFormat:@"%@", obj]);
        
        if ([s isEqualToString: [NSString stringWithFormat:@"%@", obj]]) {
            LOG(@"Key: %@", obj);
            
            NSDictionary *tempDict = [dictionary objectForKey:obj];
            CGRect letterRect = CGRectMake([[tempDict objectForKey:@"x"] intValue],
                                           [[tempDict objectForKey:@"y"] intValue],
                                           [[tempDict objectForKey:@"w"] intValue],
                                           [[tempDict objectForKey:@"h"] intValue]);
            
            float maskX = [amgr getChildByTag: MASK_TAG+m].position.x;
            float maskY = [amgr getChildByTag: MASK_TAG+m].position.y;
            LOG(@"mask x: %.2f, mask y: %.2f", maskX, maskY);
            
            maskLetter = [AtlasSprite spriteWithRect:letterRect spriteManager:mgr];
            [mgr addChild:maskLetter z:4 tag:letterTag];
            maskLetter.position = ccp(maskX, maskY);
            maskLetter.opacity = 0;
        }
    }
    
    if(replaceMaskSolve) {
        id replaceWrong = [Sequence actions: 
                           [FadeIn actionWithDuration:0.6f], 
                           [TintTo actionWithDuration:0.1 red:225 green:72 blue:7],
                           nil];
        
        [maskLetter runAction: replaceWrong];
    } else {
        [maskLetter runAction: [FadeIn actionWithDuration:0.6f]];
    }
    
#ifdef DEBUG
    for(AtlasSprite *item in [mgr children]) 
    { 
        LOG(@"Letter Sprite: (x)%.2f, (y)%.2f", item.position.x, item.position.y);
    }
#endif
}

- (void)solve 
{
    //replaceMaskSolve = YES;
    BOOL matchFound = NO;
    NSString *hiddenWordValue;
    
    for(int i = 0; i < [hiddenWord count]; i++) 
    {
        NSDictionary *tempDict = [hiddenWord objectAtIndex:i];
        for (id nkey in tempDict ) 
        {
            hiddenWordValue = [NSString stringWithFormat:@"%@", [tempDict objectForKey:@"value"]];
            
            if([[tempDict objectForKey:@"picked"] intValue] == 0) {
                    matchFound = YES;
            } 
        }
        
        if(matchFound) {
            // set letter
            [self replaceMask:hiddenWordValue mask:i];
            
            // update dict
            [tempDict setValue: [NSNumber numberWithBool:YES] forKey:@"picked"];
            matchFound = NO;
        }
    }
}

#pragma mark -
#pragma mark Lines
- (void)singleLine {}

- (void)doubleLine {}

- (void)trippleLine {}

@end