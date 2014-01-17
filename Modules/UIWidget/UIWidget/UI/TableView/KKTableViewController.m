//
//  KKTableViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-28.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKTableViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface KKTableViewController () <EGORefreshTableHeaderDelegate> {
    BOOL _reloading;
}

@end

@implementation KKTableViewController
@synthesize refreshHeaderView = _refreshHeaderView;
#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    //return YES;
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init {
    self = [super init];
    if(self) {
        // Logical initialize
        _reloading = NO;
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _reloading = NO;
    }
    return self;
}
- (void)dealloc {
    _reloading = NO;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // 下拉刷新
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    [self.tableView addSubview:_refreshHeaderView];
    [_refreshHeaderView release];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    _refreshHeaderView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据加载 (Data Source Loading / Reloading Methods)
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    //[self loadFromServer];
}
- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
    if(_refreshHeaderView)
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
- (void)refreshLastUpdatedDate {
    [_refreshHeaderView refreshLastUpdatedDate];
}
- (NSString *)getLastUpdatedText {
    NSString *lastUpdateText = @"lastUpdateText";
    return lastUpdateText;
}
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark - 上下拉界面回调 (EGORefreshTableHeaderDelegate)
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if(_refreshHeaderView == view)
        [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSString *)egoRefreshTableHeaderDataSourceLastUpdatedString:(EGORefreshTableHeaderView*)view{
    NSString *text = [self getLastUpdatedText];
    return text;
}
#pragma mark － 界面布局
- (void)setupNavigationBar {
    
}
- (void)setupBackgroundView {
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
