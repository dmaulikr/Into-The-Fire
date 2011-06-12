//
//	Created by Cleave Pokotea on 25/02/09
//
//	Project: STM007
//	File: GameScene.h
//
//	Last modified: 25/02/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CEnums.h"
#import "LScrollingBkgnd.h"
#import "LayerCamera.h"


@interface SGame : Scene {
    
    LScrollingBkgnd *sb;
    LayerCamera *gameCamera;
}

// required to scroll the whatsomecallit
- (void)changePosition:(float)f;

@end

