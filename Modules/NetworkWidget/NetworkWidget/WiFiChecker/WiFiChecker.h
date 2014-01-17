//
//  WiFiChecker.h
//  DrPalm
//
//  Created by KingsleyYau_lion on 12-2-10.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WiFiChecker : NSObject
+ (BOOL)isWiFiEnable;
+ (BOOL)isNetWorkOK;
+ (NSString*)currentSSID;
+ (void)showNetworkError;
@end
