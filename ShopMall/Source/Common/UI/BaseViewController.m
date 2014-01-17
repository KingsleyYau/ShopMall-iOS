//
//  BaseViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-4-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "BaseViewController.h"
//#import "MIT_MobileAppDelegate.h"
//#import "UIKit+MITAdditions.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

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
}

#pragma mark - 状态栏
- (void)setTopStatusText:(NSString *)text {
    [AppDelegate().myStatusBar showMessage:text];
}
#pragma mark － 界面布局
- (void)setupNavigationBar {
    [super setupNavigationBar];
}
- (void)setupBackgroundView {
    [super setupBackgroundView];
    self.view.backgroundColor = [UIColor colorWithIntRGB:230 green:220 blue:200 alpha:255];
//
//    self.view.backgroundColor = AppEnviromentInstance().globalUIEntitlement.baseViewControllerBackgroundColor;//[UIColor colorWithIntRGB:255 green:253 blue:228 alpha:255];
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
@end
