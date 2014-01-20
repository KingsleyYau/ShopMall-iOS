//
//  AppEnviroment.h
//  DrPalm
//
//  Created by jiangbo on 2/3/12.
//  Copyright (c) 2012 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalUIEntitlement.h"
#import "CalendarEntitlement.h"
#import "ClientEntitlement.h"
#import "ShareEntitlement.h"

@interface AppEnviroment : NSObject
{
    ClientEntitlement*      _clientEntitlement;
    GlobalUIEntitlement*    _globalUIEntitlement;
    CalendarEntitlement*    _calendarEntitlement;
    ShareEntitlement*       _shareEntitlement;
    BOOL    _showAboutInSetting;
    NSString    *_applyUrl;
}
@property (nonatomic, retain) ClientEntitlement*    clientEntitlement;
@property (nonatomic, retain) GlobalUIEntitlement*  globalUIEntitlement;
@property (nonatomic, retain) CalendarEntitlement*  calendarEntitlement;
@property (nonatomic, retain) ShareEntitlement*     shareEntitlement;
@property (nonatomic, assign) BOOL  showAboutInSetting;
@property (nonatomic, retain) NSString  *applyUrl;

+ (NSString*)appVersion;
- (void)setSchoolKey:(NSString*)schoolKey;
- (void)setDefaultSchoolKey;
@end
