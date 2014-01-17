 //
//  RequestOperator.m
//  DrPalm
//
//  Created by KingsleyYau on 12-11-20.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#import "RequestOperator.h"
// Other Module
//#import "LoginManager.h"
#import "SignInManager.h"
// Define
#import "ErrorCodeDef.h"
// Common
#import "MITMobileServerConfiguration.h"

// 后台处理队列
#define REQUESTQUEUENAME "com.shopla.palm.ReqeustQueue"    
@interface RequestOperator() <DrPalmGateWayManagerDelegate, LoginManagerDelegate, SignManagerDelegate> {
    BOOL _isPost;
    NSInteger _sessionKeyErrorTime;
}
@property (nonatomic, retain) NSString *paramPath;
@property (nonatomic, retain) NSDictionary *paramDict;
@property (nonatomic, retain) NSArray *paramPostDataArray;
@property (nonatomic, retain) NSData *paramBody;
@end

@implementation RequestOperator
@synthesize httpClient;
@synthesize paramPath;
@synthesize paramDict;
@synthesize paramPostDataArray;
@synthesize paramBody;
@synthesize paramOperation;
@synthesize delegate;
#pragma mark - (构造)
-(id)init
{
    if (self = [super init])
    {
//         _requestQueue = dispatch_queue_create(REQUESTQUEUENAME, nil);
        _isPost = NO;
        _sessionKeyErrorTime = 0;
        
        self.httpClient = [[HttpClient alloc] init];
        self.httpClient.delegate = self;

    }
    return self;
}
//- (void)dealloc {
//    self.delegate = nil;
//
//    dispatch_release(_requestQueue);
//    [self cancel];
//    self.httpClient = nil;
//    [super dealloc];
//}
#pragma mark - (重置请求)
- (void)cancel {
    // 由外部调用才重置的参数
    [self.httpClient cancel];
    self.paramDict = nil;
    self.paramPostDataArray = nil;
    self.paramBody = nil;
    self.paramPath = nil;
    self.paramOperation = nil;
    _sessionKeyErrorTime = 0;
    
    [DrPalmGateWayManagerInstance() removeDelegate:self];
//    LoginManager *loginManager = LoginManagerInstance();
//    [loginManager removeDelegate:self];
    SignInManager *signInManager = SignInManagerInstance();
    [signInManager removeDelegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)reRequest {
    // 每次发送请求前都需要重置的参数
    _isPost = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    LoginManager *loginManager = LoginManagerInstance();
//    [loginManager removeDelegate:self];
    
    SignInManager *signInManager = SignInManagerInstance();
    [signInManager removeDelegate:self];
}
#pragma mark - (组建参数)
- (HttpClientPostBody *)buildPostParam:(NSString*)paramName content:(NSString*)content; {
    HttpClientPostBody *postBody = [[HttpClientPostBody alloc] init];
    postBody.paramName = paramName;
    postBody.content = content;
    return postBody;
}
- (HttpClientPostBody *)buildFilePostParam:(NSString*)paramName contentType:(NSString*)contentType data:(NSData*)data fileName:(NSString*)fileName {
    HttpClientPostBody *postBody = [[HttpClientPostBody alloc] init];
    postBody.isFile = YES;
    postBody.paramName = paramName;
    postBody.contentType = contentType;
    postBody.data = data;
    postBody.fileName = fileName;
    return postBody;
}
#pragma mark - (错误处理)
- (BOOL)isParsingOpretSuccess:(id)data errorCode:(NSMutableString *)errorCode {
    BOOL success = NO;
    if(nil == data)
        return success;
    if (nil != data && [NSNull null] != data && [data isKindOfClass:[NSDictionary class]]){
        NSDictionary *opretDict = [data objectForKey:OPRET];
        if(nil != opretDict){
            NSString *opflagStr = [opretDict objectForKey:OPFLAG];
            int flag = [opflagStr integerValue];
            if(nil == opflagStr || flag == 1){
                success = YES;
            }
            else{
                NSString *opCode = [opretDict objectForKey:OPCODE];
                [errorCode setString:opCode];
            }
        }
    }
    return success;
}
- (BOOL)handleInvalidSessionKey {
    BOOL bFlag = NO;
    SignInManager *signInManager = SignInManagerInstance();
    dispatch_async(dispatch_get_main_queue(), ^{
        // 签出
        [signInManager signOut];
        // 重新签到
        [signInManager addDelegate:self];
        if([signInManager setupLocationManager]) {
            // 定位成功,等待协议返回
        }
        else {
            // 定位失败,通知界面
            if([self.delegate respondsToSelector:@selector(requestFail:)]){
                [self.delegate requestFail:ErrorCodeToString(InvalidSessionKey)];
            }
        }
    });
//    // 重新登陆
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
//    if(_sessionKeyErrorTime++ == 0 && YES){
//        // 重新登陆
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 重新签到
//            [signInManager addDelegate:self];
//            if([signInManager setupLocationManager]) {
//                // 定位成功,等待协议返回
//            }
//            else {
//                // 定位失败
//            }
//        });
//    }else {
//        // 如果已经处理过,直接返回失败
//        bFlag = YES;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:LoginSessionTimeout delegate:nil cancelButtonTitle:LoginOK otherButtonTitles:nil, nil] autorelease];
//            [alertView show];
//        });
//    }
    return bFlag;
}
- (NSString *)handleErrorByCode:(NSString *)errorCode{
    NSString *errorString = nil;
    errorString = ErrorCodeToString(errorCode);
    BOOL bFlag = YES;
    NSInteger iErrorCode = 0;
    iErrorCode = [errorCode integerValue];
    //if ([errorCode isEqualToString:InvalidSessionKey]){
    if (iErrorCode >= 199012 && iErrorCode <= 199020) {
        // 处理sessionKey超时或者无效
        bFlag = [self handleInvalidSessionKey];
    }
    
    if(bFlag) {
        // 表示已经处理,通知界面
        if([self.delegate respondsToSelector:@selector(requestFail:)]){
            [self.delegate requestFail:errorString];
        }
    }
    
    return errorString;
}
#pragma mark - (发送请求)
- (BOOL)sendSingleGet:(NSString *)urlPath paramDict:(NSDictionary *)paramNewDict {
    
    [self reRequest];
    self.paramPath = urlPath;
    self.paramDict = paramNewDict;
    NSMutableDictionary *paramSendDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    //if (nil != DrPalmGateWayManagerInstance().schoolId)
    if(YES)
    {
        NSMutableString *urlString = [NSMutableString string];
        /* 从中心获取的网关 */
        //[urlString appendString:[MITMobileWebGetCurrentServerURL() absoluteString]];
        /* 内部测试网关 */
        [urlString appendString:@"http://210.22.12.21:13080/shoppinglbs/gw/"];
        
        [urlString appendString:urlPath];
        
//        DrPalmGateWayManager* gateWayManager = DrPalmGateWayManagerInstance();
//        [paramSendDict setObject:gateWayManager.schoolId forKey:LBSAPPID];
        /* 内部测试ID */
        [paramSendDict setObject:@"1" forKey:LBSAPPID];

        return [self.httpClient sendSingleGet:urlString paramDict:paramSendDict];
    }
    else {
        return [DrPalmGateWayManagerInstance() getGateWays:self];
    }
}
- (BOOL)sendSinglePost:(NSString *)urlPath paramArray:(NSArray *)paramArray {
    [self reRequest];
    _isPost = YES;
    self.paramPath = urlPath;
    self.paramPostDataArray = paramArray;
    //if (nil != DrPalmGateWayManagerInstance().schoolId)
    if(YES)
    {
        NSMutableString *urlString = [NSMutableString string];
        /* 从中心获取的网关 */
        //[urlString appendString:[MITMobileWebGetCurrentServerURL() absoluteString]];
        /* 内部测试网关 */
        [urlString appendString:@"http://210.22.12.21:13080/shoppinglbs/gw/"];
        
        [urlString appendString:urlPath];
        NSLog(@"Post method\rurl:%@", urlString);
        
        NSMutableData *postData = [NSMutableData data];
        
//        DrPalmGateWayManager* gateWayManager = DrPalmGateWayManagerInstance();
        NSMutableString *httpBody = [NSMutableString string];
//        [httpBody appendString:[self.httpClient buildPostParam:LBSAPPID content:gateWayManager.schoolId]];
        /* 内部测试ID */
        [httpBody appendString:[self.httpClient buildPostParam:LBSAPPID content:@"1"]];
        [postData appendData:[httpBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        for(HttpClientPostBody *postBody in paramArray) {
            NSData *data = nil;
            if(postBody.isFile) {
//                NSLog(@"Post method\rcontenttype:%@\rname:%@\rfilename:%@\r", postBody.contentType, postBody.paramName, postBody.fileName);
                data = [self.httpClient buildFilePostParam:postBody.paramName contentType:postBody.contentType data:postBody.data fileName:postBody.fileName];

            }
            else {
//                NSLog(@"Post method\rname:%@\rcontent:%@\r", postBody.paramName, postBody.content);
                data = [[self.httpClient buildPostParam:postBody.paramName content:postBody.content] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            }
            if(data)
                [postData appendData:data];
        }
        return [self.httpClient sendSinglePost:urlString body:postData];
    }
    else {
        return [DrPalmGateWayManagerInstance() getGateWays:self];
    }
}
#pragma mark - (网关回调 HttpClientDelegate)
-(void)getGateWaySuccess
{
    if(!_isPost) {
        [self sendSingleGet:self.paramPath paramDict:self.paramDict];
    }
    else {
        //[self sendSinglePost:self.paramPath body:self.paramBody];
        [self sendSinglePost:self.paramPath paramArray:self.paramPostDataArray];
    }
}

-(void)getGateWayFail
{
    if([self.delegate respondsToSelector:@selector(requestFail:)]){
        [self.delegate requestFail:@"获取网关错误"];
    }
}
#pragma mark - (登陆回调 LoginManagerDelegate)
//- (void)loginStatusChanged:(LoginStatus)status
//{
//    if (LoginStatus_online == status){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 重登陆成功,重新读取sessionkey
//            if(!_isPost) {
//                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.paramDict];
//                if(nil != [mDict objectForKey:SESSION_KEY]) {
//                    LoginManager *loginManager = LoginManagerInstance();
//                    [mDict setObject:loginManager.sessionKey forKey:SESSION_KEY];
//                }
//                [self sendSingleGet:self.paramPath paramDict:mDict];
//            }
//            else {
//                NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.paramPostDataArray];
//                for(HttpClientPostBody *postBody in mArray) {
//                    if(postBody.paramName == SESSION_KEY) {
//                        LoginManager *loginManager = LoginManagerInstance();
//                        postBody.content = loginManager.sessionKey;
//                    }
//                }
//                [self sendSinglePost:self.paramPath paramArray:mArray];
//            }
//        });
//    }
//}
//- (void)handleError:(LoginManagerHandleStatus)status error:(NSString*)error
//{
//    if([self.delegate respondsToSelector:@selector(requestFail:)]){
//        [self.delegate requestFail:error];
//    }
//}
#pragma mark - 签到回调 (SignInManagerDelegate)
//- (void)signInStatusChanged:(SignStatus)status {
//    if (SignInStatus_on == status){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 重登陆成功,重新读取sessionkey
//            if(!_isPost) {
//                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.paramDict];
//                if(nil != [mDict objectForKey:SESSION_KEY]) {
//                    SignInManager *signInManager = SignInManagerInstance();
//                    [mDict setObject:signInManager.sessionKey forKey:SESSION_KEY];
//                }
//                [self sendSingleGet:self.paramPath paramDict:mDict];
//            }
//            else {
//                NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.paramPostDataArray];
//                for(HttpClientPostBody *postBody in mArray) {
//                    if(postBody.paramName == SESSION_KEY) {
//                        SignInManager *signInManager = SignInManagerInstance();
//                        postBody.content = signInManager.sessionKey;
//                    }
//                }
//                [self sendSinglePost:self.paramPath paramArray:mArray];
//            }
//        });
//    }
//}
- (void)refreshFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 重签到成功,重新读取sessionkey
        if(!_isPost) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.paramDict];
            //if(nil != [mDict objectForKey:SESSION_KEY]) {
            SignInManager *signInManager = SignInManagerInstance();
            [mDict setObject:signInManager.sessionKey forKey:SESSION_KEY];
//            if(nil != [mDict objectForKey:LAT] && nil != [mDict objectForKey:LNG]) {
//                // 纬度
//                NSString *latString = [NSString stringWithFormat:@"%f", signInManager.checkInLocation.coordinate.latitude];
//                [mDict setObject:latString forKey:LAT];
//                // 经度
//                NSString *lonString = [NSString stringWithFormat:@"%f", signInManager.checkInLocation.coordinate.longitude];
//                [mDict setObject:lonString forKey:LNG];
//            }


            [self sendSingleGet:self.paramPath paramDict:mDict];
        }
        else {
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.paramPostDataArray];
            for(HttpClientPostBody *postBody in mArray) {
                if([postBody.paramName isEqualToString:SESSION_KEY]) {
                    SignInManager *signInManager = SignInManagerInstance();
                    postBody.content = signInManager.sessionKey;
                }
            }
            [self sendSinglePost:self.paramPath paramArray:mArray];
        }
    });
}
- (void)refreshError:(NSString *)error {
    if([self.delegate respondsToSelector:@selector(requestFail:)]){
        [self.delegate requestFail:error];
    }
}
#pragma mark - (Http回调 HttpClientDelegate)
- (void)requestFinish:(id)data
{
    id json = [MITJSON objectWithJSONData:data];
    
    NSLog(@"Json:\r%@", json);
    NSMutableString *errorCode = [NSMutableString string];
    if([self isParsingOpretSuccess:json errorCode:errorCode]) {
        // 合法的请求直接返回
        if([self.delegate respondsToSelector:@selector(requestFinish:)]){
            [self.delegate requestFinish:json];
        }
    }
    else {
        // 处理错误
        [self handleErrorByCode:errorCode];
    }
}
- (void)requestFail:(NSString*)error {
    // 网络请求失败
    if([self.delegate respondsToSelector:@selector(requestFail:)]){
        [self.delegate requestFail:error];
    }
}
@end
