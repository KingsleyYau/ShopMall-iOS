//
//  MemberPhotoListViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "MemberPhotoListViewController.h"
#import "LoginViewController.h"
#import "ShopPhotoDetailViewController.h"
#import "ShopCommitPhotoViewController.h"

#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

@interface MemberPhotoListViewController () <ShopRequestOperatorDelegate, EGORefreshTableHeaderDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
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

@implementation MemberPhotoListViewController

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
- (IBAction)newAction:(id)sender {
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online != loginManager.loginStatus) {
        // 未登陆,弹出登陆界面
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
        [self presentModalViewController:nvc animated:YES];
    }
    else {
        // 上传图片
        UIActionSheet* sheet = [[UIActionSheet alloc] init];
        sheet.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [sheet addButtonWithTitle:@"上传手机中的图片"];
        }
        [sheet addButtonWithTitle:@"拍照上传"];
        sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"取消"];
        sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [sheet showInView:self.view];
    }
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    NSString *title = @"我的图片";

    if(_totalItems > 0) {
        title = [NSString stringWithFormat:@"我的图片(共%d条)", _totalItems];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text =  title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

//    UIBarButtonItem *barButtonItem = nil;
//    UIImage *image = nil;
//    
//    // 右边按钮
//    NSMutableArray *array = [NSMutableArray array];
//    // 最新按钮
//    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationPhotoAddButton ofType:@"png"]];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:image forState:UIControlStateNormal];
//    [button sizeToFit];
//    [button addTarget:self action:@selector(newAction:) forControlEvents:UIControlEventTouchUpInside];
//    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    [array addObject:barButtonItem];
//    
//    self.navigationItem.rightBarButtonItems = array;
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
    NSArray *array = [ShopDataManager shopImageUserCurrent:nil];
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
#pragma mark - 列表界面回调 (PhotoTableViewDelegate)
- (void)needReloadData:(PhotoTableView *)tableView {
    [self reloadData:NO];
}
- (void)tableView:(PhotoTableView *)tableView didSelectShopImage:(ShopImage *)item {
    // 进入图片详细
    ShopPhotoDetailViewController *vc = [[ShopPhotoDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = self.item;
    vc.curIndex = [self.items indexOfObject:item];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)didSelectMore:(PhotoTableView *)tableView {
    
    if(IsNetWorkOK) {
        [self loadFromServer:YES];
    }
    
    // 假设已经入库每页最大纪录
    _maxItem += PageMaxRowValue;
    [self reloadData:YES];
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
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 淡出UIImagePickerController
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
    ShopCommitPhotoViewController *vc = [[ShopCommitPhotoViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = self.item;
    vc.image = resizeImage;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex || 1 == buttonIndex){
        // 0(照片) 1(拍照)
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = (0 == buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
        [self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
}
#pragma mark - 缩略图界面回调 (RequestImageViewDelegate)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    File *file = [ShopDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
        [self reloadData:NO];
    }
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
        return [self.requestOperator updateMemberImageListList:_maxItem];
    }
    else {
        // 刷最新
        return [self.requestOperator updateMemberImageListList:0];
    }
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)json requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UpdateMemberPictureList:{
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
        case ShopRequestOperatorStatus_UpdateMemberPictureList:{
            [self setTopStatusText:@"获取商户签到列表失败"];
            break;
        }
        default:break;
    }
}
@end
