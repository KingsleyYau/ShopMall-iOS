//
//  KKTabBar.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-19.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKTabBar.h"
@interface KKTabBar () {
    
}
@property (nonatomic, retain) UIImage *kkbackgroundImage;
@property (nonatomic, assign) UIImageView *kkbackgroundImageView;
@end

@implementation KKTabBar
@synthesize kkbackgroundImage = _kkbackgroundImage;
@synthesize kkbackgroundImageView = _kkbackgroundImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _kkbackgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_kkbackgroundImageView];
        [_kkbackgroundImageView release];
        [self sendSubviewToBack:_kkbackgroundImageView];
    }
    return self;
}
- (void)dealloc{
    self.kkbackgroundImage = nil;
    _kkbackgroundImageView = nil;
    [super dealloc];
}
- (void)setCustomBackgroundImage:(UIImage *)backgroundImage {
    //self.kkbackgroundImage = backgroundImage;
    [_kkbackgroundImageView setImage:backgroundImage];
    UIView *kkView = [self valueForKey:@"_backgroundView"];
    if(kkView) {
        [kkView removeFromSuperview];
    }
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
