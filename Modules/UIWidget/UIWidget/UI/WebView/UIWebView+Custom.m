//
//  UIWebView+Custom.m
//  UIWidget
//
//  Created by KingsleyYau on 13-7-18.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import "UIWebView+Custom.h"

@implementation UIWebView(Custom)
- (UIScrollView *)subScrollView {
    NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
    double sysVer = [crrSysVer doubleValue];
    if (sysVer >= 5){
        return self.scrollView;
    }
    else {
        return (UIScrollView *)[[self subviews] objectAtIndex:0];
    }
}
- (void)setCanBounces:(BOOL)canBounces {
    [(UIScrollView *)[[self subviews] objectAtIndex:0] setBounces:NO];
}
- (BOOL)canBounces {
    return [(UIScrollView *)[[self subviews] objectAtIndex:0] bounces];
}
@end
