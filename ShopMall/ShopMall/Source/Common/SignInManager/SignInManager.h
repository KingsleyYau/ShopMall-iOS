//
//  SignInManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKPlacemark.h>
#import <MapKit/MKReverseGeocoder.h>

#import "ShopDataManager.h"

typedef enum
{
    SignInStatus_off,
    SignInStatus_on,
}SignStatus;
typedef enum
{
    SignManagerHandleNone,
    SignManagerHandleSignIn,
    SignManagerHandleSignOut,
}SignManagerHandleStatus;

@interface CLLocation (Translate) {
    
}
// 地球坐标(google)转到火星坐标
- (CLLocation *)toMarsLocation;
@end

@protocol SignManagerDelegate <NSObject>
@optional
//- (void)signInStatusChanged:(SignStatus)status;
//- (void)signInError:(SignManagerHandleStatus)status error:(NSString*)error;
- (void)refreshFinish;
- (void)refreshError:(NSString *)error;
- (void)getLocationStringFinish:(NSString *)locationString;
@end

@interface SignInManager : NSObject {
    SignManagerHandleStatus _handleStatus;
    SignStatus _signStatus;
}
// 经纬度
@property (nonatomic, retain) CLLocation *checkInLocation;
@property (nonatomic, retain) NSString *sessionKey;
@property (nonatomic, weak, readonly) City *cityGPS;
@property (atomic, strong) NSString *locationInfoString;
#pragma mark - 注册回调
- (void)addDelegate:(id<SignManagerDelegate>)delegate;
- (void)removeDelegate:(id<SignManagerDelegate>)delegate;

#pragma mark - 签到签出
- (void)cancel;
- (BOOL)signOut;
// 定位
- (BOOL)setupLocationManager;

#pragma mark - 计算距离
- (NSString *)getDistance:(double)lat lon:(double)lon;
- (CGFloat)getDistanceMeter:(double)lat lon:(double)lon;
@end
