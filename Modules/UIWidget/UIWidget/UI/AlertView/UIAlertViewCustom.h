//
//  UIAlertViewCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 12-12-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIAlertView (Custom)
+ (void)showAlertMessage:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle;
@end
