//
//  ShopDetailViewController.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopMainViewController.h"
#import "ShopCityViewController.h"
#import "ShopRankListViewController.h"
#import "ShopCategoryViewController.h"
#import "ShopCreditViewController.h"
#import "ShopListNearViewController.h"
#import "ShopSearchViewController.h"

#import "CommonTableViewCell.h"

#define TAG_ALERT_LOCATION   1000
#define TAG_ALERT_CITY       1001

typedef enum {
    RowTypeCategory,
    RowTypeSearch,
} RowType;

typedef enum {
    PushTypeNone = 0,
    PushTypeCategory,
    PushTypeMore,
    PushTypeSearch,
}PushType;

@interface ShopMainViewController () <ShopRequestOperatorDelegate, SignManagerDelegate, MITSearchDisplayDelegate, UISearchBarDelegate>{
    BOOL _reloading;
    PushType _pushType;
}
@property (nonatomic, retain) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;

@property (nonatomic, assign) NSInteger categoryTag;

@end

@implementation ShopMainViewController
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
    
    self.categoryTag = -1;

    [self setupLoadingView];
    [self setupSearchBar];
    [self setupGridView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SignInManagerInstance() addDelegate:self];
    
    [self reloadIconGrid];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(IsNetWorkOK && [ShopDataManager cityCurrent]) {
        // 加载分类 积分 排行榜
        [self loadAllCategory];
        // 定位
        [SignInManagerInstance() setupLocationManager];
        // 加载附近顶层行业
        //[self loadNearCategoryFromServer];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    [self cancelLoadCategory];
    _pushType = PushTypeNone;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (IBAction)areaButton:(id)sender {
    // 点击地区
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    ShopCityViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopCityViewController"];
    vc.parentVC = self;
    KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.translucent = NO;
    [self presentModalViewController:nvc animated:YES];
}
- (IBAction)rankButton:(id)sender {
    // 点击排行榜
    ShopRankListViewController *vc = [[ShopRankListViewController alloc] initWithNibName:nil bundle:nil];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)pointButton:(id)sender {
    // 点击积分
    ShopCreditViewController *vc = [[ShopCreditViewController alloc] initWithNibName:nil bundle:nil];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)iconGridButtonAction:(id)sender {
    // 点击分类
    if([ShopDataManager cityGPS] == nil) {
        // 无法定位
        NSString *stringMsg = [NSString stringWithFormat:@"请在 “设置->定位服务” 中确认 “定位” 和 ”好去处“ 是否未开启状态"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"定位未开启" message:stringMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"帮助", nil];
        alert.tag = TAG_ALERT_LOCATION;
        [alert show];
    }
    else if([[ShopDataManager cityCurrent].cityID intValue] == [[ShopDataManager cityGPS].cityID intValue]) {
        BadgeButton *aButton = sender;
        self.categoryTag = aButton.tag;
        
        // 当前定位城市和选择的城市是同一个城市
        _pushType = PushTypeCategory;
        [self loadAllCategory];
    }
    else {
        // 当前定位城市和选择的城市不是同一个城市
        NSString *stringMsg = [NSString stringWithFormat:@"您当前选择的城市是%@,如需要使用附近功能,请切换置%@", [ShopDataManager cityCurrent].cityName, [ShopDataManager cityGPS].cityName];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:stringMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
        alert.tag = TAG_ALERT_CITY;
        [alert show];
    }
}
- (IBAction)iconGridMoreButtonAction:(id)sender {
    // 点击更多
    _pushType = PushTypeMore;
//    self.shopCategoryManager.isAllSucceed = NO;
    [self loadAllCategory];
}
- (void)setupSearchBar {
    if (!self.kkSearchBar) {
        CGRect searchFrame = CGRectZero;
        self.kkSearchBar = [[KKSearchBar alloc] initWithFrame:searchFrame];
        self.kkSearchBar.placeholder = @"输入商户名称搜索";
        [self.kkSearchBar setBackgroundImage:nil];
    }

    if (!self.searchController) {
        self.searchController = [[MITSearchDisplayController alloc] initWithSearchBar:self.kkSearchBar contentsController:self];
        self.searchController.delegate = self;
        self.searchController.searchResultsTableView = nil;
    }
}
- (void)setupGridView {
    if(!self.iconGridView) {
        self.iconGridView = [[IconGrid alloc] initWithFrame:CGRectZero];
        self.iconGridView.delegate = self;
        self.iconGridView.backgroundColor = [UIColor clearColor];
        [self.iconGridView setHorizontalMargin:5.0 vertical:10.0];
        [self.iconGridView setHorizontalPadding:5.0 vertical:10.0];
        [self.iconGridView setMinimumColumns:3 maximum:3];
    }
    self.iconGridView.frame = CGRectMake(20, 0, self.tableView.frame.size.width - 40, 0);
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    
    self.navigationItem.titleView = self.kkSearchBar;
    
    // 左边边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationImageMainLogo ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    [array addObject:barButtonItem];
    
    self.navigationItem.leftBarButtonItems = array;
}
#pragma mark - 数据逻辑
- (void)reloadCity {
    NSString *currentCity = @"当前城市";
    if([ShopDataManager cityCurrent].cityName.length > 0) {
        currentCity = [ShopDataManager cityCurrent].cityName;
    }
    [self.areaButton setTitle:currentCity forState:UIControlStateNormal];
}
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    [self reloadCity];
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 分类九宫格
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, self.iconGridView.frame.size.height);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCategory] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 搜索全城
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeSearch] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    self.tableViewArray = array;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (void)reloadIconGrid {
    UIFont *font = [UIFont boldSystemFontOfSize:11];
    NSMutableArray *buttons = [NSMutableArray array];
    NSInteger viewHeight = 64;
    NSInteger viewWidth = 64;
    //    NSInteger totalUnReadCount = 0;
    
    UIImage *image = nil;
    //    UILabel *titleLabel = nil;
    //    BadgeButton *aButton = nil;
    
    // 显示当前城市的顶层行业
    NSArray *array = [ShopDataManager categoryWithCityId:[ShopDataManager cityCurrent].cityID];
    self.categoryArray = (array.count > 8)? [array subarrayWithRange:NSMakeRange(0,8)]:array;
    for(int i = 0; i<self.categoryArray.count; i++) {
        ShopCategory *category = [self.categoryArray objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 81, 81)];
        
        UIImageView *imageViewHyf = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewHeight + 3, 18, 14)];
        [view addSubview:imageViewHyf];
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryHyfImage ofType:@"png"]];
        imageViewHyf.image = image;
        
        UILabel *labelHyf = [[UILabel alloc] initWithFrame:CGRectMake(20, viewHeight + 3, 18, 14)];
        [view addSubview:labelHyf];
        labelHyf.backgroundColor = [UIColor clearColor];
        labelHyf.textAlignment = NSTextAlignmentCenter;
        labelHyf.font = font;
        labelHyf.text = [NSString stringWithFormat:@"%@", category.hyfShopCount];
        
        UIImageView *imageViewDsf = [[UIImageView alloc] initWithFrame:CGRectMake(40, viewHeight + 3, 18, 14)];
        [view addSubview:imageViewDsf];
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryDsfImage ofType:@"png"]];
        imageViewDsf.image = image;
        
        UILabel *labelDsf = [[UILabel alloc] initWithFrame:CGRectMake(60, viewHeight + 3, 18, 14)];
        [view addSubview:labelDsf];
        labelDsf.backgroundColor = [UIColor clearColor];
        labelDsf.textAlignment = NSTextAlignmentCenter;
        labelDsf.font = font;
        labelDsf.text = [NSString stringWithFormat:@"%@", category.dsfShopCount];
        
        RequestImageView *logoView = [[RequestImageView alloc] init];
        [view addSubview:logoView];
        logoView.delegate = self;
        logoView.frame = CGRectMake(9, 0, viewWidth, viewHeight);
        logoView.imageUrl = category.logoImage.path;
        logoView.imageData = category.logoImage.data;
        logoView.contentType = category.logoImage.contentType;
        [logoView loadImage];
        
        BadgeButton *aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:aButton];
        aButton.contentMode = UIViewContentModeScaleAspectFill;
        aButton.frame = CGRectMake(9, 0, viewWidth, viewHeight);
        aButton.tag = i;
        [aButton addTarget:self action:@selector(iconGridButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:view];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 81, 81)];
    
    BadgeButton *aButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:aButton];
    aButton.contentMode = UIViewContentModeScaleAspectFill;
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryMoreButton ofType:@"png"]];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(9, 0, 64, 64);
    [aButton addTarget:self action:@selector(iconGridMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addObject:view];
    
    // TODO: 重置九宫格
    [self setupGridView];
    self.iconGridView.icons = buttons;
    [self.iconGridView setNeedsLayout];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        count = 1;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        number = self.tableViewArray.count;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        height = viewSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;

    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeCategory:{
                // 九宫格分类
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowTypeCategory"];
                if(!cell) {
                    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RowTypeCategory"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    
                    [self.iconGridView removeFromSuperview];
                    [cell.contentView addSubview:self.iconGridView];
                    [self.iconGridView setNeedsLayout];
                }

                result = cell;
                break;
            }
            case RowTypeSearch:{
                // 搜全城
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategorySearchLogo ofType:@"png" inDirectory:nil]];
                [cell.leftImageView setImage:image];
                
                cell.titleLabel.text = @"搜翻天";
                
                image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopSearchAccessViewImage ofType:@"png" inDirectory:nil]];
                [cell.accessoryImageView setImage:image];
                cell.accessoryImageView.hidden = NO;
                
                break;
            }
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView isEqual:self.tableView]){
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        
        // TODO:大小
        CGSize viewSize;
        NSValue *value = [dictionarry valueForKey:ROW_SIZE];
        [value getValue:&viewSize];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeSearch:{
                // 搜全城
                _pushType = PushTypeSearch;
//                self.shopCategoryManager.isAllSucceed = NO;
                [self loadAllCategory];
            }break;
            default:break;
        }
    }
}
#pragma mark - (异步下载图片控件回调)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    File *file = [ShopDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
    }
}
- (void)iconGridFrameDidChange:(IconGrid *)iconGrid {
    [self reloadData:YES];
}
#pragma mark - 定位回调 (SignManagerDelegate)
- (void)refreshFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 加载附近顶层行业
        [self loadNearCategoryFromServer];
    });
}
- (void)refreshError:(NSString *)error {
}
#pragma mark - 分类下载回调 (ShopCategoryManagerDelegate)
- (void)pushViewController {
    switch (_pushType) {
        case PushTypeNone:{
            
        }break;
        case PushTypeCategory:{
            if(self.categoryTag < self.categoryArray.count) {
                // 点击本地分类
                ShopCategory *category = [self.categoryArray objectAtIndex:self.categoryTag];
                UIStoryboard *storyBoard = AppDelegate().storyBoard;
                ShopListNearViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopListNearViewController"];
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                vc.shopCategory = category;
                [nvc pushViewController:vc animated:YES gesture:YES];
            }
        }break;
        case PushTypeMore:{
            // 点击更多
            ShopCategoryViewController *vc = [[ShopCategoryViewController alloc] initWithNibName:nil bundle:nil];
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            [nvc pushViewController:vc animated:YES gesture:YES];

        }break;
        case PushTypeSearch:{
            // 点击搜翻天
            ShopSearchViewController *vc = [[ShopSearchViewController alloc] initWithNibName:nil bundle:nil];
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            [nvc pushViewController:vc animated:YES gesture:YES];
        }break;
        default:
            break;
    }
    _pushType = PushTypeNone;
}
- (void)updateFinished:(ShopCategoryManager *)shopCategoryManager {
    [self cancelLoadCategory];
    [self pushViewController];
}
- (void)updateFail:(ShopCategoryManager *)shopCategoryManager {
    [self setTopStatusText:@"刷新商户分类失败"];
    [self cancelLoadCategory];
    [self pushViewController];
}
#pragma mark - 协议请求
- (void)cancelLoadCategory {
    [self.kkLoadingView cancelLoading];
    [self.shopCategoryManager cancel];
}
- (void)loadAllCategory {
    [self cancelLoadCategory];
    if(!self.shopCategoryManager) {
        self.shopCategoryManager = [[ShopCategoryManager alloc] init];
        self.shopCategoryManager.delegate = self;
    }
    
    [self.kkLoadingView startLoadingInView:self.view];
    [self.shopCategoryManager loadAllListFromServer];
}
- (void)cancel {
    _reloading = NO;
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadNearCategoryFromServer {
    // 当前城市附近行业分类
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    _reloading = YES;

    return [self.requestOperator updateCityCategoryList];
}
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateCityCategory:{
            [self reloadIconGrid];
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:@"刷新附近行业分类失败"];
    switch(type){
        case ShopRequestOperatorStatus_UpdateCityCategory:{
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
#pragma mark - 搜索回调 (Search delegate)
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击搜索
//    ShopListNearViewController *vc = [[[ShopListNearViewController alloc] init] autorelease];
//    vc.stringSearch = searchBar.text;
//    vc.isRegion = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    searchBar.text = nil;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 点击取消
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 开始输入
}
- (void)mapAction:(id)sender {
}
#pragma mark - 弹出界面回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case TAG_ALERT_LOCATION:{
            break;
        }
        case TAG_ALERT_CITY:{
            switch (buttonIndex) {
                case 0:{
                    // 取消
                    break;
                }
                case 1:{
                    // 改变当前城市
                    [ShopDataManager cityChangeCurrent:[ShopDataManager cityGPS]];
                    [self reloadCity];
                    // 加载附近顶层行业
                    [self loadNearCategoryFromServer];
                    // 重新加载分类和商区
                    self.shopCategoryManager.isAllSucceed = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
@end
