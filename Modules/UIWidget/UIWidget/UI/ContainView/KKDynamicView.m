//
//  KKDynamicButton.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-1.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKDynamicView.h"
@interface KKDynamicView () {
    UIControl *_overlay;
    BOOL _isDown;
    BOOL _isClose;
    BOOL _isShowOverlay;
    CGRect _detailFrame;
}
@property (nonatomic, retain) UIView *detailView;
@end
@implementation KKDynamicView
@synthesize delegate;
@synthesize detailView;
@synthesize isShowOverlay = _isShowOverlay;
@synthesize isDown = _isDown;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isShowOverlay = YES;
        
        _overlay = [[[UIControl alloc] initWithFrame:frame] autorelease];
        _overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [_overlay addTarget:self action:@selector(overlayTapped:) forControlEvents:UIControlEventTouchDown];
        _overlay.alpha = 0.0;
        [self addSubview:_overlay];
    }
    return self;
}
- (void)dealloc {
    self.delegate = nil;

    self.detailView = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame isDown:(BOOL)Down {
    self = [super initWithFrame:frame];
    if (self) {
        _isClose = YES;
        _isDown = Down;
        _detailFrame = CGRectZero;
        
        _overlay = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        _overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [_overlay addTarget:self action:@selector(overlayTapped:) forControlEvents:UIControlEventTouchDown];
        _overlay.alpha = 0.0;
        [self addSubview:_overlay];
        [self sendSubviewToBack:_overlay];
    }
    return self;
}
- (void)reLoadView {
    // 详细界面
    if([self.delegate respondsToSelector:@selector(viewForDetail:)]){
        [self.detailView removeFromSuperview];
        self.detailView = [self.delegate viewForDetail:self];
        if(self.detailView) {
            _detailFrame = detailView.frame;
            if(_isDown) {
                // 向下展开
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, - (_detailFrame.origin.y + self.detailView.frame.size.height), self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            else {
                // 向上展开
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            [self.detailView removeFromSuperview];
            [self addSubview:detailView];
            //[self sendSubviewToBack:detailView];
            self.detailView.hidden = YES;
            // 原先已经打开
            if(!_isClose) {
                [self show:NO];
            }
        }
    }
    
}
#pragma mark － 收起
- (void)hide:(BOOL)animated{
    if(_isClose)
        return;
    _isClose = YES;
    if(!self.detailView) {
        return;
    }
    CGFloat duration = 0.0;
    // 是否显示动画
    if(animated) {
        duration = 0.3;
        [UIView animateWithDuration:duration animations:^{
            //动画的内容
            if(_isDown) {
                // 向上收起
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, - (_detailFrame.origin.y + self.detailView.frame.size.height), self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            else {
                // 向下收起
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            _overlay.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            //动画结束
            detailView.hidden = YES;
        }];
    }
    else {
        //动画的内容
        if(_isDown) {
            // 向上收起
            self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, -(_detailFrame.origin.y +  self.detailView.frame.size.height), self.detailView.frame.size.width, self.detailView.frame.size.height);
        }
        else {
            // 向下收起
            self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
        }
        self.detailView.hidden = YES;
        _overlay.alpha = 0.0;
    }
    if([self.delegate respondsToSelector:@selector(didHideDynamicContainView:boundsSize:duration:)]) {
        [self.delegate didHideDynamicContainView:self boundsSize:CGSizeMake(self.detailView.frame.size.width, self.detailView.frame.size.height) duration:duration];
    }
}
- (void)show:(BOOL)animated{
    if(!_isClose)
        return;
    _isClose = NO;
    // 详细界面
    if(detailView) {
    }
    else {
        // 没有详细直接返回
        return;
    }
    CGFloat duration = 0.0;
    // 是否显示动画
    detailView.hidden = NO;
    if(animated) {
        duration = 0.3;
        [UIView animateWithDuration:duration animations:^{
            //动画的内容
            if(_isDown) {
                // 向下展开
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, _detailFrame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            else {
                // 向上展开
                self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.frame.size.height - self.detailView.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            _overlay.alpha = 1.0;
        } completion:^(BOOL finished) {
            //动画结束
        }];
    }
    else {
        if(_isDown) {
            // 向下展开
            self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, _detailFrame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
        }
        else {
            // 向上展开
            self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.frame.size.height - self.detailView.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
        }
        _overlay.alpha = 1.0;
    }
    if([self.delegate respondsToSelector:@selector(didShowDynamicContainView:boundsSize:duration:)]) {
        [self.delegate didShowDynamicContainView:self boundsSize:CGSizeMake(self.detailView.frame.size.width, self.detailView.frame.size.height) duration:duration];
    }
}
- (void)overlayTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTouchOverlayContainView:)]) {
        [self.delegate didTouchOverlayContainView:self];
    }
    [self hide:YES];
}
- (void)setIsShowOverlay:(BOOL)isShowOverlay {
    if(isShowOverlay) {
        _overlay.hidden = NO;
    }
    else {
        _overlay.hidden = YES;
    }
    _isShowOverlay = isShowOverlay;
}
@end
