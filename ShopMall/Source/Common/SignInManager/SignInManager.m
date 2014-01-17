//
//  SignInManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SignInManager.h"
#import "ShopRequestOperator.h"


@implementation CLLocation (Translate)
- (BOOL)outOfChina:(double)lat lon:(double)lon {
    if (lon < 72.004 || lon > 137.8347)
        return YES;
    if (lat < 0.8293 || lat > 55.8271)
        return NO;
    return NO;
}
- (double)transformLat:(double)x y:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

- (double)transformLon:(double)x y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
- (CLLocation *)locationToPixel:(double)lat lon:(double)lon {
    const double a = 6378245.0;
    const double ee = 0.00669342162296594323;
    
    double dLat = [self transformLat:lon - 105.0 y:lat - 35.0];
    double dLon = [self transformLon:lon - 105.0 y:lat - 35.0];
    double radLat = lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mgLat longitude:mgLon];
    NSLog(@"地球坐标:[LAT:%.8f,LON:%.8f], 火星坐标:[LAT:%.8f,LON:%.8f]", lat, lon, location.coordinate.latitude, location.coordinate.longitude);
    return location;
}
- (CLLocation *)toMarsLocation {
    return [self locationToPixel:self.coordinate.latitude lon:self.coordinate.longitude];
}
@end

@interface SignInManager () <ShopRequestOperatorDelegate, CLLocationManagerDelegate> {
    NSLock *_delegateLock;
    
    CLLocationManager *_locationManager;
    CLLocation *_checkInLocation;
    
//    NSString *_locationInfoString;
}
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) NSMutableSet *delegates;
@property (nonatomic, retain) NSObject *geocoder;
@property (nonatomic, retain) CLLocationManager *locationManager;

// 定位错误提示
- (void)showNetworkError;
- (void)showLocationError;
// 根据坐标获取地理信息
- (void)getLocationInfomation;

// 签到回调
//- (void)callDelegateChangeStatus;
//- (void)callDelegateError:(SignManagerHandleStatus)status error:(NSString *)error;
- (void)callDelegateRefresh:(BOOL)succeed error:(NSString *)error;
- (void)callDelegateGetLocationString:(NSString *)locationString;
// 签到请求
- (BOOL)refresh;
- (BOOL)signIn;
// 签到处理
- (void)handleSignIn:(id)json;
- (void)handleSignout:(id)json;
- (void)handleRefresh:(id)json;
@end

@implementation SignInManager
#pragma mark - 构造
- (id)init {
    if (self = [super init]) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
        
        _delegateLock = [[NSLock alloc] init];
        self.delegates = [NSMutableSet set];
        
        _sessionKey = nil;
        _locationInfoString = nil;
    }
    return self;
}
- (City *)cityGPS {
    return [ShopDataManager cityGPS];
}
#pragma mark - 注册回调
- (void)addDelegate:(id<SignManagerDelegate>)delegate
{
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [self.delegates addObject:delegate];
    [_delegateLock unlock];
}

- (void)removeDelegate:(id<SignManagerDelegate>)delegate
{
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [self.delegates removeObject:delegate];
    [_delegateLock unlock];
}
//- (void)callDelegateChangeStatus
//{
//    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
//    for (id<SignManagerDelegate> delegate in self.delegates)
//    {
//        if([delegate respondsToSelector:@selector(signInStatusChanged:)]) {
//            [delegate signInStatusChanged:_signStatus];
//        }
//    }
//    [_delegateLock unlock];
//}
//- (void)callDelegateError:(SignManagerHandleStatus)status error:(NSString*)error
//{
//    for (id<SignManagerDelegate> delegate in self.delegates)
//    {
//        if([delegate respondsToSelector:@selector(signInError:error:)]) {
//            [delegate signInError:status error:error];
//        }
//    }
//}
- (void)callDelegateRefresh:(BOOL)succeed error:(NSString *)error{
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    for (id<SignManagerDelegate> delegate in self.delegates)
    {
        if(succeed) {
            if([delegate respondsToSelector:@selector(refreshFinish)]) {
                [delegate refreshFinish];
            }
        }
        else if([delegate respondsToSelector:@selector(refreshError:)]){
            [delegate refreshError:error];
        }

    }
    [_delegateLock unlock];
}
- (void)callDelegateGetLocationString:(NSString *)locationString {
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    for (id<SignManagerDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector:@selector(getLocationStringFinish:)]) {
            [delegate getLocationStringFinish:locationString];
        }
    }
    [_delegateLock unlock];
}
#pragma mark - 计算距离
- (NSString *)getDistance:(double)lat lon:(double)lon {
    CLLocation *userLocation = [self.locationManager location];
    CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    NSString *stringDistance = [NSString stringWithFormat:@"%0.1fkm", [userLocation distanceFromLocation:desLocation] / 1000];
    if([userLocation distanceFromLocation:desLocation] / 1000 > 5) {
        stringDistance = @">5km";
    }
    return stringDistance;
}
- (CGFloat)getDistanceMeter:(double)lat lon:(double)lon {
    CLLocation *userLocation = [self.locationManager location];
    CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return [userLocation distanceFromLocation:desLocation];
}
#pragma mark - 根据坐标获取地理信息
- (void)getLocationInfomation {
    CLLocation *userLocation = [self.checkInLocation toMarsLocation];
    double version = [[[UIDevice currentDevice] systemVersion] doubleValue];
    if(version >= 5) {
        // ios5以上的版本
        CLGeocoder *theGeocoder = [[CLGeocoder alloc] init];
        [theGeocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray* array , NSError* error){
            if (array.count > 0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                NSLog(@"%@", placemark);
                self.locationInfoString = placemark.thoroughfare;
                [self callDelegateGetLocationString:self.locationInfoString];
            }
        }];
        self.geocoder = theGeocoder;
    }
//    else {
//        MKReverseGeocoder *theGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:userLocation.coordinate];
//        theGeocoder.delegate = self;
//        self.geocoder = theGeocoder;
//        [theGeocoder start];
//    }
}
#pragma mark - 地理信息回调 (MKReverseGeocoderDelegate)
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
//    NSLog(@"%@", placemark);
//    self.locationInfoString = placemark.thoroughfare;
//    [self callDelegateGetLocationString:self.locationInfoString];
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
//    self.locationInfoString = @"无法定位";
//    [self callDelegateGetLocationString:self.locationInfoString];
//}
#pragma mark - 签到签出刷新请求
-(void)cancel
{
    _handleStatus = SignManagerHandleNone;
    [self.requestOperator cancel];
}
- (BOOL)refresh {
    // 发送刷新定位请求
    [self.requestOperator cancel];
    return [self.requestOperator refresh:self.sessionKey lat:self.checkInLocation.coordinate.latitude lon:self.checkInLocation.coordinate.longitude];
//    // 4test
//    [self handleRefresh:nil];
    return NO;
}
- (BOOL)signIn {
    if (SignManagerHandleNone == _handleStatus && SignInStatus_on != _signStatus) {
        // 不在发送请求过程中,并且没有签到成功
        NSString *deviceToken = nil;//@"6c3bad4e02518f371836d6878013626a6c3bad4e02518f371836d6878013626a";
        if (nil != AppDelegate().deviceToken){
            deviceToken = [[NSString stringWithFormat:@"%@", AppDelegate().deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
            deviceToken = [deviceToken substringWithRange:NSMakeRange(1, [deviceToken length]-2)];
        }
        [self cancel];
        [self.requestOperator signIn:deviceToken lat:self.checkInLocation.coordinate.latitude lon:self.checkInLocation.coordinate.longitude];
        
        // 4test
        //[self handleSignIn:nil];
    }
    else if (SignManagerHandleSignIn == _handleStatus){
        // 在发送签到请求过程中, 跳过
        return YES;
    }
    return NO;
}
- (BOOL)signOut {
    if (SignManagerHandleNone == _handleStatus && SignInStatus_on == _signStatus){
        // 不在发送请求过程中,并且签到成功
        [self cancel];
        return [self.requestOperator signOut:self.sessionKey];
        [self handleSignout:nil];
    }
    else if (SignManagerHandleNone == _handleStatus){
        // 不在发送请求过程中,直接处理签出
        [self handleSignout:nil];
    }
    return NO;
}
- (void)handleSignout:(id)json {
    self.sessionKey = nil;
    
    //[self callDelegateChangeStatus];
    //[self callDelegateRefresh:YES error:nil];
    _handleStatus = SignManagerHandleNone;
}
- (void)handleSignIn:(id)json {
    // 解析签到成功json
    id foundValue = [json objectForKey:CityOwn];
    if(nil != foundValue && [NSNull null] != foundValue) {
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            City *city = [ShopDataManager cityInsertWithDict:foundValue];
            [CoreDataManager saveData];
            if(nil != city) {
                // 改变定位城市
                [ShopDataManager cityChangeGPS:city];
                // 如果当前没有选中城市,将签到的城市保存为当前
                if(nil == [ShopDataManager cityCurrent])
                    [ShopDataManager cityChangeCurrent:city];
            }
        }
    }
    self.sessionKey = [[json objectForKey:SESSION_KEY] copy];
    
//    // 4test
//    City *city = [ShopDataManager cityInsertWithId:[NSNumber numberWithInteger:1001]];
//    [ShopDataManager cityChangeCurrent:city];
//    [ShopDataManager cityChangeGPS:city];
//    _sessionKey = @"1234567890";

    //[self callDelegateChangeStatus];
    [self callDelegateRefresh:YES error:nil];
    _handleStatus = SignManagerHandleNone;
}
- (void)handleRefresh:(id)json {
    // 解析刷新成功json
    id foundValue = [json objectForKey:CityOwn];
    if(nil != foundValue && [NSNull null] != foundValue) {
        if([foundValue isKindOfClass:[NSDictionary class]]) {
            // 改变当前定位
            City *city = [ShopDataManager cityInsertWithDict:foundValue];
            [CoreDataManager saveData];
            [ShopDataManager cityChangeGPS:city];
        }
    }
    
//    // 4test
//    City *city = [ShopDataManager cityInsertWithId:[NSNumber numberWithInteger:1001]];
//    [ShopDataManager cityChangeGPS:city];
//    _sessionKey = @"1234567890";
    
    [self callDelegateRefresh:YES error:nil];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    switch (type) {
        case ShopRequestOperatorStatus_SignIn:{
            [self handleSignIn:json];
            break;
        }
        case ShopRequestOperatorStatus_SignOut:{
            // 不处理
            break;
        }
        case ShopRequestOperatorStatus_Refresh:{
            [self handleRefresh:json];
            break;
        }
        default:
            break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch (type) {
        case ShopRequestOperatorStatus_SignIn:{
            //[self callDelegateError:_signStatus error:error];
            [self callDelegateRefresh:NO error:@"刷新服务器gps坐标失败"];
            break;
        }
        case ShopRequestOperatorStatus_SignOut:{
            // 不处理
            break;
        }
        case ShopRequestOperatorStatus_Refresh:{
            [self callDelegateRefresh:NO error:@"刷新服务器gps坐标失败"];
            break;
        }
        default:
            break;
    }
    //[self showNetworkError];
}
#pragma mark - 获取当前位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSString *locationNewLog = [NSString stringWithFormat:@"lat:%.8f lon:%.8f", newLocation.coordinate.latitude, newLocation.coordinate.longitude, nil];
    NSLog(@"获取到新的经纬度:%@", locationNewLog);
    
    // 过滤无效和缓存的定位
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) {
        NSLog(@"新的定位5秒超时", nil);
        return;
    }
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) {
        NSLog(@"新的定位水平精确度小于0", nil);
        return;
    }
    
    if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
        // 定位的精确度大于需求的精确度，定位成功
        NSLog(@"新的定位水平精确度大于需求的精确度，定位成功", nil);
        [manager stopUpdatingLocation];
        manager.delegate = nil;
    }
    else {
        // 精确度未够
        NSLog(@"新的定位精确度未够, 新精确度:%.3f 需求精度:%.3f", newLocation.horizontalAccuracy, self.locationManager.desiredAccuracy);
        //return;
    }
    
    // 得到当前定位后的经纬度，当前经纬度是有一定偏移量的
//    CLLocation *testLocation = [[[CLLocation alloc] initWithLatitude:39.9221420288 longitude:116.3408432007] autorelease];
    self.checkInLocation = newLocation;
    NSLog(@"手机GPS坐标:%@", self.checkInLocation);
//    // 使用重新计算偏移
//    self.checkInLocation = [self locationToPixel:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];
//    NSLog(@"火星GPS坐标:%@", self.checkInLocation);
    self.locationInfoString = [NSString stringWithFormat:@"%.3f, %.3f", self.checkInLocation.coordinate.latitude, self.checkInLocation.coordinate.longitude];
    [self callDelegateGetLocationString:_locationInfoString];
    
    // 获取定位信息
    [self getLocationInfomation];
    NSString *locationLog = [NSString stringWithFormat:@"lat:%.8f lon:%.8f", self.checkInLocation.coordinate.latitude, self.checkInLocation.coordinate.longitude, nil];
    NSLog(@"获取当前经纬度:%@", locationLog);
    
    if(self.sessionKey.length == 0) {
        // 没有签到则签到
        [self signIn];
    }
    else {
        // 已经签到则刷新定位
        [self refresh];
    }

}
- (BOOL)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    // 是否已经开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager");
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 100;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        return YES;
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
        [self showLocationError];
    }
    return NO;
}
//- (double)transformLat:(double)x y:(double)y
//{
//    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
//    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
//    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
//    return ret;
//}
//
//- (double)transformLon:(double)x y:(double)y {
//    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
//    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
//    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
//    return ret;
//}
//- (CLLocation *)locationToPixel:(double)lat lon:(double)lon {
//    const double a = 6378245.0;
//    const double ee = 0.00669342162296594323;
//    
//    double dLat = [self transformLat:lon - 105.0 y:lat - 35.0];
//    double dLon = [self transformLon:lon - 105.0 y:lat - 35.0];
//    double radLat = lat / 180.0 * M_PI;
//    double magic = sin(radLat);
//    magic = 1 - ee * magic * magic;
//    double sqrtMagic = sqrt(magic);
//    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
//    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
//    double mgLat = lat + dLat;
//    double mgLon = lon + dLon;
//    CLLocation *location = [[[CLLocation alloc] initWithLatitude:mgLat longitude:mgLon] autorelease];
//    return location;
//}

#pragma mark - 错误提示
- (void)showNetworkError {
    // 弹出提示
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"网络连接错误"/*NetWorkError*/ delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
- (void)showLocationError {
    // 弹出提示
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"定位失败"/*LocationError*/ delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
@end
