//
//  ShopRankListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopRankListViewController.h"
#import "ShopDetailViewController.h"
#import "ShopRankDetailViewController.h"

#import "RankListTableView.h"
#import "RankTableView.h"

#define KK_BUTTON_BAR_MAX_COUNT 3

@interface ShopRankListViewController () <ShopRequestOperatorDelegate, SignManagerDelegate, EGORefreshTableHeaderDelegate, RankTableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;

    RankTableView *_rankTableView;

    
    NSInteger _maxItem;
    BOOL _loadMore;
    BOOL _hasMore;
    BOOL _reloading;
    NSInteger _totalItems;
    BOOL _loadRankSucceed;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopRequestOperator *requestOperatorRank;

@property (nonatomic, retain) ShopCategory *shopCategory;
@property (nonatomic, retain) NSArray *shopCategories;
@property (nonatomic, retain) Rank *rank;
@property (nonatomic, retain) NSArray *ranks;

@end

@implementation ShopRankListViewController

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
    [self resetParam];
    
    [self setupKKDynamicView];
    [self setupShopTableView];
    self.rankListTableView.hidden = YES;
    
    // 加载分类列表
    [self setupTableView];
    [self reloadParamData:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SignInManagerInstance() addDelegate:self];

    [self setupKKButtonBar];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(IsNetWorkOK) {
        [self loadRankFromServer];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)titleAction:(id)sender {
    KKImageButton *button = (KKImageButton *)sender;
    // 收起原来的选择界面
    [_kkDynamicView hide:NO];
    _kkDynamicView.hidden = YES;
    // 当前按钮不是选中
    if(!button.selected)
        return;
    _kkDynamicView.hidden = NO;
    [_kkDynamicView reLoadView];
    [_kkDynamicView show:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    NSString *title = @"美食排行榜";
    if(!self.titleButton) {
        self.titleButton = [KKImageButton buttonWithType:UIButtonTypeCustom];
        [self.titleButton addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.titleButton sizeToFit];
    }

    self.navigationItem.titleView = self.titleButton;
}
- (void)setupTableView {
    NSInteger xBlanking = 20;
 
    // 分类列表
    if(!_rankTableView) {
        _rankTableView = [[RankTableView alloc] initWithFrame:CGRectMake(xBlanking, xBlanking, self.view.frame.size.width - 2 * xBlanking, self.view.frame.size.height - 2 * xBlanking)];
        _rankTableView.tableViewDelegate = self;
        _rankTableView.layer.cornerRadius = 3;
        _rankTableView.separatorInset = UIEdgeInsetsZero;
    }
    _rankTableView.frame = CGRectMake(xBlanking, xBlanking, self.view.frame.size.width - 2 * xBlanking, self.view.frame.size.height - 2 * xBlanking);
}
- (void)setupShopTableView {
    // 商户列表
    if(!_refreshHeaderView) {
        // 下拉刷新
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - _tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        [_tableView addSubview:_refreshHeaderView];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        _refreshHeaderView.lastUpdatedLabel.textColor = AppEnviromentInstance().globalUIEntitlement.egoRefreshTableHeaderViewColor;
        _refreshHeaderView.statusLabel.textColor = _refreshHeaderView.lastUpdatedLabel.textColor;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}
- (void)setupKKDynamicView {
    self.kkDynamicView.isDown = YES;
    self.kkDynamicView.hidden = YES;
    self.kkDynamicView.isShowOverlay = NO;
}
- (void)resetkkButtonBar {
    for(KKImageButton *kkButton in _kkButtonBar.items) {
        [kkButton setSelected:NO];
    }
    // 收起原来的选择界面
    [_kkDynamicView hide:NO];
    _kkDynamicView.hidden = YES;
}
- (void)setupKKButtonBar {
    [self resetkkButtonBar];
    self.kkButtonBar.items = [self customButtons];
}
- (NSArray *)customButtons {
    NSMutableArray *muableArray = [NSMutableArray array];
    KKImageButton *button;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopRankKKButtonBarItemImage ofType:@"png"]];
    UIImage *imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopRankKKButtonBarItemSelectedImage ofType:@"png"]];
    
    // 排行榜分类
    NSInteger maxCount = MIN(KK_BUTTON_BAR_MAX_COUNT, self.ranks.count);
    for(int i = 0; i < maxCount; i++) {
        button = [KKImageButton buttonWithType:UIButtonTypeCustom];
        [muableArray addObject:button];
        
        button.tag = i;
        button.kkImage = image;
        button.kkSelectedImage = imageSelected;
        [button setSelected:NO];
        
        Rank *rankItem = [self.ranks objectAtIndex:i];
        [button setTitle:rankItem.rankName forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 更多排行
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    [muableArray addObject:button];
    
    button.tag = maxCount;
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];

    [button setTitle:@"更多排行" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button = [muableArray objectAtIndex:0];
    [button setSelected:YES];
    
    return muableArray;
}
#pragma mark - 数据逻辑
- (void)resetParam {
    //    [ShopDataManager resetShopOrder];
    _maxItem = PageMaxRowValue;
    _loadMore = NO;
    _reloading = NO;
    _hasMore = NO;
    _totalItems = -1;
}
- (void)reloadParamData:(BOOL)isReloadView {
    [self reloadCategoryData];
    if(isReloadView) {
        if(self.shopCategory.categoryName.length > 0) {
            NSString *title = [NSString stringWithFormat:@"%@排行榜", self.shopCategory.categoryName];
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton sizeToFit];
        }
        
        [self setupKKButtonBar];
        _rankTableView.items = self.shopCategories;
        _rankTableView.category = self.shopCategory;
        [_rankTableView reloadData];
        
        _rankListTableView.items = self.ranks;
        [_rankListTableView reloadData];
        [self reloadData:YES];
    }
}
- (void)reloadCategoryData {
    self.shopCategories = [ShopDataManager categoryListHasRank];
    if(self.shopCategories.count > 0) {
        if(!self.shopCategory) {
            self.shopCategory = [self.shopCategories objectAtIndex:0];
        }
        self.ranks = [ShopDataManager rankList:self.shopCategory.categoryID];
        if(self.ranks.count > 0) {
            self.rank = [self.ranks objectAtIndex:0];
        }
    }
}
- (void)reloadData:(BOOL)isReloadView {
    NSArray *shops = [ShopDataManager shopList:[ShopDataManager cityCurrent].cityID categoryID:nil creditID:nil regionID:nil rankID:nil keyword:nil];
    if(shops) {
        NSInteger limit = shops.count;
        // mark 4 test
        limit = MIN(limit, _maxItem);
        if(_totalItems >= 0) {
            if(limit >= _maxItem && limit < _totalItems) {
                // 数据库条数大于可以显示的条数,并且小于请求返回的最大条数
                //if(limit >= _maxItem) {
                // 数据库条数大于可以显示的条数
                //limit = MIN(_maxItem, _totalItems);
                _hasMore = YES;
            }
            else {
                // 数据库条数大于可以协议返回的最大条数
                //limit = _totalItems;
                _hasMore = NO;
            }
        }
        else {
            // 无网络连接最多显示前14条
            /*_hasMore = NO;*/
            
            // 数据库条数大于可以显示的条数,并且小于请求返回的最大条数
            if(limit >= _maxItem) {
                _hasMore = YES;
            }
            else {
                _hasMore = NO;
            }
        }
        
        if(_totalItems >= 0) {
            // 最多显示不能超过请求返回的条数
            limit = MIN(limit, _totalItems);
        }
        self.items = [shops subarrayWithRange:NSMakeRange(0, limit)];
    }
    else {
        self.items = shops;
    }
    if(isReloadView) {
        _tableView.items = self.items;
        _tableView.hasMore = _hasMore;
        [_tableView reloadData];
    }
}
#pragma mark - 列表回调 ()
- (void)needReloadData:(UITableView *)tableView {
    if([tableView isKindOfClass:[ShopTableView class]]) {
        [self reloadData:NO];
    }
    else {
        [self reloadParamData:NO];
    }
}
- (void)tableView:(RankTableView *)tableView didSelectCategory:(ShopCategory *)item {
    self.shopCategory = item;
    [self setupNavigationBar];
    [self setupKKButtonBar];
    // 收起原来的选择界面
    [_kkDynamicView hide:NO];
    _kkDynamicView.hidden = YES;
    
    [self resetParam];
    [self reloadParamData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(ShopTableView *)tableView didSelectShop:(Shop *)item {
    // 点击商户进入商户详细
//    UIStoryboard *storyBoard = AppDelegate().storyBoard;
//    ShopDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopDetailViewController"];
    
    ShopDetailViewController *vc = [[ShopDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = item;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)didSelectMore:(ShopTableView *)tableView {
    if(IsNetWorkOK) {
        [self loadFromServer:YES];
    }
    // 假设已经入库每页最大纪录
    _maxItem += PageMaxRowValue;
    [self reloadData:YES];
}
- (void)tableView:(RankListTableView *)tableView didSelectRank:(Rank *)item {
    ShopRankDetailViewController *vc = [[ShopRankDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.rank = item;
    vc.category = self.shopCategory;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
#pragma mark - 数据加载 (Data Source Loading / Reloading Methods)
- (void)reloadTableViewDataSource {
	//  should be calling your tableviews data source model to reload
    [self loadFromServer:NO];
}
- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
    _reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isKindOfClass:[ShopTableView class]]) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([scrollView isKindOfClass:[ShopTableView class]]) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
#pragma mark - 上下拉界面回调 (EGORefreshTableHeaderDelegate)
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    if(_refreshHeaderView == view) {
        // 下拉刷新请求服务器,更新缓存
        [self resetParam];
        _reloading = YES;
        [self reloadTableViewDataSource];
    }
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView* )view {
    // should return if data source model is reloading
	return _reloading;
}
#pragma mark - 按钮弹出界面回调 (KKDynamicViewDelegate)
- (UIView *)viewForDetail:(KKDynamicView *)kkDynamicView {
    [self setupTableView];
    UIView *view = _rankTableView;
    return view;
}
- (void)didTouchOverlayContainView:(KKDynamicView *)dynamicContainView {
    // 重置分类栏
    [self kkButtonBarButtonAction:nil];
}
- (void)didShowDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration {
    // 显示分类栏背景,隐藏(列表,地图)
    _tableView.alpha = 1.0;
//    self.mapView.alpha = 1.0;
    [UIView animateWithDuration:duration animations:^{
        //动画的内容
        //_kkButtonBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _tableView.alpha = 0.0;
//        self.mapView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //动画结束
    }];
}
- (void)didHideDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration {
    // 隐藏分类栏背景,显示(列表,地图)
    _tableView.alpha = 0.0;
//    self.mapView.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        //动画的内容
        //_kkButtonBar.backgroundColor = [UIColor clearColor];
        _tableView.alpha = 1.0;
//        self.mapView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //动画结束
    }];
}
#pragma mark - 按钮事件
- (void)kkButtonBarButtonAction:(id)sender {
    KKImageButton *button = (KKImageButton *)sender;
    for(KKImageButton *kkButton in _kkButtonBar.items) {
        // 取消其他按钮选中状态
        if(button.tag != kkButton.tag) {
            [kkButton setSelected:NO];
        }
    }
    // 根据按钮,显示详细界面
    [button setSelected:YES];
    if(button.tag < KK_BUTTON_BAR_MAX_COUNT) {
        _rankListTableView.hidden = YES;
        _tableView.hidden = NO;
        // 分类排行
        self.rank = [self.ranks objectAtIndex:button.tag];
        //[self reloadData:YES];
        [self resetParam];
        [self reloadData:YES];
        [self loadFromServer:NO];
    }
    else {
        // 更多排行
        _rankListTableView.hidden = NO;
        _tableView.hidden = YES;
    }
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
    
    [self doneLoadingTableViewData];
    [self.kkLoadingView cancelLoading];
}
- (BOOL)loadFromServer:(BOOL)loadMore{
    // 获取商户列表
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    _loadMore = loadMore;
    if(loadMore) {
        // 加载更多
        if([self.requestOperator updateShopListByRank:self.shopCategory.categoryID rankID:self.rank.rankID curMaxRow:_maxItem]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        // 刷最新
        if([self.requestOperator updateShopListByRank:self.shopCategory.categoryID rankID:self.rank.rankID curMaxRow:0]) {
            _reloading = YES;
            return YES;
        }
        else {
            return NO;
        }
    }
    
    return NO;
}
- (void)cancelRank {
    if(self.requestOperatorRank) {
        [self.requestOperatorRank cancel];
    }
    
    [self.kkLoadingView cancelLoading];
}
- (BOOL)loadRankFromServer {
    [self cancelRank];
    
    if(_loadRankSucceed)
        return YES;
    
    [self.kkLoadingView startLoadingInView:self.view];
    
    if(!self.requestOperatorRank) {
        self.requestOperatorRank = [[ShopRequestOperator alloc] init];
        self.requestOperatorRank.delegate = self;
    }
    return [self.requestOperatorRank updateRankList];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopListByRank: {
            [self cancel];
            if(_loadMore) {
                //                // 返回成功,假设已经入库每页最大纪录
                //                _maxItem += PageMaxRowValue;
            }
            id value = [json objectForKey:TotalRecordCount];
            if(nil != value && [NSNull null] != value && [value isKindOfClass:[NSNumber class]]) {
                _totalItems = [value integerValue];
                [self setupNavigationBar];
            }
            [self reloadData:YES];
        }break;
        case ShopRequestOperatorStatus_UpdateRankList:{
            [self cancelRank];
            _loadRankSucceed = YES;
            [self reloadParamData:YES];
            [self loadFromServer:NO];
        }break;
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self setTopStatusText:error];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopListByRank:{
            [self cancel];
            break;
        }
        case ShopRequestOperatorStatus_UpdateRankList:{
            [self cancelRank];
        }break;
        default:break;
    }
}
@end
