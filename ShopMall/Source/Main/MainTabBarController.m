//
//  MainTabBarController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController () <LoginManagerDelegate> {
    BOOL _autoLogin;
}
@end

@implementation MainTabBarController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    
    // 拿网关
    DrPalmGateWayManager *gatewayManager = DrPalmGateWayManagerInstance();
    [gatewayManager getGateWays:self];

    // 自动登陆
    if([LoginManagerInstance() autoLogin]) {
        _autoLogin = YES;
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager addDelegate:self];
    
    [self updateViewControllers];
    [self setupNavigationBar];
    
    if(self.tabItem != 0) {
        [self selectTabAtIndex:self.tabItem];
        if(!_autoLogin)
            self.tabItem = 0;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - 界面逻辑
- (void)setupNavigationBar {
    self.navigationItem.title = self.selectedViewController.navigationItem.title;
    self.navigationItem.titleView = self.selectedViewController.navigationItem.titleView;
    
    // TODO:设置左边按钮
    self.navigationItem.leftBarButtonItem = self.selectedViewController.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = self.selectedViewController.navigationItem.leftBarButtonItems;
    
    // TODO:设置右边按钮
    self.navigationItem.rightBarButtonItem = self.selectedViewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = self.selectedViewController.navigationItem.rightBarButtonItems;
}
- (void)resetNavigationBar {
}
#pragma mark - (底部分页控件)
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self setupNavigationBar];
    [self selectTabBarItem:tabBarController viewController:viewController];
}
- (void)selectTabBarItem:(UITabBarController *)tabBarController viewController:(UIViewController *)viewController{
    // 显示对应的高亮tabrBarItem
    for(KKTabBarItem *tabrBarItem in tabBarController.tabBar.items) {
        [tabrBarItem setSelected:NO];
    }
    KKTabBarItem *tabrBarItem = (KKTabBarItem *)viewController.tabBarItem;
    [tabrBarItem setSelected:YES];
}
- (void)selectTabAtIndex:(int)index {
    if(index > self.viewControllers.count)
        return;
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
    [self selectTabBarItem:self viewController:self.selectedViewController];
    [self setupNavigationBar];
}
- (void)selectTabViewController:(UIViewController *)viewController {
    self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
    [self setupNavigationBar];
}
- (void)updateViewControllers {
    NSMutableArray *moduleArray = [NSMutableArray array];
    
    for(EBabyModule *module in EBabyModuleListInstance().modules) {
        if(module.viewController)
            [moduleArray addObject:module.viewController];
        
        KKTabBarItem *tabrBarItem = (KKTabBarItem *)module.viewController.tabBarItem;
        tabrBarItem.kkimage = module.tabBarUnSelectedIcon;
        tabrBarItem.kkselectedImage = module.tabBarSelectedIcon;
        tabrBarItem.isFullItemImage = YES;
        tabrBarItem.isHighLight = NO;
        [tabrBarItem setSelected:NO];
        
        // 刷新Tabbar数字
        if([module.viewController respondsToSelector:@selector(reloadTabbarItem)]) {
            [module.viewController performSelector:@selector(reloadTabbarItem)];
        }
    }
    
    self.viewControllers = moduleArray;

    if(self.selectedIndex > 0 && self.selectedIndex < self.tabBar.items.count) {
        [self selectTabAtIndex:self.selectedIndex];
    }
    else {
        // TODO:默认选上第一项
        [self selectTabAtIndex:0];
    }
}

#pragma mark － 回退注销提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            // 取消
            break;
        }
        case 1:{
            // 确定
            [LoginManagerInstance() logout];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark － 登陆状态改变回调（LoginManagerDelegate）
- (void)loginStatusChanged:(LoginStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 重置tabbar和tabcontroller
        [self updateViewControllers];
        [self setupNavigationBar];
        if(status == LoginStatus_online) {
        }
    });
}
#pragma mark - 获取网关回调
- (void)getGateWaySuccess {
    // 获取网关成功,开始获取资源包
}
@end
