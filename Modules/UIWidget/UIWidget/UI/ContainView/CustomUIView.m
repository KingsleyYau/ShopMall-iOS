//
//  CustomUIView.m
//  DrPalm
//
//  Created by drcom on 12-8-3.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//
#import "CustomUIView.h"

@implementation UIView (Custom)
- (void)removeAllSubviews{
    NSArray *subViews = self.subviews;
    for(UIView *view in subViews){
        [view removeFromSuperview];
    }
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if(![self isExclusiveTouch])
//        [self resignFirstResponder];
//}
@end
