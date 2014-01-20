//
//  AppDelegate.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppEnviroment.h"
#import "DrPalmGateWayManager.h"
#import "SignInManager.h"
#import "LoginManager.h"
#import "EBabyModuleList.h"

//#import "UpdateAppViewController.h"

#define AppDelegate() ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define AppEnviromentInstance() AppDelegate().appEnviroment
#define DrPalmGateWayManagerInstance() AppDelegate().gatewayManager
#define SignInManagerInstance() AppDelegate().signInManager
#define LoginManagerInstance() AppDelegate().loginManager
#define EBabyModuleListInstance() AppDelegate().modulesList

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSUncaughtExceptionHandler *_handler;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic, readonly) UIStoryboard *storyBoard;
@property (strong, nonatomic) AppEnviroment *appEnviroment;         // 全局风格属性控制器
@property (strong, nonatomic) DrPalmGateWayManager *gatewayManager; // 网关控制器
@property (strong, nonatomic) SignInManager *signInManager;         // 签到和定位控制器
@property (strong, nonatomic) LoginManager *loginManager;           // 登陆控制器
@property (strong, nonatomic) EBabyModuleList *modulesList;         // 模块控制器
@property (strong, nonatomic) NSData *deviceToken;                  // 推送token


//@property (strong, nonatomic) WelcomeViewController *welcomeViewController; // 欢迎界面
//@property (strong, nonatomic) UpdateAppViewController *updateAppViewController; // 升级界面
@property (strong, nonatomic) MYUIStatusBar *myStatusBar; // 状态栏
@property(nonatomic, strong) MAMapView *mapView; // 地图

- (NSURL *)applicationDocumentsDirectory;
- (NSString *)applicationDocumentsDirectoryPath; // 程序可写目录(Document)
@end
