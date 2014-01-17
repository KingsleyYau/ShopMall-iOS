//
//  CustomNavigationBar.m
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "CustomNavigationBar.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"

#define TAG_KKBACKGROUND_VIEW 100001
@implementation  UINavigationBar(Custom)
-(void)setDefaultBackgroundImage {
    NSString *imagePath = [ResourceManager resourceFilePath:NavigationBarBackground];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
    double sysVer = [crrSysVer doubleValue];
    
    if (sysVer >= 5)
    {
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *kkBackgroundView = (UIImageView *)[self viewWithTag:TAG_KKBACKGROUND_VIEW];
        if(!kkBackgroundView) {
            UIImageView *kkBackgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];
            kkBackgroundView.tag = TAG_KKBACKGROUND_VIEW;
            kkBackgroundView.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:kkBackgroundView];
        }
        [kkBackgroundView setImage:image];
//        [self setNeedsLayout];
    }
}

-(void) drawRect:(CGRect)rect {
//    NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
//    double sysVer = [crrSysVer doubleValue];
//    if (sysVer < 5){
//        UIImage* image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:NavigationBarBackground]];
//        if (nil != image) {
//            [image drawInRect:rect];
//        }
//    }
}

- (void)setDefaultBackgroundImage:(UIImage *)image {
    NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
    double sysVer = [crrSysVer doubleValue];
    if (sysVer >= 5){
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
//    double sysVer = [crrSysVer doubleValue];
//    if (sysVer < 5) {
//        UIImageView *kkBackgroundView = (UIImageView *)[self viewWithTag:TAG_KKBACKGROUND_VIEW];
//        if(kkBackgroundView) {
//            [self sendSubviewToBack:kkBackgroundView];
//        }
//        self.topItem.titleView.center = CGPointMake(self.center.x, self.frame.size.height / 2);
//    }
//}
@end