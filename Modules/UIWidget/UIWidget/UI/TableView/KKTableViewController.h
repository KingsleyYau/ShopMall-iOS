//
//  KKTableViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-28.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGORefreshTableHeaderView;
@interface KKTableViewController : UITableViewController {
    EGORefreshTableHeaderView *_refreshHeaderView;
}
#pragma mark - 重载函数
/*
 * 下拉成功,触发数据加载,可以在这里发送请求
 */
- (void)reloadTableViewDataSource;
/*
 * 取消加载中界面
 */
- (void)doneLoadingTableViewData;
/*
 * 马上刷新加载中的提示
 */
- (void)refreshLastUpdatedDate;
/*
 * 重载返回加载中的提示
 */
- (NSString *)getLastUpdatedText;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
- (void)setupNavigationBar;
- (void)setupBackgroundView;

@property (nonatomic, assign, readonly) EGORefreshTableHeaderView *refreshHeaderView;
@end
