//
//  ShopNewsMainViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsMainViewController.h"
#import "ShopNewsDetailViewController.h"

#import "ShopNewTypeManager.h"

#define TAG_BUTTON_SHOPNEWSTYPE     1000
#define TAG_BUTTON_CATEGORY         1001
#define TAG_BUTTON_CREDIT           1002
#define TAG_BUTTON_RANK             1003

@interface ShopNewsMainViewController () <ShopRequestOperatorDelegate, ShopNewTypeManagerDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;

    NSInteger _curTopItem;
    NSInteger _maxItem;
    BOOL _loadMore;
    BOOL _hasMore;
    BOOL _reloading;
    NSInteger _totalItems;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopNewTypeManager *shopNewTypeManager;

@property (nonatomic, retain) ShopNewsType *shopNewsType;
@property (nonatomic, retain) NSArray *shopNewsTypes;
@property (nonatomic, retain) ShopCategory *shopCategory;
@property (nonatomic, retain) NSArray *shopCategories;
@property (nonatomic, retain) Credit *credit;
@property (nonatomic, retain) NSArray *credits;
@end

@implementation ShopNewsMainViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shopCategory = nil;
        self.shopCategories = nil;
        self.credit = nil;
        self.credits = nil;
        [self resetParam];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self resetParam];
    
    self.shopNewTypeManager = [[ShopNewTypeManager alloc] init];
    self.shopNewTypeManager.delegate = self;
    
    [self setupBackgroundView];
    [self setupShopNewTableView];
    [self setupTableView];
    [self setupKKDynamicView];
    
    // 选择的详细列表
    [self reloadParamData:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupKKButtonBar];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadFromServer:NO];
    if(IsNetWorkOK) {
        if(!self.shopNewTypeManager.isAllSucceed) {
            [self.shopNewTypeManager loadAllListFromServer];
        }
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
#pragma mark - 界面布局
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"好讯";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupBackgroundView {
    [super setupBackgroundView];    
}
- (void)setupKKDynamicView {
    self.kkDynamicView.isDown = YES;
    self.kkDynamicView.hidden = YES;
    self.kkDynamicView.isShowOverlay = NO;
}
- (void)setupShopNewTableView {
    // 商户资讯列表
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
- (void)setupTableView {
    // 资讯分类列表
    if(!_shopNewsTypesTableView) {
        _shopNewsTypesTableView = [[ShopNewsTypesTableView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20)];
        _shopNewsTypesTableView.tableViewDelegate = self;
        _shopNewsTypesTableView.backgroundColor = [UIColor whiteColor];
        _shopNewsTypesTableView.layer.cornerRadius = 3;
    }
    _shopNewsTypesTableView.frame = CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20);
    // 分类列表
    if(!_categoryTableView) {
        _categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20)];
        _categoryTableView.tableViewDelegate = self;
        _categoryTableView.backgroundColor = [UIColor clearColor];
    }
    _categoryTableView.frame = CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20);
    // 积分列表
    if(!_creditTableView) {
        _creditTableView = [[CreditTableView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20)];
        _creditTableView.tableViewDelegate = self;
        _creditTableView.backgroundColor = [UIColor clearColor];
    }
    _creditTableView.frame = CGRectMake(20, 10, self.view.frame.size.width - 2 * 20, _tableView.frame.size.height - 20);
    
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
    NSString *buttonTitle;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopListKKButtonBarItemImage ofType:@"png" inDirectory:nil]];
    UIImage *imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopListKKButtonBarItemSelectedImage ofType:@"png" inDirectory:nil]];

    
    // 资讯分类
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_SHOPNEWSTYPE;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    [button setTitle:self.shopNewsType.shopNewsTypeName forState:(UIControlStateNormal)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [muableArray addObject:button];
    
    // 分类
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_CATEGORY;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    [button setTitle:self.shopCategory.categoryName forState:(UIControlStateNormal)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [muableArray addObject:button];
    
    // 积分
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_CREDIT;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    buttonTitle = self.credit.creditName;
    [button setTitle:buttonTitle forState:(UIControlStateNormal)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [muableArray addObject:button];
    
//    // 排行榜方式
//    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
//    button.tag = TAG_BUTTON_RANK;
//    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    buttonImage = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:KKButtonBarItemImage]];
//    button.kkImage = buttonImage;
//    buttonImage = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:KKButtonBarItemSelectedImage]];
//    button.kkSelectedImage = buttonImage;
//    [button setSelected:NO];
//    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
//    buttonTitle = @"默认排序";
//    if(self.shopSortType) {
//        buttonTitle = self.shopSortType.sortName;
//    }
//    [button setTitle:buttonTitle forState:(UIControlStateNormal)];
//    button.contentMode = UIViewContentModeScaleAspectFit;
//    [muableArray addObject:button];
    
    return muableArray;
}
#pragma mark - 界面逻辑
- (void)reloadCategoryData {
    if(!self.shopNewsType) {
        self.shopNewsType = [ShopDataManager topShopNewsType];
    }
    self.shopNewsTypes = [ShopDataManager shopNewsTypeList];

    if(!self.shopCategory) {
        self.shopCategory = [ShopDataManager topCategory];
    }
    self.shopCategories = [ShopDataManager categoryList];

    if(!self.credit) {
        self.credit = [ShopDataManager topCredit];
    }
    self.credits = [ShopDataManager creditList];

}
- (void)reloadData:(BOOL)isReloadView {
    NSArray *shopNews = [ShopDataManager shopNewsList:[ShopDataManager cityCurrent].cityID categoryID:self.shopCategory.categoryID creditID:self.credit.creditID shopNewsTypeId:self.shopNewsType.shopNewsTypeID keyword:nil shopId:nil];
    if(shopNews) {
        NSInteger limit = shopNews.count;
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
        if(limit > 0) {
            _tipsLabel.hidden = YES;
        }
        else {
            _tipsLabel.hidden = NO;
        }
        self.items = [shopNews subarrayWithRange:NSMakeRange(0, limit)];
    }
    else {
        self.items = shopNews;
    }
    if(isReloadView) {
        _tableView.items = self.items;
        _tableView.hasMore = _hasMore;
        [_tableView reloadData];
    }
}
- (void)reloadParamData:(BOOL)isReloadView {
    [self reloadCategoryData];
    if(isReloadView) {
        _shopNewsTypesTableView.items = self.shopNewsTypes;
        [_shopNewsTypesTableView reloadData];
        _categoryTableView.itemsParent = self.shopCategories;
        [_categoryTableView reloadData];
        _creditTableView.items = self.credits;
        [_creditTableView reloadData];
    }
}
#pragma mark - 协议请求
- (void)resetParam {
    //[ShopDataManager clearShopNews];
    _maxItem = PageMaxRowValue;
    _loadMore = NO;
    _reloading = NO;
    _hasMore = NO;
    _totalItems = -1;
    
//    _tableView.items = nil;
//    [_tableView reloadData];
}
- (void)cancel {
    [self doneLoadingTableViewData];
    
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
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
        if([self.requestOperator updateShopNewsList:self.shopCategory.categoryID shopTypeID:self.shopNewsType.shopNewsTypeID creditID:nil searchKey:nil curMaxRow:_maxItem]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        // 刷最新
        if([self.requestOperator updateShopNewsList:self.shopCategory.categoryID shopTypeID:self.shopNewsType.shopNewsTypeID creditID:nil searchKey:nil curMaxRow:0]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
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
    // 收起原来的选择界面
    [_kkDynamicView hide:NO];
    _kkDynamicView.hidden = YES;
    
    // 当前按钮不是选中
    if(!button.selected)
        return;
    // 根据按钮,显示详细界面
    _kkDynamicView.tag = button.tag;
    _kkDynamicView.hidden = NO;
    [_kkDynamicView reLoadView];
    [_kkDynamicView show:YES];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopNewsList: {
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
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
    //[self showNetworkError];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopNewsList:{
            break;
        }
        default:break;
    }
}
#pragma mark - 列表回调 ()
- (void)needReloadData:(UITableView *)tableView {
    if([tableView isKindOfClass:[ShopNewsTableView class]]) {
        [self reloadData:NO];
    }
    else {
        [self reloadParamData:NO];
    }
}
- (void)didSelectMore:(ShopNewsTableView *)tableView {
    if(IsNetWorkOK) {
        [self loadFromServer:YES];
    }
    // 假设已经入库每页最大纪录
    _maxItem += PageMaxRowValue;
    [self reloadData:YES];

}
- (void)tableView:(ShopNewsTableView *)tableView didSelectShopNews:(ShopNews *)item {
    ShopNewsDetailViewController *vc = [[ShopNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = item;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)tableView:(ShopNewsTypesTableView *)tableView didSelectShopNewsType:(ShopNewsType *)item{
    self.shopNewsType = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(CategoryTableView *)tableView didSelectShopCategory:(ShopCategory *)item {
    self.shopCategory = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(CategoryTableView *)tableView didSelectShopParentCategory:(ShopCategory *)item {
}
- (void)tableView:(CreditTableView *)tableView didSelectCredit:(Credit *)item {
    self.credit = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
#pragma mark - 按钮弹出界面回调 (KKDynamicViewDelegate)
- (UIView *)viewForDetail:(KKDynamicView *)kkDynamicView {
    UIView *view = nil;
    [self setupTableView];
    switch (kkDynamicView.tag) {
        case TAG_BUTTON_SHOPNEWSTYPE: {
            // 资讯分类
            _shopNewsTypesTableView.type = self.shopNewsType;
            [_shopNewsTypesTableView reloadData];
            view = _shopNewsTypesTableView;
            break;
        }
        case TAG_BUTTON_CATEGORY:{
            // 商户分类
            _categoryTableView.category = self.shopCategory;
            [_categoryTableView reloadData];
            view = _categoryTableView;
            break;
        }
        case TAG_BUTTON_CREDIT:{
            // 积分分类
            _creditTableView.credit = self.credit;
            view = _creditTableView;
            break;
        }
        default:
            break;
    }
    return view;
}
- (void)didTouchOverlayContainView:(KKDynamicView *)dynamicContainView {
    // 重置分类栏
    [self kkButtonBarButtonAction:nil];
}
- (void)didShowDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration {
    // 显示分类栏背景,隐藏(列表)
    _tableView.alpha = 1.0;
    [UIView animateWithDuration:duration animations:^{
        //动画的内容
        //_kkButtonBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //动画结束
    }];
}
- (void)didHideDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration {
    // 隐藏分类栏背景,显示(列表)
    _tableView.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        //动画的内容
        //_kkButtonBar.backgroundColor = [UIColor clearColor];
        _tableView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //动画结束
    }];
}
#pragma mark - 错误提示
- (void)showNetworkError {
    // 弹出提示
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NetWorkErrorTitle message:NetWorkError delegate:self cancelButtonTitle:MessageOK otherButtonTitles:nil];
//    [alert show];
}
#pragma mark - 分类下载回调 (ShopNewTypeManagerDelegate)
- (void)updateFinished:(ShopNewTypeManager *)shopCategoryManager {
    //[self setTopStatusText:@"刷新资讯分类成功"];
    [self reloadParamData:YES];
    [self reloadData:NO];
}
- (void)updateFail:(ShopNewTypeManager *)shopCategoryManager {
    //[self setTopStatusText:@"刷新资讯分类失败"];
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
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
@end
