//
//  ActionSheetCustom.m
//  UIWidget
//
//  Created by KingsleyYau on 13-4-18.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import "ActionSheetCustom.h"

@implementation UIActionSheet (Custom)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGRect pFrame = self.superview.frame;
    if(frame.size.height > 0) {
        self.frame = CGRectMake(0, pFrame.size.height - frame.size.height, self.frame.size.width, self.frame.size.height);
    }
}
@end
