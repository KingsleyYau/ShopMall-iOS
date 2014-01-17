//
//  UIAlertViewCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 12-12-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UIAlertViewCustom.h"
@implementation UIAlertView (Custom)
+ (void)showAlertMessage:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle {
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil] autorelease];
    [alertView show];
}
@end
