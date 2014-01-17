//
//  KKViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKViewController : UIViewController
@property (nonatomic, assign) BOOL viewDidAppearEver;

#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
#pragma mark - 界面布局
- (void)setupNavigationBar;
- (void)setupBackgroundView;
@end
