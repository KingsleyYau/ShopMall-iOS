//
//  WiFiChecker.m
//  DrPalm
//
//  Created by KingsleyYau_lion on 12-2-10.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#import "WiFiChecker.h"
#import "Reachability.h"
#import "LanguageDef.h"
//#import "CommonLanguageDef.h"
@implementation WiFiChecker
+ (BOOL)isWiFiEnable
{
    Reachability *reach = [Reachability sharedReachability];
    NetworkStatus status = [reach localWiFiConnectionStatus];
    return ReachableViaWiFiNetwork == status;
}
+ (BOOL)isNetWorkOK {
    Reachability *reach = [Reachability sharedReachability];
    NetworkStatus status = [reach internetConnectionStatus];
    return (NotReachable != status);
}
+ (NSString*)currentSSID
{
    Reachability *reach = [Reachability sharedReachability];
    return [reach currentSSID];
}
+ (void)showNetworkError {
    // 弹出提示
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:ToLocalizedString(@"NetWorkErrorTitle") message:ToLocalizedString(@"NetWorkError") delegate:self cancelButtonTitle:ToLocalizedString(@"MessageOK") otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
