//
//  Device+Check.m
//  CommonWidget
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 drcom. All rights reserved.
//

#import "UIDevice+Check.h"

@implementation UIDevice(Check)
+ (BOOL)canDail {
    UIDevice *device = [UIDevice currentDevice];
    NSString *devicetype = device.model;
    if([devicetype isEqualToString:@"iPhone"]){
        return YES;
    }
    return NO;
}
@end
