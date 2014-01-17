//
//  KKLoadingView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-24.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ResourceManager.h"
#import "KKLoadingView.h"

@interface KKLoadingView() {
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_labelLoading;
    UIButton *_buttonCancel;
}
@end
@implementation KKLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        self.layer.cornerRadius = 5;
        CGRect selfFrame = CGRectMake(0, 0, 200, 100);
        self.frame = selfFrame;

        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
        _activityIndicatorView.center = CGPointMake(20, self.center.y);
        
        _labelLoading = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
        _labelLoading.center = self.center;
        [self addSubview:_labelLoading];
        _labelLoading.backgroundColor = [UIColor clearColor];
        _labelLoading.text = @"正在加载...";
        _labelLoading.textColor = [UIColor whiteColor];
        
        _buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonCancel];
//        [_buttonCancel setBackgroundImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DrPalmCancelButtonImage]] forState:UIControlStateNormal];
        [_buttonCancel sizeToFit];
        [_buttonCancel addTarget:self action:@selector(buttonCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCancel.center = CGPointMake(self.frame.size.width - 30, self.center.y);
        
    }
    return self;
}
- (void)startLoadingInView:(UIView *)view {
    if(view.superview == view)
        return;
    [self removeFromSuperview];
    for (UIView *subView in view.subviews) {
        subView.userInteractionEnabled = NO;
    }
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.center = view.center;
}
- (void)cancelLoading {
    for (UIView *subView in self.superview.subviews) {
        subView.userInteractionEnabled = YES;
    }
    [self removeFromSuperview];
}
- (void)buttonCancelAction:(id)sender {
    [self cancelLoading];
    if([self.delegate respondsToSelector:@selector(didCancelLoading:)]) {
        [self.delegate didCancelLoading:self];
    }
}
@end
