//
//  KKTabBarItem.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTabBarItem : UITabBarItem {
    UIImage      *_kkimage;
    UIImage      *_kkselectedImage;
    UIImage      *_kkbackgroundImage;
    NSInteger    _badgeNum;
}
@property (nonatomic, retain) UIImage *kkimage;
@property (nonatomic, retain) UIImage *kkselectedImage;
@property (nonatomic, retain) UIImage *kkbackgroundImage;

@property (nonatomic, assign) BOOL isHighLight;
@property (nonatomic, assign) BOOL isFullItemImage;
@property (nonatomic, readwrite) NSInteger badgeNum;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage tag:(NSInteger)tag;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage backgroundImage:(UIImage *)backgroundImage tag:(NSInteger)tag;
- (void)setSelected:(BOOL)isSelected;
@end
