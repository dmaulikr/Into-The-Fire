//
//	Created by mtt on 22/06/09
//
//	Project: intothefire
//	File: LGameBoard.h
//
//	Last modified: 22/06/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CEnums.h"
#import "LKeyboard.h"


@interface LHangman : Layer {
    
    int stringLength;
    int numberOfDoubleLetters;
    int startX;
    int startY;
    
    int maxGuesses;
    int numberOfWrongGuesses;
    NSArray *wordList;
    NSMutableDictionary *alreadyGuessed;
    //NSMutableDictionary *hiddenWord;
    NSMutableArray *hiddenWord;
    
    NSString *wordToGuess;
    
    AtlasSprite *bgKeyboard;
    
    LKeyboard *lk;
    Label * msgLabel;
    BOOL replaceMaskSolve;
}

//@property (nonatomic, retain)AtlasSprite *bgKeyboard;

//- (void)gameBoardTexture:(Texture2D *)tex;
- (void)loadLevelWordList:(NSString *)level guesses:(int)maximumNumberOfGuesses;
- (void)resetArrays;

- (void)loadKeys;
- (void)showKeyboard;
- (void)hideKeyboard;

- (void)chooseRandomWord;
- (void)meaning:(NSString *)msg;
- (void)newWord:(NSString *)wordToGuess;
- (CGPoint)rowStartPoint;
- (void)wordToMask;
- (void)placeWordMask:(int)i mX:(float)x mY:(float)y mScale:(float)s;
- (void)guess:(NSNotification *)notification;
- (BOOL)isGuessInHiddenWord:(NSString *)g;
- (BOOL)isHiddenWordMatched;
- (NSString *)tagToString:(NSNumber *)t;
- (void)replaceMask:(NSString *)s mask:(int)m;
- (void)solve;


@end