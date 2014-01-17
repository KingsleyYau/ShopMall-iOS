//
//  MYUIStatusBar.h
//  testAttachment
//
//  Created by fgx_lion on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MYUIStatusBar : NSObject{
    NSMutableArray  *_messages;
    UIWindow    *_statusWindow;
    UILabel *_messageLabel;
    NSTimer *_timer;
    BOOL    _show;
}
- (void)showMessage:(NSString*)message;

// 是否显示的总开关
- (void)show;
- (void)hide;
@end
