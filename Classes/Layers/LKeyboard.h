//
//	Created by mtt on 21/06/09
//
//	Project: intothefire
//	File: Keyboard.h
//
//	Last modified: 21/06/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CEnums.h"


@interface LKeyboard : Layer <TargetedTouchDelegate> {
@private
    KeyState state;
    int keyTag;
    
    Sprite *bgKeyboard;
    
    NSMutableArray *aDeactivatedKeys;
}

//@property (nonatomic, retain)AtlasSpriteManager *keyMgr;
@property (readonly) NSMutableArray *aDeactivatedKeys;

- (void)addKey:(int)kTag
             x:(int)x 
             y:(int)y 
             w:(int)w 
             h:(int)h 
            pX:(int)pX 
            pY:(int)pY;
- (void)fadeInKeys;
- (void)deactivateKey:(NSNotification *)notification;

- (void)setKeyTouchState:(KeyState)s;
- (KeyState)keyTouchState;
- (void)setKeyTagNumber:(int)i;
- (int)keyTagNumber;

@end