//
//	Created by mtt on 2/07/09
//
//	Project: intothefire
//	File: LScrollingBkgnd.h
//
//	Last modified: 2/07/09
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface LScrollingBkgnd : Layer {
    
    float x;
}

- (id)initWithTex:(Texture2D *)tex;
- (void)update:(ccTime)dt;

@end