//
//  KKSearchBar.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-21.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSearchBar : UISearchBar {
    UIImageView *_kkbackgroundImageView;
    UIImageView *_kkCancelButtonBackgroundView;
}
@property (nonatomic, readonly) UIImageView *kkbackgroundImageView;
- (void)setBackgroundImage:(UIImage *)backgroundImage;
- (void)setCancelBackgroundImage:(UIImage *)cancelButtonBackgroundImage;
@end
