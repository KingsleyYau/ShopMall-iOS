//
//  MYUIStatusBar.m
//  testAttachment
//
//  Created by fgx_lion on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MYUIStatusBar.h"

#define DISMISS_TIME 3.0f

@interface MYUIStatusBar()
@property (nonatomic, retain) UIWindow  *statusWindow;
@property (nonatomic, retain) UILabel   *messageLabel;
@property (retain) NSMutableArray   *messages;
@property (retain) NSTimer          *timer;

- (void)moveMessageOut:(BOOL)delay;
- (void)moveMessageIn;
- (void)animationDidStop:(NSString *)animationID;
- (void)changeMessage:(NSTimer*)theTimer;

- (void)showMyStatusBar;
- (void)hideMyStatusBar;
@end

@implementation MYUIStatusBar
@synthesize statusWindow = _statusWindow;
@synthesize messageLabel = _messageLabel;
@synthesize messages = _messages;
@synthesize timer = _timer;

- (id)init
{
    self = [super init];
    if (nil != self){
        UIApplication *application = [UIApplication sharedApplication];
        CGRect frame = application.statusBarFrame;
        self.statusWindow = [[[UIWindow alloc] initWithFrame:frame] autorelease];
        self.statusWindow.windowLevel = UIWindowLevelStatusBar;
        self.statusWindow.backgroundColor = [UIColor blackColor];
        self.messageLabel = [[[UILabel alloc] initWithFrame:_statusWindow.bounds] autorelease];
        self.messageLabel.backgroundColor = [UIColor blackColor];
        self.messageLabel.textAlignment = UITextAlignmentCenter;
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self moveMessageOut:NO];
        [self.statusWindow addSubview:self.messageLabel];
        self.timer = nil;
        self.messages = [NSMutableArray array];
        _show = YES;
    }
    return self;
}

- (void)dealloc
{
    self.timer = nil;
    self.statusWindow = nil;
    self.messageLabel = nil;
    self.messages = nil;
    [super dealloc];
}

- (void)showMessage:(NSString*)message
{
    @synchronized(self) {
        [self showMyStatusBar];
        [self.messages addObject:message];
        if ([self.messageLabel.text length] > 0){
            [self moveMessageOut:YES];
        }
        else {
            [self moveMessageIn];
        }
    }
}

- (void)show
{
    @synchronized(self){
        _show = YES;
    }
}

- (void)hide
{
    @synchronized(self){
        _show = NO;
        self.statusWindow.hidden = YES;
    }
}

- (void)showMyStatusBar
{
    @synchronized(self){
        if (_show){
            self.statusWindow.hidden = NO;
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
    }
}

- (void)hideMyStatusBar
{
    @synchronized(self){
        if (_show){
            _messageLabel.text = nil;
            self.statusWindow.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
}

#pragma mark - Animations
#define MoveOut @"MoveOut"
#define MoveIn  @"MoveIn"
-(void)moveMessageIn
{
    _messageLabel.text = [self.messages objectAtIndex:0];
    [self.messages removeObject:_messageLabel.text];
    
    [UIView beginAnimations:MoveIn context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _messageLabel.center = _statusWindow.center;
    _messageLabel.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)moveMessageOut:(BOOL)delay
{
    [UIView beginAnimations:MoveOut context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
    [UIView setAnimationDelay:(delay ? 0.0f : 0.0f)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _messageLabel.center = CGPointMake(_messageLabel.center.x, 0.0 - _messageLabel.bounds.size.height/2.0f);
    _messageLabel.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID
{
    if ([animationID isEqualToString:MoveOut]){
        if ([self.messages count] > 0){
            [self moveMessageIn];
        }
        else {
            [self hideMyStatusBar];
        }
    }
    else if ([animationID isEqualToString:MoveIn]){
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:DISMISS_TIME target:self selector:@selector(changeMessage:) userInfo:nil repeats:NO];
    }
}

-(void)changeMessage:(NSTimer*)theTimer
{	
    [self moveMessageOut:NO];
}
@end
