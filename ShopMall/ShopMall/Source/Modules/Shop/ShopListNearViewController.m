//
//  ShopListNearViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopListNearViewController.h"
#import "ShopDetailViewController.h"

#import "SelfMapAnnotation.h"
#import "ShopMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"
#import "ShopAnnotationCell.h"

#define KK_BUTTON_BAR_HEIGHT 53
#define KK_BUTTON_BAR_HEIGHT_TRANSPARENT
#define MAP_BAR_HEIGHT 44
#define KK_DISTANCE_BUTTON_BAR_HEIGHT 105
#define LOCATION_LAEBL_HEIGHT 22

#define TAG_BUTTON_DISTANCE     1000
#define TAG_BUTTON_CATEGORY     1001
#define TAG_BUTTON_CREDIT       1002
#define TAG_BUTTON_SORT         1003
#define TAG_BUTTON_REGION       1004

#define TAG_VIEW_SHOPCELL      1001
#define TAG_BUTTON_DISTANCE_DETAIL     10000

typedef enum{
    DISTANCE_500 = 0,
    DISTANCE_1000,
    DISTANCE_2000,
    DISTANCE_5000,
    DISTANCE_ALL,
    DISTANCE_COUNT,
}DISTANCE;

@interface ShopListNearViewController () <ShopRequestOperatorDelegate, SignManagerDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    // 弹出分类选择界面
    RegionTableView *_regionTableView;
    CategoryTableView *_categoryTableView;
    CreditTableView *_creditTableView;
    SortTableView *_sortTableView;
    
    KKButtonBar *_kkButtonBarDistance;
    
    DISTANCE _curDistance;
    NSInteger _curTopItem;
    NSInteger _maxItem;
    BOOL _loadMore;
    BOOL _hasMore;
    BOOL _reloading;
    NSInteger _totalItems;
    BOOL _isMapViewHidden;
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSArray *itemsAonntation;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, retain) NSArray *regions;
@property (nonatomic, retain) NSArray *shopCategories;
@property (nonatomic, retain) NSArray *credits;
@property (nonatomic, retain) ShopSortType *shopSortType;
@property (nonatomic, retain) NSArray *shopSortTypes;

@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) SelfMapAnnotation *selfAnnotation;
@end

@implementation ShopListNearViewController

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
    _curDistance = [[ShopDataManager currentInfo].curDistanceType integerValue];
    _isMapViewHidden = YES;
    
    [self resetParam];
    
    [self setupKKDynamicView];
    [self setupShopTableView];
    [self setupLoadingView];
    
    // 加载距离,分类,积分,排序等选择的详细列表
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
    
    self.locationLabel.text = SignInManagerInstance().locationInfoString;
    
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
- (void)setupMapView {
    [super setupMapView];
    self.mapView.hidden = _isMapViewHidden;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    NSString *title = @"商户列表";
    if(self.isRegion) {
        title = @"商户列表";
    }
    else {
        title = @"附近商户";
    }
    if(_totalItems > 0) {
        title = [NSString stringWithFormat:@"%@(共%d家)", title, _totalItems];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    
    // 右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationMapGuideButton ofType:@"png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupTableView {
    NSInteger xBlanking = 20;
    // 商区列表
    if(!_regionTableView) {
        _regionTableView = [[RegionTableView alloc] initWithFrame:CGRectMake(xBlanking, xBlanking, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking)];
        _regionTableView.tableViewDelegate = self;
        _regionTableView.backgroundColor = [UIColor clearColor];
        _regionTableView.layer.cornerRadius = 3;
    }
    _regionTableView.frame = CGRectMake(xBlanking, 0, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking);
    // 分类列表
    if(!_categoryTableView) {
        _categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(xBlanking, xBlanking, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking)];
        _categoryTableView.tableViewDelegate = self;
        _categoryTableView.backgroundColor = [UIColor clearColor];
        _categoryTableView.layer.cornerRadius = 3;
    }
    _categoryTableView.frame = CGRectMake(xBlanking, 0, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking);
    // 积分列表
    if(!_creditTableView) {
        _creditTableView = [[CreditTableView alloc] initWithFrame:CGRectMake(20, xBlanking, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking)];
        _creditTableView.tableViewDelegate = self;
        _creditTableView.backgroundColor = [UIColor clearColor];
    }
    _creditTableView.frame = CGRectMake(xBlanking, 0, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking);
    // 排序列表
    if(!_sortTableView) {
        _sortTableView = [[SortTableView alloc] initWithFrame:CGRectMake(xBlanking, xBlanking, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking)];
        _sortTableView.tableViewDelegate = self;
        _sortTableView.backgroundColor = [UIColor whiteColor];
        _sortTableView.layer.cornerRadius = 3;
    }
    _sortTableView.frame = CGRectMake(xBlanking, 0, self.view.frame.size.width - 2 * xBlanking, _tableView.frame.size.height - 2 * xBlanking);
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
    NSString *buttonTitle;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopListKKButtonBarItemImage ofType:@"png"]];
    UIImage *imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopListKKButtonBarItemSelectedImage ofType:@"png"]];
    
    if(self.isRegion) {
        // 搜索界面进入,显示商区
        self.distance = 10000000;
        button = [KKImageButton buttonWithType:UIButtonTypeCustom];
        button.tag = TAG_BUTTON_REGION;
        [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
        button.kkImage = image;
        button.kkSelectedImage = imageSelected;
        [button setSelected:NO];
        [button setTitle:self.region.regionName forState:(UIControlStateNormal)];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [muableArray addObject:button];
    }
    else {
        // 分类界面进入
        // 距离
        button = [KKImageButton buttonWithType:UIButtonTypeCustom];
        button.tag = TAG_BUTTON_DISTANCE;
        [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
        button.kkImage = image;
        button.kkSelectedImage = imageSelected;
        [button setSelected:NO];
        switch (_curDistance) {
            case DISTANCE_500:{
                self.distance = 500;
                [button setTitle:@"500" forState:(UIControlStateNormal)];
                break;
            }
            case DISTANCE_1000:{
                self.distance = 1000;
                [button setTitle:@"1km" forState:(UIControlStateNormal)];
                break;
            }
            case DISTANCE_2000:{
                self.distance = 2000;
                [button setTitle:@"2km" forState:(UIControlStateNormal)];
                break;
            }
            case DISTANCE_5000:{
                self.distance = 5000;
                [button setTitle:@"5km" forState:(UIControlStateNormal)];
                break;
            }
            default: {
                self.distance = 10000000;
                [button setTitle:@"全城" forState:(UIControlStateNormal)];
                break;
            }
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [muableArray addObject:button];
    }
    
    
    // 分类
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_CATEGORY;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    [button setTitle:self.shopCategory.categoryName forState:(UIControlStateNormal)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
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
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [muableArray addObject:button];
    
    // 排序方式
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_SORT;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    buttonTitle = self.shopSortType.sortName;
    [button setTitle:buttonTitle forState:(UIControlStateNormal)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [muableArray addObject:button];
    
    return muableArray;
}
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (void)setupKKButtonBarDistance {
    if(!_kkButtonBarDistance) {
        _kkButtonBarDistance = [[KKButtonBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KK_DISTANCE_BUTTON_BAR_HEIGHT)];
        _kkButtonBarDistance.delegate = self;
        _kkButtonBarDistance.isVertical = NO;
    }
    _kkButtonBarDistance.frame = CGRectMake(0, 0, self.view.frame.size.width, KK_DISTANCE_BUTTON_BAR_HEIGHT);
    
    NSMutableArray *muableArray = [NSMutableArray array];
    for(int i = 0; i < DISTANCE_COUNT; i++) {
        KKImageButton *button = [KKImageButton buttonWithType:UIButtonTypeCustom];
        button.tag = TAG_BUTTON_DISTANCE_DETAIL + i;
        [button addTarget:self action:@selector(kkButtonBarDistanceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = [NSString stringWithFormat:@"%@%d", ShopListDistanceImage, i];
        UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        button.kkImage = buttonImage;
        imageName = [NSString stringWithFormat:@"%@%d", ShopListDistanceSelectedImage, i];
        buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        button.kkSelectedImage = buttonImage;
        //        [button setTitle:[NSString stringWithFormat:@"%d", 500 * (i+1)] forState:(UIControlStateNormal)];
        if(_curDistance == i) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
        [muableArray addObject:button];
    }
    _kkButtonBarDistance.items = muableArray;
}

- (void)refreshMapBar:(KKListItemSelector *)kkListItemSelector {
    //    kkListItemSelector.buttonPre.enabled = YES;
    //    if(_curTopItem + PageMaxRowValue == self.items.count && _hasMore == YES) {
    //        // 刚好已经显示全部本地数据,并且有更多
    ////        [self loadFromServer:YES];
    //    }
    //    else if(_curTopItem + PageMaxRowValue < self.items.count) {
    if(_curTopItem + PageMaxRowValue < self.items.count) {
        // 还可以本地翻页
        _curTopItem += PageMaxRowValue;
        kkListItemSelector.labelText.text = [NSString stringWithFormat:@"第%d-%d家", _curTopItem + 1, MIN(_curTopItem + PageMaxRowValue, self.items.count + 1)];
        [self setAnnotions];
        
        // 翻页后没有更多
        if(_curTopItem + PageMaxRowValue > self.items.count) {
            kkListItemSelector.buttonNext.enabled = NO;
        }
    }
    else if(_hasMore != YES){
        // 已经没有更多
        kkListItemSelector.buttonNext.enabled = NO;
    }
}
- (void)mapAction:(id)sender {
    if(_isMapViewHidden) {
        // 翻页到最近
        NSArray *indexs = [_tableView indexPathsForVisibleRows];
        if(indexs.count > 0) {
            _curTopItem = ((NSIndexPath *)[indexs objectAtIndex:0]).row / PageMaxRowValue * PageMaxRowValue;
            
            if(self.items.count > 0) {
                _kkListItemSelector.labelText.text = [NSString stringWithFormat:@"第%d-%d家", _curTopItem + 1, MIN(_curTopItem + PageMaxRowValue, self.items.count)];
            }
            else {
                _kkListItemSelector.labelText.text = @"没有商铺";
            }
        }
        
        _kkListItemSelector.buttonPre.enabled = YES;
        _kkListItemSelector.buttonNext.enabled = YES;
        if(_curTopItem == 0) {
            _kkListItemSelector.buttonPre.enabled = NO;
        }
        if(_curTopItem + PageMaxRowValue >= self.items.count && _hasMore == NO) {
            // 已经是最后一页
            _kkListItemSelector.buttonNext.enabled = NO;
        }
        
        // 显示地图
        _isMapViewHidden = NO;
        self.mapView.hidden = NO;
        _tableView.hidden = NO;
        _locationLabel.hidden = NO;
        
        self.mapView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView.frame = CGRectMake(0, KK_BUTTON_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - KK_BUTTON_BAR_HEIGHT);
        _locationLabel.frame = CGRectMake(0, self.view.frame.size.height - LOCATION_LAEBL_HEIGHT, self.view.frame.size.width, LOCATION_LAEBL_HEIGHT);
        
        [UIView animateWithDuration:0.5 animations:^{
            //动画的内容
            self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _tableView.frame = CGRectMake(-self.view.frame.size.width, KK_BUTTON_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - KK_BUTTON_BAR_HEIGHT);
            _locationLabel.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height - LOCATION_LAEBL_HEIGHT, self.view.frame.size.width, LOCATION_LAEBL_HEIGHT);
            
        } completion:^(BOOL finished) {
            //动画结束
            _isMapViewHidden = NO;
            _tableView.hidden = YES;
            _locationLabel.hidden = YES;
            [self setAnnotions];
        }];
        
    }
    else {
        // 移动到列表最顶
        NSArray *indexs = [_tableView indexPathsForVisibleRows];
        if(indexs.count > 0) {
            NSString *crrSysVer = [[UIDevice currentDevice] systemVersion];
            double sysVer = [crrSysVer doubleValue];
            if (sysVer >= 5){
                NSIndexPath *index = [NSIndexPath indexPathForItem:_curTopItem inSection:0];
                [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        
        // 显示列表
        _isMapViewHidden = NO;
        _tableView.hidden = NO;
        self.mapView.hidden = NO;
        _locationLabel.hidden = NO;
        
        self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView.frame = CGRectMake(-self.view.frame.size.width, KK_BUTTON_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - KK_BUTTON_BAR_HEIGHT);
        _locationLabel.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height - LOCATION_LAEBL_HEIGHT, self.view.frame.size.width, LOCATION_LAEBL_HEIGHT);
        
        [UIView animateWithDuration:0.5 animations:^{
            //动画的内容
            self.mapView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            _tableView.frame = CGRectMake(0, KK_BUTTON_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - KK_BUTTON_BAR_HEIGHT);
            _locationLabel.frame = CGRectMake(0, self.view.frame.size.height - LOCATION_LAEBL_HEIGHT, self.view.frame.size.width, LOCATION_LAEBL_HEIGHT);
            
        } completion:^(BOOL finished) {
            //动画结束
            _isMapViewHidden = YES;
            self.mapView.hidden = YES;
            _tableView.hidden = NO;
            _locationLabel.hidden = NO;
        }];
    }
}

#pragma mark - 数据逻辑
- (void)resetParam {
    //    [ShopDataManager resetShopOrder];
    _curTopItem = 0;
    _maxItem = PageMaxRowValue;
    _loadMore = NO;
    _reloading = NO;
    _hasMore = NO;
    _totalItems = -1;
}
- (void)reloadParamData:(BOOL)isReloadView {
    [self reloadCategoryData];
    if(isReloadView) {
        _sortTableView.items = self.shopSortTypes;
        _creditTableView.items = self.credits;
        _categoryTableView.itemsParent = self.shopCategories;
        _regionTableView.itemsParent = self.regions;
        
        [_sortTableView reloadData];
        [_creditTableView reloadData];
        [_categoryTableView reloadData];
        [_regionTableView reloadData];
    }
}
- (void)reloadCategoryData {
    if(!self.region) {
        self.region = [ShopDataManager topRegion];
    }
    self.regions = [ShopDataManager regionWithCityId:[ShopDataManager cityCurrent].cityID];
    if(!self.shopCategory) {
        self.shopCategory = [ShopDataManager topCategory];
    }
    self.shopCategories = [ShopDataManager categoryList];
    
    if(!self.credit) {
        self.credit = [ShopDataManager topCredit];
    }
    self.credits = [ShopDataManager creditList];
    
    if(!self.shopSortTypes) {
        self.shopSortType = [ShopDataManager topShopSortType];
    }
    self.shopSortTypes = [ShopDataManager sortList];
}
- (void)reloadData:(BOOL)isReloadView {
    NSArray *shops = [ShopDataManager shopList:[ShopDataManager cityCurrent].cityID categoryID:self.shopCategory.categoryID creditID:self.credit.creditID regionID:self.region.regionID rankID:nil keyword:self.stringSearch];
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
        
        if(self.items.count > 0) {
            _kkListItemSelector.labelText.text = [NSString stringWithFormat:@"第%d-%d家", _curTopItem + 1, MIN(_curTopItem + PageMaxRowValue, self.items.count)];
        }
        else {
            _kkListItemSelector.labelText.text = @"没有商铺";
        }
        [self setAnnotions];
        if(_loadMore) {
            [self refreshMapBar:_kkListItemSelector];
        }
    }
}

- (void)setAnnotions {
    // 根据当前位置显示位置
    SignInManager *signManager = SignInManagerInstance();
    CGFloat regionRadus = REGION_RADUS;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocation *selfLocation = [signManager.checkInLocation toMarsLocation];
    self.selfAnnotation = [[SelfMapAnnotation alloc] initWithLatitude:selfLocation.coordinate.latitude andLongitude:selfLocation.coordinate.longitude];
    [self.mapView addAnnotation:self.selfAnnotation];
    
    NSMutableArray *array = [NSMutableArray array];
    for(int i = _curTopItem; i<MIN(self.items.count, _curTopItem + PageMaxRowValue); i++) {
        // 商店标签
        Shop *item = [self.items objectAtIndex:i];
        
        CLLocation *shopLocation = [[[CLLocation alloc] initWithLatitude:[item.lat doubleValue] longitude:[item.lon doubleValue]] toMarsLocation];
        
        ShopMapAnnotation *shopAnnotation = [[ShopMapAnnotation alloc] initWithLatitude:shopLocation.coordinate.latitude andLongitude:shopLocation.coordinate.longitude];
        shopAnnotation.tag = i;
        //        [self.mapView addAnnotation:shopAnnotation];
        [array addObject:shopAnnotation];
        
        // 计算最大区域
        regionRadus = MAX(regionRadus, [signManager getDistanceMeter:[item.lat doubleValue] lon:[item.lon doubleValue]]);
    }
    self.itemsAonntation = array;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([signManager.checkInLocation toMarsLocation].coordinate.latitude, [signManager.checkInLocation toMarsLocation].coordinate.longitude/*signManager.checkInLocation.coordinate.latitude, signManager.checkInLocation.coordinate.longitude*/);
    
    MACoordinateRegion mkCoordinateRegion = MACoordinateRegionMakeWithDistance(location, regionRadus * 3,regionRadus * 3);
    MACoordinateRegion adjustedRegion = [self.mapView regionThatFits:mkCoordinateRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.mapView addAnnotations:self.itemsAonntation];
}
#pragma mark - 签到回调 (SignManagerDelegate)
- (void)refreshFinish {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetParam];
        [self reloadData:YES];
        [self loadFromServer:NO];
    });
}
- (void)refreshError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTopStatusText:error];
    });
}
- (void)getLocationStringFinish:(NSString *)locationString {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationLabel.text = locationString;
    });
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
- (void)tableView:(CategoryTableView *)tableView didSelectShopCategory:(ShopCategory *)item {
    self.shopCategory = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(CategoryTableView *)tableView didSelectShopParentCategory:(ShopCategory *)item {
}
- (void)tableView:(RegionTableView *)tableView didSelectRegion:(Region *)item {
    self.region = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(RegionTableView *)tableView didSelectParentRegion:(Region *)item {
}
- (void)tableView:(CreditTableView *)tableView didSelectCredit:(Credit *)item {
    self.credit = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
}
- (void)tableView:(SortTableView *)tableView didSelectSort:(ShopSortType *)item {
    self.shopSortType = item;
    [self setupKKButtonBar];
    [self resetParam];
    [self reloadData:YES];
    [self loadFromServer:NO];
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
#pragma mark - 按钮弹出界面回调 (KKDynamicViewDelegate)
- (UIView *)viewForDetail:(KKDynamicView *)kkDynamicView {
    UIView *view = nil;
    [self setupKKButtonBarDistance];
    [self setupTableView];
    switch (kkDynamicView.tag) {
        case TAG_BUTTON_DISTANCE: {
            // 距离
            view = _kkButtonBarDistance;
            break;
        }
        case TAG_BUTTON_REGION:{
            // 商区
            _regionTableView.region = self.region;
            [_regionTableView reloadData];
            view = _regionTableView;
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
            [_creditTableView reloadData];
            view = _creditTableView;
            break;
        }
        case TAG_BUTTON_SORT:{
            // 排序方式
            _sortTableView.sort = self.shopSortType;
            view = _sortTableView;
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
    // 收起原来的选择界面
    [_kkDynamicView hide:NO];
    _kkDynamicView.hidden = YES;
    
    // 当前按钮不是选中
    if(!button.selected) {
        [self resetkkButtonBar];
        return;
    }
    // 根据按钮,显示详细界面
    _kkDynamicView.tag = button.tag;
    _kkDynamicView.hidden = NO;
    [_kkDynamicView reLoadView];
    [_kkDynamicView show:YES];
}
- (void)kkButtonBarDistanceButtonAction:(id)sender {
    KKImageButton *button = (KKImageButton *)sender;
    for(KKImageButton *kkButton in _kkButtonBarDistance.items) {
        // 取消其他按钮选中状态
        if(button.tag != kkButton.tag) {
            [kkButton setSelected:NO];
        }
    }
    _curDistance = button.tag - TAG_BUTTON_DISTANCE_DETAIL;
    switch (_curDistance) {
        case DISTANCE_500:{
            self.distance = 500;
            break;
        }
        case DISTANCE_1000:{
            self.distance = 1000;
            break;
        }
        case DISTANCE_2000:{
            self.distance = 2000;
            break;
        }
        case DISTANCE_5000:{
            self.distance = 5000;
            break;
        }
        default: {
            self.distance = 10000000;
            break;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        //动画的内容
//        _distanceView.frame = button.frame;
        //动画结束
    } completion:^(BOOL finished) {
        [ShopDataManager currentInfo].curDistanceType = [NSNumber numberWithInteger:_curDistance];
        [CoreDataManager saveData];
        
        [self setupKKButtonBar];
        [self resetParam];
        [self reloadData:YES];
        [self loadFromServer:NO];
    }];
}
#pragma mark - 地图回调
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        // 商铺弹出
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CallOutAnnotationView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CallOutAnnotationView"];
            
            ShopAnnotationCell *cell = [ShopAnnotationCell getCell];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.layer.borderColor = [[UIColor brownColor] CGColor];
            cell.layer.borderWidth = 2;
            cell.layer.cornerRadius = 5;

            cell.tag = TAG_VIEW_SHOPCELL;
            [annotationView.contentView addSubview:cell];
        }
        else {
            annotationView.annotation = annotation;
        }
        ShopAnnotationCell *cell = (ShopAnnotationCell *)[annotationView.contentView viewWithTag:TAG_VIEW_SHOPCELL];
        
        Shop *item = [self.items objectAtIndex:((CalloutMapAnnotation *)annotation).tag];
        cell.titleLabel.text = item.shopName;
        cell.kkRankSelector.curRank = [item.score integerValue] / RankOfScore;
        NSString *detail = [NSString stringWithFormat:@"%@ %@", item.address, item.category.categoryName];
        cell.detailLabel.text = detail;
        return annotationView;
    }
    if ([annotation isKindOfClass:[ShopMapAnnotation class]]) {
        // 商铺
        //        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopMapAnnotationView"];
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopMapAnnotationView"];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:@"ShopMapAnnotationView"];
            annotationView.animatesDrop = YES; // 从天而降的效果
            annotationView.canShowCallout = NO; // 可以弹出
            annotationView.pinColor = MAPinAnnotationColorRed;
            //            cell.image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:ShopAnnotationImage]];
        }
        else {
            annotationView.annotation = annotation;
        }
		return annotationView;
    }
    else if([annotation isKindOfClass:[SelfMapAnnotation class]]){
        // 当前位置
        //        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SelfMapAnnotationView"];
        MAAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SelfMapAnnotationView"];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SelfMapAnnotationView"];
            annotationView.canShowCallout = YES; // 可以弹出
            annotationView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SelfAnnotationImage ofType:@"png"]];
        }
        else {
            annotationView.annotation = annotation;
        }
		return annotationView;
    }
	return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
	if ([view.annotation isKindOfClass:[ShopMapAnnotation class]]) {
        // 点击商铺
        if (self.calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude &&
            self.calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (self.calloutAnnotation) {
            [mapView removeAnnotation:self.calloutAnnotation];
            self.calloutAnnotation = nil;
        }
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                                   initWithLatitude:view.annotation.coordinate.latitude
                                   andLongitude:view.annotation.coordinate.longitude];
        self.calloutAnnotation.tag = ((ShopMapAnnotation *)view.annotation).tag;
        [mapView addAnnotation:self.calloutAnnotation];
        
        [mapView setCenterCoordinate:self.calloutAnnotation.coordinate animated:YES];
	}
    else {
        if([view.annotation isKindOfClass:[CalloutMapAnnotation class]]){
            // 点击商户弹出界面
            Shop *item = [self.items objectAtIndex:((CalloutMapAnnotation *)view.annotation).tag];
            // 进入商户详细
            UIStoryboard *storyBoard = AppDelegate().storyBoard;
            ShopDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopDetailViewController"];
            vc.item = item;
            KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
            [nvc pushViewController:vc animated:YES gesture:YES];

        }
        else if([view.annotation isKindOfClass:[SelfMapAnnotation class]]){
            // 点击当前位置
        }
        if(self.calloutAnnotation) {
            [mapView removeAnnotation:self.calloutAnnotation];
            self.calloutAnnotation = nil;
        }
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
        if([self.requestOperator updateShopList:self.distance category:self.shopCategory.categoryID creditID:self.credit.creditID regionID:self.region.regionID sortID:self.shopSortType.sortID searchKey:self.stringSearch curMaxRow:_maxItem]) {
//            if(!self.mapView.hidden)
//                [self.kkLoadingView startLoadingInView:self.mapView];
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        // 刷最新
        if([self.requestOperator updateShopList:self.distance category:self.shopCategory.categoryID creditID:self.credit.creditID regionID:self.region.regionID sortID:self.shopSortType.sortID searchKey:self.stringSearch curMaxRow:0]) {
            _reloading = YES;
//            if(!self.mapView.hidden)
//                [self.kkLoadingView startLoadingInView:self.mapView];
            return YES;
        }
        else {
            return NO;
        }
    }
    
    return NO;
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    //[self setTopStatusText:@"刷新商户列表成功"];
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopList: {
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
        case ShopRequestOperatorStatus_UpdateShopList:{
            break;
        }
        default:break;
    }
}
@end
