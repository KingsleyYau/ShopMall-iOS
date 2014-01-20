//
//  ShopCityViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCityViewController.h"

@interface ShopCityViewController () <ShopRequestOperatorDelegate>

@property (nonatomic, strong) NSArray *items;           // 所有城市
@property (nonatomic, strong) City *item;               // 当前城市
@property (nonatomic, retain) NSArray *itemSearch;      // 搜索城市
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopCityViewController

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
    [self setupSearchBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(IsNetWorkOK) {
        //[self refreshLocation];
        [self loadFromServer];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)backAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)gpsButton:(id)sender {
    // 点击当前城市
    City *city = [ShopDataManager cityGPS];
    [ShopDataManager cityChangeCurrent:city];
    [self backAction:nil];
}
- (void)setupSearchBar {
    if (self.kkSearchBar) {
        if(NSOrderedAscending == [[[UIDevice currentDevice] systemVersion] compare:@"7.0"]) {
            // ios 7 before
            self.kkSearchBar.tintColor = [UIColor colorWithIntRGB:204 green:170 blue:106 alpha:255];
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCitySearchBarBackground ofType:@"png"]];
        [self.kkSearchBar setBackgroundImage:image];
    }
    
    if (!self.searchController) {
        self.searchController = [[MITSearchDisplayController alloc] initWithSearchBar:self.kkSearchBar contentsController:self];
        self.searchController.delegate = self;
        
        if(!self.citySearchTableView) {
            self.citySearchTableView = [[CitySearchTableView alloc] initWithFrame:CGRectZero];
            self.citySearchTableView.tableViewDelegate = self;
            self.searchController.searchResultsTableView = self.citySearchTableView;
        }
    }
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"城市列表";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
//    self.navigationItem.title = @"城市列表";
    
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    UIButton *button = nil;
    
    // 左边边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationBackButton2 ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.leftBarButtonItems = array;
}
#pragma mark - 数据逻辑
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    self.items = [ShopDataManager cityRegionList];
    self.item = SignInManagerInstance().cityGPS;
    
    if(isReloadView) {
        // 当前城市
        NSString *cityTitle = @"";
        if(self.item) {
            cityTitle = [NSString stringWithFormat:@"%@", self.item.cityName];
        }
        else {
            cityTitle = @"无法定位";
        }
        [self.gpsButton setTitle:cityTitle forState:UIControlStateNormal];
        
        // 城市列表
        self.tableView.cityRegions = self.items;
        [self.tableView reloadData];
    }
}
- (void)reloadDataSearch:(NSString *)stringSearch {
    self.itemSearch = [ShopDataManager cityListBySearchKey:stringSearch];
    self.citySearchTableView.items = self.itemSearch;
    [self.citySearchTableView reloadData];
}
#pragma mark - 列表界面回调
- (void)needReloadData:(UITableView *)tableView {
    if([tableView isKindOfClass:[CitySearchTableView class]]) {
        // 搜索列表
    }
    else if([tableView isKindOfClass:[CityTableView class]]) {
        
    }
}
- (void)tableView:(CitySearchTableView *)tableView didSelectSearchCity:(City *)item {
    [ShopDataManager cityChangeCurrent:item];
    [self backAction:nil];
}
- (void)tableView:(CityTableView *)tableView didSelectCity:(City *)item {
    [ShopDataManager cityChangeCurrent:item];
    self.parentVC.shopCategoryManager.isAllSucceed = NO;
    [self backAction:nil];
}
- (void)tableView:(CityTableView *)tableView didSelectCityRegion:(CityRegion *)item {
    
}
#pragma mark - 搜索回调 (Search delegate)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 改变搜索条件时候
    [self reloadDataSearch:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击搜索
    [self reloadDataSearch:searchBar.text];
    [self.searchController hideSearchOverlayAnimated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 点击取消
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 开始输入
    [self reloadDataSearch:searchBar.text];
}
- (void)mapAction:(id)sender {
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
        self.requestOperator = nil;
    }
}
- (BOOL)loadFromServer {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator updateCityList];
}
- (BOOL)refreshLocation {
    SignInManager *signInManager = SignInManagerInstance();
    if([signInManager setupLocationManager]) {
        return YES;
    }
    return NO;
}
-(void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateCityList:{
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
-(void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateCityList:{
            [self setTopStatusText:error];
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
#pragma mark - 定位刷新回调 (SignManagerDelegate)
- (void)refreshFinish {
    [self reloadData:YES];
}
- (void)refreshError:(NSString *)error {
    //[self setTopStatusText:error];
}
@end
