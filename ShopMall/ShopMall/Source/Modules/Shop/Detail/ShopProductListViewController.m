//
//  ShopProductListViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopProductListViewController.h"

@interface ShopProductListViewController () <ShopRequestOperatorDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    NSInteger _maxItem;
    BOOL _loadMore;
    BOOL _hasMore;
    BOOL _reloading;
    NSInteger _totalItems;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopProductListViewController

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
    // Do any additional setup after loading the view from its nib.
    [self resetParam];
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData:YES];
    if(IsNetWorkOK) {
        [_refreshHeaderView egoRefreshScrollViewRefresh:_tableView];
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
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    NSString *title = @"商户产品";

    if(_totalItems > 0) {
        title = [NSString stringWithFormat:@"商户产品(共%d条)", _totalItems];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupTableView {
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
#pragma mark - 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    NSArray *array = [ShopDataManager productListWithShopID:self.item.shopID];
    if(array) {
        NSInteger limit = array.count;
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
        self.items = [array subarrayWithRange:NSMakeRange(0, limit)];
    }
    else {
        self.items = [NSArray array];
    }
    if(isReloadView) {
        self.tableView.items = self.items;
        self.tableView.hasMore = _hasMore;
        [_tableView reloadData];
    }
}
- (void)resetParam {
    _maxItem = PageMaxRowValue;
    _reloading = NO;
    _hasMore = NO;
    _totalItems = -1;
}
#pragma mark - 列表界面回调 (SignTableViewDelegate)
- (void)didSelectMore:(ProductTableView *)tableView {
    if(IsNetWorkOK) {
        [self loadFromServer:YES];
    }
    
    // 假设已经入库每页最大纪录
    _maxItem += PageMaxRowValue;
    [self reloadData:YES];
}
- (void)tableView:(ProductTableView *)tableView didSelectProduct:(Product *)item {
    self.productName = item.productName;
    if([self.delegate respondsToSelector:@selector(viewController:didSelectedProductName:)]) {
        [self.delegate viewController:self didSelectedProductName:self.productName];
    }
    [self backAction:nil];
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
#pragma mark - 输入回调
- (void)textFieldDidEndEditing:(UITextField *)textField {
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.productName = textField.text;
    if([self.delegate respondsToSelector:@selector(viewController:didSelectedProductName:)]) {
        [self.delegate viewController:self didSelectedProductName:self.productName];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
#pragma mark - 协议请求
- (void)cancel {
    [self doneLoadingTableViewData];
    
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer:(BOOL)loadMore{
    // 获取商户签到列表
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    _loadMore = loadMore;
    if(loadMore) {
        // 加载更多
        return [self.requestOperator updateShopProduct:self.item.shopID curMaxRow:_maxItem];
    }
    else {
        // 刷最新
        return [self.requestOperator updateShopProduct:self.item.shopID curMaxRow:0];
    }
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopProduct:{
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
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopProduct:{
            [self setTopStatusText:@"获取商户产品列表失败"];
            break;
        }
        default:break;
    }
}
@end
