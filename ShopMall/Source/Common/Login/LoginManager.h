//
//  LoginManager.h
//  MIT Mobile
//
//  Created by KingsleyYau_lion on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//  登录模块，负责向网关登录，并记录登录信息

#import <Foundation/Foundation.h>
#import "ConnectionWrapper.h"
#import "LoginLanguageDef.h"
typedef enum
{
    LoginStatus_off,
    LoginStatus_local,
    LoginStatus_online,
}LoginStatus;

typedef enum 
{
    UserTypeUnkonw,
    UserTypeStudent,
    UserTypeTeacher,
    UserTypeParent
}UserType;

typedef enum
{
    LoginManagerHandleNone,
    LoginManagerHandleLogin,
    LoginManagerHandleLogout,
    LoginManagerHandleLocalLogin
}LoginManagerHandleStatus;

@protocol LoginManagerDelegate <NSObject>
@optional
- (void)loginStatusChanged:(LoginStatus)status;
- (void)handleError:(LoginManagerHandleStatus)status error:(NSString*)error;
@end

@class LoginSuccessOperationManager;
@interface LoginManager : NSObject {

}
@property (nonatomic, readonly) NSString* userID;
@property (nonatomic, readonly) NSString* userName;
@property (nonatomic, readonly) LoginStatus loginStatus;
@property (nonatomic, readonly) LoginManagerHandleStatus handleStatus;

- (void)addDelegate:(id<LoginManagerDelegate>)delegate;
- (void)removeDelegate:(id<LoginManagerDelegate>)delegate;

- (BOOL)autoLogin;
- (BOOL)login:(NSString*)username password:(NSString*)password;
- (BOOL)logout;
- (void)cancel;
- (void)reset;

@end

#define IsOnlineStatus  (LoginStatus_online == LoginManagerInstance().loginStatus)
