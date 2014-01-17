//
//  Device+Check.h
//  CommonWidget
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 drcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface UIDevice(Check)
+ (BOOL)canDail;
@end
