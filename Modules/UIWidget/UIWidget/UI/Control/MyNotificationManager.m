//
//  MyNotificationManager.m
//  UIWidget
//
//  Created by JiangBo on 13-8-22.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import "MyNotificationManager.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"


#define X_BLANKING  10
#define Y_BLANKING  5

#define X_BLANKING_NOTIFYVIEW  60

#define DELAY_TIME 3.0f

@implementation MyNotificationManager

+(MyNotificationManager *)sharedManager
{
    static MyNotificationManager *instance = nil;
    if(instance == nil) {
        instance = [[MyNotificationManager alloc] init];
    }
    return instance;
}

-(id)init
{
    if( (self = [super init]) ) {
        
        // Setup the array
        notificationQueue = [[NSMutableArray alloc] init];
        
        // Set not showing by default
        showingNotification = NO;
    }
    return self;
}

-(void)dealloc
{
    [notificationQueue release];
    
    [super dealloc];
}

#pragma messages
+(void)notificationWithMessage:(NSString *)message
{
    // Show the notification
    [[MyNotificationManager sharedManager] addNotificationViewWithMessage:message];
}

-(void)addNotificationViewWithMessage:(NSString *)message
{
    // Grab the main window
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    // Grab the background image for calculations
    UIImage *bgImage = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:Notification_BackGround]];
    
    // Create the notification view (here you could just call another UIVirew subclass)
    NSInteger notifyViewWidth = window.frame.size.width-2*X_BLANKING_NOTIFYVIEW;
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(X_BLANKING_NOTIFYVIEW, -bgImage.size.height, notifyViewWidth, bgImage.size.height)];
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    // Add an image background
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, notifyViewWidth, bgImage.size.height)];
    [bgImageView setImage:bgImage];
    [notificationView addSubview:bgImageView];
    [bgImageView release];
    
    // Add some text label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X_BLANKING , Y_BLANKING, notifyViewWidth - 2*(X_BLANKING) , notificationView.frame.size.height)];
    [label setText:message];
    [label setFont:[UIFont systemFontOfSize:17.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [notificationView addSubview:label];
    [label release];
    
    // Add to the window
    [window addSubview:notificationView];
    [notificationQueue addObject:notificationView];
    [notificationView release];
    
    // Should we show this notification view
    if(!showingNotification) {
        [self showNotificationView:notificationView];
    }
}

-(void)showNotificationView:(UIView *)notificationView
{
    // Set showing the notification
    showingNotification = YES;
    
    // Animate the view downwards
    [UIView beginAnimations:@"" context:nil];
    
    // Setup a callback for the animation ended
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNotificationAnimationComplete:finished:context:)];
    
    [UIView setAnimationDuration:0.5f];
    
    [notificationView setFrame:CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y+notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height)];
    
    [UIView commitAnimations];
}

-(void)showNotificationAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    // Hide the notification after a set second delay
    [self performSelector:@selector(hideCurrentNotification) withObject:nil afterDelay:DELAY_TIME];
}

-(void)hideCurrentNotification
{
    // Get the current view
    UIView *notificationView = [notificationQueue objectAtIndex:0];
    
    // Animate the view downwards
    [UIView beginAnimations:@"" context:nil];
    
    // Setup a callback for the animation ended
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideNotificationAnimationComplete:finished:context:)];
    
    [UIView setAnimationDuration:0.5f];
    
    [notificationView setFrame:CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y-notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height)];
    
    [UIView commitAnimations];
}

-(void)hideNotificationAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    // Remove the old one
    UIView *notificationView = [notificationQueue objectAtIndex:0];
    [notificationView removeFromSuperview];
    [notificationQueue removeObject:notificationView];
    
    // Set not showing
    showingNotification = NO;
    
    // Do we have to add anymore items - if so show them
    if([notificationQueue count] > 0) {
        UIView *v = [notificationQueue objectAtIndex:0];
        [self showNotificationView:v];
    }
}

@end