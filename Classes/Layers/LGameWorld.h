//
//  LGameWorld.h
//  intothefire
//
//  Created by mtt on 2/07/09.
//  Copyright 2009 Make Things Talk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CEnums.h"
#import "Tui.h"
#import "LHangman.h"


@interface LGameWorld : Layer <TargetedTouchDelegate> {

    LHangman *gb;
    Tui *tui;
}

- (void)addPuzzle:(AtlasSpriteManager *)baseMgr;
- (void)addQuestion:(AtlasSpriteManager *)baseMgr;
- (void)addPlus:(AtlasSpriteManager *)baseMgr;
- (void)addReturn:(AtlasSpriteManager *)baseMgr;
- (void)addSpeech:(AtlasSpriteManager *)baseMgr;

- (void)loadLevelFile;
- (void)setupGameBoard;
- (void)setupRandomWord;
- (void)releaseGameBoard;
- (void)closeKeyboard;

@end
