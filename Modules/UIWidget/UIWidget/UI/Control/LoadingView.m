//
//  LoadingView.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-26.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicatorView;
-(void)animationDidStop;
@end

@implementation LoadingView
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.activityIndicatorView = nil;
        _isShowLoading = NO;
    }
    return self;
}

- (void)dealloc
{
    self.activityIndicatorView = nil;
    [super dealloc];
}

-(void)showLoading:(UIView*)parent animated:(BOOL)animated
{
    if (!_isShowLoading){
        self.frame = parent.bounds;
        self.backgroundColor = [UIColor blackColor];
        if (nil == self.activityIndicatorView){
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [activityView startAnimating];
            activityView.center = self.center;
            [self addSubview:activityView];
            self.activityIndicatorView = activityView;
            [activityView release];
        }
        [parent addSubview:self];
        [parent bringSubviewToFront:self];
        
        if (animated){
            self.alpha = 0.0f;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.alpha = 0.80f;
            [UIView commitAnimations];
        }
        else{
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        }
        
        _isShowLoading = YES;
    }
}

-(void)hideLoading:(BOOL)animated
{
    if (_isShowLoading){
        if (animated){
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.alpha = 0.00f;
            [UIView commitAnimations];
        }
        else{
            [self.activityIndicatorView stopAnimating];
            [self.activityIndicatorView removeFromSuperview];
            self.activityIndicatorView = nil;
            [self removeFromSuperview];
        }
        _isShowLoading = NO;
    }
}

-(void)animationDidStop
{
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
    self.activityIndicatorView = nil;
    [self removeFromSuperview];
}

@end
