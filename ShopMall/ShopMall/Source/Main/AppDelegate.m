//
//  AppDelegate.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-10-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "AppDelegate.h"
// 视频音频
#import "AudioToolbox/AudioToolbox.h"

#import "MainTabBarController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化Crash Log捕捉
    _handler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler);
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    [self.window makeKeyAndVisible];
    
    // 注册地图
    [MAMapServices sharedServices].apiKey = @"340049090983b7a436499d9c67aa7e57";
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    
    // 注册推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    // 初始化配置
    self.appEnviroment = [[AppEnviroment alloc] init];
    
    // 初始化状态栏
    self.myStatusBar = [[MYUIStatusBar alloc] init];
    
    // 初始化控制器
    self.signInManager = [[SignInManager alloc] init];
    
    self.loginManager = [[LoginManager alloc] init];
    [self.loginManager addDelegate:self];
    
    // 初始化网关/资源包/用户/模块控制器
    self.gatewayManager = [[DrPalmGateWayManager alloc] init];
    self.modulesList = [[EBabyModuleList alloc] init];
    
    // 初始化升级控制器
//    self.updateAppViewController = [[UpdateAppViewController alloc] init];
    
    // 初始化分享
    [self initShare];
    
    // 为Document目录增加iTunes不同步属性
    NSURL *url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    [url addSkipBackupAttribute];

    KKNavigationController *nvc = (KKNavigationController *)self.window.rootViewController;
    nvc.isCustomNoTitleBackButton = YES;

    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    [titleTextAttributes setValue:(id)[[UIColor whiteColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
    [nvc.navigationBar setTitleTextAttributes:titleTextAttributes];
    [UINavigationBar appearance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if(![WiFiChecker isNetWorkOK]) {
        [WiFiChecker showNetworkError];
    }
    else {
        // 刷新定位信息
        [self.signInManager setupLocationManager];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSString *)applicationDocumentsDirectoryPath
{
    //    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}
#pragma mark - 界面布局文件
- (UIStoryboard *)storyBoard {
    UIStoryboard *storyBoard = nil;
    
    if(YES) {
        // iPhone
        storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    else {
        // iPad
        storyBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    return storyBoard;
}
#pragma mark - 初始化分享
- (void)initShare {
//    for (ShareItemEntitlement *shareItem in AppEnviromentInstance().shareEntitlement.shares) {
//        if ([shareItem.type isEqualToString:@"weixin"]) {
//            // 向微信注册
//            [WXApi registerApp:shareItem.appKey];
//        }
//        else if ([shareItem.type isEqualToString:@"sinawb"]) {
//            // 向新浪微博注册
//            [WeiboSDK enableDebugMode:YES];
//            [WeiboSDK registerApp:shareItem.appKey];
//        }
//    }
}
#pragma mark - 选择分享
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NSLog(@"handleOpenURL:\n%@\n", url);
//    BOOL canHandle = NO;
//    for (ShareItemEntitlement *shareItem in AppEnviromentInstance().shareEntitlement.shares) {
//        if ([shareItem.type isEqualToString:@"weixin"]) {
//            // 处理微信请求
//            canHandle = [WXApi handleOpenURL:url delegate:self];
//        }
//        else if ([shareItem.type isEqualToString:@"sinawb"]) {
//            // 处理新浪微博请求
//            canHandle = [WeiboSDK handleOpenURL:url delegate:self];
//        }
//    }
//    return canHandle;
//}

#pragma mark - 新浪微博回调
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//}
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//}

#pragma mark - (运行时配置 RunTimeInfoFunction)
#define RUN_TIME_INFO_PLIST @"RunTimeInfo"
#define IS_FIRST_TIME_RUN  @"IsFirstTimeRun" // 是否首次运行(Bool)

- (NSString*)runTimeInfoPath {
    NSString *mainPath = self.applicationDocumentsDirectoryPath;
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", mainPath, RUN_TIME_INFO_PLIST, nil];
    return path;
}
- (BOOL)isFirstTimeRun {
    BOOL isFirstTime = YES;
    NSString *path = [self runTimeInfoPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    id isFirstTimeRun = [dict objectForKey:curVersion];
    if(nil != isFirstTimeRun && [NSNull null] != isFirstTimeRun) {
        isFirstTime = [isFirstTimeRun boolValue];
    }
    return isFirstTime;
}
- (void)setFirstTimeRun:(BOOL)isFirstTime {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *path = [self runTimeInfoPath];
    [dict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:path]];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    [dict setObject:[NSNumber numberWithBool:isFirstTime] forKey:curVersion];
    [dict writeToFile:path atomically:YES];
}
#pragma mark Push notifications
- (void)clearNotification
{
    UIApplication* application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification:\r%@", userInfo);
    // 程序正在前台运行的Push处理
    [self clearNotification];
    id foundValue = [userInfo objectForKey:@"aps"];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSDictionary class]]) {
        // 主程序图标
        id foundValueSub = [foundValue objectForKey:@"badge"];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = [foundValueSub integerValue];
        }
        // 是否震动
        foundValueSub = [foundValue objectForKey:@"vibrate"];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            if([foundValueSub boolValue]) {
                // 震她妹
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
        // 是否响
        foundValueSub = [foundValue objectForKey:@"sound"];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            NSString *soundString = foundValueSub;
            if(soundString.length > 0) {
                //                // 声音文件
                //                NSString *soundFileName = [[NSBundle mainBundle] pathForResource:soundString ofType:@"wav"];
                //                CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:soundFileName];
                //                SystemSoundID sound = 0;
                //                AudioServicesCreateSystemSoundID(baseURL, &sound);
                //                if(sound) {
                //                    AudioServicesPropertyID flag = 0;  // 无视一切阻碍怒哮
                //                    AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &sound, sizeof(AudioServicesPropertyID), &flag);
                //                    if ([MPMusicPlayerController iPodMusicPlayer].playbackState ==  MPMusicPlaybackStatePlaying)
                //                        // 播放音乐中只震动
                //                        AudioServicesPlayAlertSound(sound);
                //                    else  {
                //                        // 怒哮吧
                //                        AudioServicesPlaySystemSound(sound);
                //                    }
                //                }
            }
        }
    }
    
    KKNavigationController *nvc = (KKNavigationController *)self.window.rootViewController;

    NSArray *array = nvc.viewControllers;
    for(UIViewController* vc in array) {
        if([vc isKindOfClass:[MainTabBarController class]])
        {
            // 回到主界面
            [nvc popToViewController:vc animated:NO];
            // 进入详细
            id foundValueSub = [userInfo objectForKey:@"type"];
            if([foundValueSub isKindOfClass:[NSNumber class]]) {
                NSNumber *type = foundValueSub;
                
                foundValueSub = [userInfo objectForKey:@"id"];
                if([foundValueSub isKindOfClass:[NSNumber class]]) {
                    NSNumber *itemId = foundValueSub;
                    
                    switch ([type integerValue]) {
                        case 1: {
                            // 商户详细
//                            ShopDetailViewController *vc = [[[ShopDetailViewController alloc] init] autorelease];
//                            vc.shopID = itemId;
//                            [theNormalNavController pushViewController:vc animated:YES];
                            break;
                        }
                        case 2: {
                            // 资讯详细
//                            ShopNewsDetailViewController *vc = [[[ShopNewsDetailViewController alloc] init] autorelease];
//                            vc.shopNewsID = itemId;
//                            [theNormalNavController pushViewController:vc animated:YES];
                            break;
                        }
                        case 3: {
                            // 其他
                        }
                        default:
                            break;
                    }
                }
                
            }
            
        }
    }
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken: %@", deviceToken);
    self.deviceToken = deviceToken;
    // 签到
    [self.signInManager setupLocationManager];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
//    // 自动登录
//    [self.loginManager autoLogin];
}

#pragma mark - Crash处理
- (BOOL)logCrashToFile:(NSString *)errorString {
    BOOL bFlag = NO;
    // Crash Log写入到文件
    NSString *documentsDriectory = AppDelegate().applicationDocumentsDirectoryPath;
    NSDate *curDate = [NSDate date];
    [curDate toString2YMDHM];
    NSString *fileName = [NSString stringWithFormat:@"DrPalm %@.crash", [curDate toStringYMDHM], nil];
    NSString *filePath = [documentsDriectory stringByAppendingPathComponent:fileName];
    
    bFlag = [errorString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if(bFlag) {
        NSLog(@"crash log has been save:%@", filePath);
    }
    return bFlag;
}
void UncaughtExceptionHandler(NSException *exception) {
    // Objective-C 异常处理,BAD_ACCESS等错误不能捕捉
    NSArray *stack = [exception callStackReturnAddresses];
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSMutableString *reportString = [NSMutableString string];
    // 设备
    [reportString appendFormat:@"Device-name: %@\n", [[UIDevice currentDevice] name]];
    [reportString appendFormat:@"Device-model: %@\n", [[UIDevice currentDevice] model]];
    [reportString appendFormat:@"Device-System: %@\n", [[UIDevice currentDevice] systemName]];
    [reportString appendFormat:@"Device-System-Version: %@\n", [[UIDevice currentDevice] systemVersion]];
    
    // 程序
    [reportString appendFormat:@"Application: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    [reportString appendFormat:@"Application-Version-Bulid: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    // 原因
    [reportString appendFormat:@"ExecptionName:%@\nReason:%@\n\nSymbols:%@\n\nStack:%@\n", name, reason, symbols, stack];
    
    // Crash Log写入到文件
    [AppDelegate() logCrashToFile:reportString];
}

@end
