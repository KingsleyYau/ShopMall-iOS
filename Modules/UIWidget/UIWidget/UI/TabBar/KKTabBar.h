//
//  KKTabBar.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-19.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTabBarItem.h"
@interface KKTabBar : UITabBar {
    UIImage      *_kkbackgroundImage;
    UIImageView *_kkbackgroundImageView;
}
- (void)setCustomBackgroundImage:(UIImage *)backgroundImage;
@end
