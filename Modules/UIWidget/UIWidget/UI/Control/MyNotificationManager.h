//
//  MyNotificationManager.h
//  UIWidget
//
//  Created by JiangBo on 13-8-22.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MyNotificationManager : NSObject {
    
@private
    // The notificatin views array
    NSMutableArray *notificationQueue;
    
    // Are we showing a notification
    BOOL showingNotification;
}

+(MyNotificationManager *)sharedManager;

+(void)notificationWithMessage:(NSString *)message;

-(void)addNotificationViewWithMessage:(NSString *)message;
-(void)showNotificationView:(UIView *)notificationView;

@end
