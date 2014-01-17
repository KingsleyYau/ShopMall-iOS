//
//  KKToolBar.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-6.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKToolBar : UIToolbar {
    UIImage      *_kkbackgroundImage;
    UIImageView *_kkbackgroundImageView;
}
- (void)setCustomBackgroundImage:(UIImage *)backgroundImage;
@end
