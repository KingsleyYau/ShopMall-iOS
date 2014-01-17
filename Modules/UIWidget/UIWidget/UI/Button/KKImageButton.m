//
//  KKButton.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-26.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKImageButton.h"

@implementation KKImageButton
@synthesize kkImage = _kkImage;
@synthesize kkSelectedImage = _kkSelectedImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)dealloc {
    self.kkImage = nil;
    self.kkSelectedImage = nil;
    [super dealloc];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
        [self setBackgroundImage:self.kkSelectedImage forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:self.kkImage forState:UIControlStateNormal];
    }
}
- (void)setNeedSelectAction:(BOOL)needSelectAction {
    if(needSelectAction) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark － 界面（Action）
- (void)buttonAction:(id)sender {
    self.selected = !self.selected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
