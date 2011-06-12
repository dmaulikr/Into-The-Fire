//
//  intothefireAppDelegate.h
//  intothefire
//
//  Created by mtt on 28/05/09.
//  Copyright Make Things Talk 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocoslive.h"
#import "cocos2d.h"


enum {
    kSplash = 0,
	kSceneMenu,         // Main Menu Scene
    kSceneGame,         // Game Scene
    kSceneInfo,         // Info Score
    kSceneScore,        // High scores
    kSceneEnd,
	kSceneCount			// Total count of scenes.  Not used in this example but good to have
};


@interface intothefireAppDelegate : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIApplicationDelegate> {
    
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;



// scenes
- (Scene *)loadScene:(NSInteger)sceneId;



@end
