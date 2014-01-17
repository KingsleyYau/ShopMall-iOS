//
//  KKTabBarItem.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKTabBarItem.h"
#import "ResourceManager.h"
#import "BadgeImageView.h"
#define IMAGE_VIEW_TAG 1001
#define BACKGROUND_VIEW_TAG 1002
@interface KKTabBarItem() {
    
}

//- (UIImage *)defaultBackgroundImage;
@end

@implementation KKTabBarItem
@synthesize isHighLight;
@synthesize isFullItemImage;
@synthesize kkimage = _kkimage;
@synthesize kkselectedImage = _kkselectedImage;
@synthesize kkbackgroundImage = _kkbackgroundImage;
@synthesize badgeNum = _badgeNum;
- (void)dealloc{
    self.kkimage = nil;
    self.kkselectedImage = nil;
    self.kkbackgroundImage = nil;
    [super dealloc];
}
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    if(self = [super initWithTitle:title image:image tag:tag]) {
        self.isHighLight = NO;
        self.isFullItemImage = NO;
        self.kkimage = image;
        self.badgeNum = 0;
    }
    return self;
}
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage tag:(NSInteger)tag {
    if(self = [super initWithTitle:title image:image tag:tag]) {
        self.isHighLight = NO;
        self.isFullItemImage = NO;
        self.kkimage = image;
        self.kkselectedImage = selectImage;
        self.badgeNum = 0;
    }
    return self;
}
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage backgroundImage:(UIImage *)backgroundImage tag:(NSInteger)tag {
    if(self = [super initWithTitle:title image:image tag:tag]) {
        self.isHighLight = NO;
        self.isFullItemImage = NO;
        self.kkimage = image;
        self.kkselectedImage = selectImage;
        self.kkbackgroundImage = backgroundImage;
        self.badgeNum = 0;
    }
    return self;
}
-(void)setSelected:(BOOL)isSelected {
    UIView *kkView = [self valueForKey:@"_view"];
    for(UIView *view in kkView.subviews) {
        if(![view isKindOfClass:[UILabel class]]) {
            //UIImageView *imageView = (UIImageView *)view;
            if([NSStringFromClass([view class]) isEqualToString:@"UITabBarSelectionIndicatorView"]) {
                // 是否显示高亮view
                [view setHidden:!self.isHighLight];
            }else {
                // 用自定义的imageView替换原来的
                [view removeFromSuperview];
                BadgeImageView* newImageView = nil;
                //UIImageView *newImageView = nil;
                if(!isFullItemImage) {
                    //
                    newImageView = [[[BadgeImageView alloc] initWithFrame:view.frame] autorelease];
                    //newImageView = [[[UIImageView alloc] initWithFrame:view.frame] autorelease];
                }
                else {
                    newImageView = [[[BadgeImageView alloc] initWithFrame:kkView.frame] autorelease];
                    //newImageView = [[[UIImageView alloc] initWithFrame:kkView.frame] autorelease];
                }
                [kkView addSubview:newImageView];
                newImageView.tag = IMAGE_VIEW_TAG;
                // 调整位置
                newImageView.contentMode = UIViewContentModeBottom;
                newImageView.center = CGPointMake(kkView.frame.size.width / 2, newImageView.frame.size.height / 2);
                if(self.badgeNum > 0)
                {
                    [newImageView setBadgeValue:[NSString stringWithFormat:@"%d",self.badgeNum]];
                }
                // 根据选中状态调整图片
                // 先选中普通图片
                [newImageView setImage:self.kkimage];
                if(isSelected && self.kkselectedImage) {
                    // 选中时候切换
                    [newImageView setImage:self.kkselectedImage];
                }
            }
        }
    }
}

//- (UIImage *)defaultBackgroundImage {
//    UIImage *image = nil;
//    UIImage *orgImage = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DrPalmImageNameTabBarBackground]];
//    if(orgImage) {
//        image = [orgImage stretchableImageWithLeftCapWidth:2 topCapHeight:0];
//    }
//    return image;
//}
@end
