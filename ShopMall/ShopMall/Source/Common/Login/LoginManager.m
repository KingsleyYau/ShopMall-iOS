//
//  LoginManager.m
//  MIT Mobile
//
//  Created by KingsleyYau_lion on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginManager.h"
#import "LoginLanguageDef.h"

#import "ShopRequestOperator.h"
#import "ShopDataManager.h"

@interface LoginManager() <ShopRequestOperatorDelegate> {
    LoginManagerHandleStatus _handleStatus;
    LoginStatus _loginStatus;
    LoginSuccessOperationManager *_loginSuccessOpertionManager;
    NSLock *_delegateLock;
}
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) LoginSuccessOperationManager *loginSuccessOperationManager;
@property (atomic, retain) NSMutableSet *delegates;
@property (nonatomic, retain) NSString *password;

-(void)handleLogin:(id)data;
-(void)handleLogout:(id)data;
-(void)callDelegateChangeStatus;
-(void)callDelegateError:(LoginManagerHandleStatus)status error:(NSString*)error;
@end

@implementation LoginManager
@synthesize handleStatus = _handleStatus;
@synthesize loginStatus = _loginStatus;
@synthesize loginSuccessOperationManager = _loginSuccessOperationManager;
@synthesize requestOperator;

-(id)init
{
    if (self = [super init])
    {
        _handleStatus = LoginManagerHandleNone;

        _delegateLock = [[NSLock alloc] init];
        self.delegates = [NSMutableSet set];
        
//        self.loginSuccessOperationManager = [[[LoginSuccessOperationManager alloc] init] autorelease];
//        [self.loginSuccessOperationManager registerLoginManager:self];
        
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return self;
}

//-(void)dealloc
//{
//    [self cancel];
//    
//    [self.delegates removeAllObjects];
//    self.delegates = nil;
//
//    self.password = nil;
//    
//    self.loginSuccessOperationManager = nil;
//    self.requestOperator = nil;
//    
//    if(_delegateLock) {
//        [_delegateLock release];
//        _delegateLock = nil;
//    }
//    [super dealloc];
//}
- (void)reset {
    [ShopDataManager userChangeCurrent:nil];
}
#pragma mark - delegate operation
-(void)addDelegate:(id<LoginManagerDelegate>)delegate
{
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        [self.delegates addObject:delegate];
    [_delegateLock unlock];
}

-(void)removeDelegate:(id<LoginManagerDelegate>)delegate
{
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        [self.delegates removeObject:delegate];
    [_delegateLock unlock];
}

-(void)callDelegateChangeStatus
{
    // 非主线程回调
    [_delegateLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    for (id<LoginManagerDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector:@selector(loginStatusChanged:)]) {
            [delegate loginStatusChanged:_loginStatus];
        }
    }
    [_delegateLock unlock];
}

-(void)callDelegateError:(LoginManagerHandleStatus)status error:(NSString*)error
{
    for (id<LoginManagerDelegate> delegate in _delegates) 
    {
        if([delegate respondsToSelector:@selector(handleError:error:)]) {
            [delegate handleError:status error:error];
        }
    }
}

#pragma mark - 登陆接口
- (void)cancel {
    _handleStatus = LoginManagerHandleNone;
    [self.requestOperator cancel];
}

- (BOOL)autoLogin {
    User *user = [ShopDataManager userCurrent];
    if(user) {
        [self cancel];
        _loginStatus = LoginStatus_online;
        //_handleStatus = LoginManagerHandleLogin;
        self.password = user.userPwd;
        [self.requestOperator login:user.userID pwd:user.userPwd];
    }
    return NO;
}
- (BOOL)login:(NSString*)username password:(NSString*)password {
//    if (LoginManagerHandleNone == _handleStatus && LoginStatus_online != _loginStatus)
//    {
//        // 非已经登陆并且不在登陆过程
//        _handleStatus = LoginManagerHandleLogin;
//        self.password = [[password toMD5String] lowercaseString];
//        return [self.requestOperator login:username pwd:self.password];
//    }
//    else if (LoginManagerHandleLogin == _handleStatus){
//        // 正在登陆过程中
//        return YES;
//    }
//    else {
//        // 其他
//        return NO;
//    }
    [self cancel];
    _handleStatus = LoginManagerHandleLogin;
    self.password = [[password toMD5String] lowercaseString];
    return [self.requestOperator login:username pwd:self.password];
}

-(void)handleLogin:(id)json
{
    BOOL success = NO;
    NSString *errorString = @"登录失败";//ErrorCodeToString
    if ([json isKindOfClass:[NSDictionary class]]) {
        id foundValue = [json objectForKey:UserInfo];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSDictionary class]]) {

            User *user = [ShopDataManager userInsertWithDict:foundValue];
            if(user) {
                user.userPwd = self.password;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ShopDataManager userChangeCurrent:user];
                });
                _loginStatus = LoginStatus_online;
                success = YES;
            }
        }
    }
    
    if (success) {
        [self callDelegateChangeStatus];
    }
    else {
//        // 登陆失败, 密码等错误导致登陆失败,清除注销用户
//        [ShopDataManager userChangeCurrent:nil];
        [self callDelegateError:_handleStatus error:errorString];
    }
    _handleStatus = LoginManagerHandleNone;
}
-(BOOL)logout
{
    if (LoginManagerHandleNone == _handleStatus && LoginStatus_online == _loginStatus){
        _handleStatus = LoginManagerHandleLogout;
        [self handleLogout:nil];
        return YES;
    }
    else if (LoginManagerHandleLogout == _handleStatus){
        return YES;
    }
    else{
        return NO;
    }
}
- (void)handleLogout:(id)data {
    BOOL success = NO;
    [ShopDataManager userChangeCurrent:nil];
    _loginStatus = LoginStatus_off;
    [self reset];
    success = YES;
    if (success)
    {
        [self callDelegateChangeStatus];
    }
    _handleStatus = LoginManagerHandleNone;
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
//    LoginManagerHandleStatus handleStatus = _handleStatus;
    [self cancel];
    switch (type) {
        case ShopRequestOperatorStatus_Login: {
            [self handleLogin:json];
//            if (LoginManagerHandleLogin == handleStatus) {
//                [self handleLogin:json];
//            }
//            else if (LoginManagerHandleLogout == handleStatus)
//            {
//                // 不等注销
//                [self handleLogout:json];
//            }
        }break;
        case ShopRequestOperatorStatus_Logout: {
            [self handleLogout:json];
        }break;
        default:
            break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    LoginManagerHandleStatus status = _handleStatus;
    [self cancel];
    switch (type) {
        case ShopRequestOperatorStatus_Login: {
            [self callDelegateError:status error:error];
        }break;
        case ShopRequestOperatorStatus_Logout: {
            // 不处理注销返回
            [self handleLogout:nil];
        }break;
        default:
            break;
    }
}
@end
