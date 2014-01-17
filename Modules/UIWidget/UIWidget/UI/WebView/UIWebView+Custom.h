//
//  UIWebView+Custom.h
//  UIWidget
//
//  Created by KingsleyYau on 13-7-18.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIWebView(Custom)
- (UIScrollView *)subScrollView;
- (void)setCanBounces:(BOOL)canBounces;
- (BOOL)canBounces;
@end
