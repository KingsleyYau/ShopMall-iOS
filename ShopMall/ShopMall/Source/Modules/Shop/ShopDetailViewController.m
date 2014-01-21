//
//  ShopDetailViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "LoginViewController.h"

#import "ShopMapViewController.h"
#import "ShopSignListViewController.h"
#import "ShopCommentListViewController.h"
#import "ShopPhotoListViewController.h"
#import "ShopInfoListViewController.h"
#import "ShopTrafficViewController.h"

#import "ShopCommitPhotoViewController.h"
#import "ShopCommitSignViewController.h"
#import "ShopCommitCommentViewController.h"
#import "ShopCommitBugViewController.h"

#import "DetailImageCell.h"
#import "DetailTitleCell.h"
#import "CommonTableViewCell.h"
#import "DetailCommentCell.h"
#import "DetailSignCell.h"
#import "DetailGuideCell.h"
#import "DetailSepCell.h"

#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

#define TAG_SHEET_UPLOAD 1001
#define TAG_SHEET_BUG    1002

#define TAG_TABBAR_UPLOAD   0
#define TAB_TABBAR_SIGN     1
#define TAB_TABBAR_COMMENT  2
#define TAB_TABBAR_BUG      3

typedef enum {
    RowTypePic,
    RowTypeTitle,
    RowTypeAddress,
    RowTypePhone,
    RowTypeRecommend,
    RowTypePhoto,
    RowTypeComment,
	RowTypeSign,
	RowTypeTraffic,
    RowTypeNear,
    RowTypeInfo,
    RowTypeSep,
} RowType;

@interface ShopDetailViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate>
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopRequestOperator *requestOperatorBookmark;
@end

@implementation ShopDetailViewController

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
    [self setupTabBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
    if(IsNetWorkOK) {
        [self loadFromServer];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
- (IBAction)bookmarkAction:(id)sender {
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online != loginManager.loginStatus) {
        // 未登陆,弹出登陆界面
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
        [self presentModalViewController:nvc animated:YES];
    }
    else {
        [self commitBookmark];
    }
}
- (IBAction)photoAction:(id)sender {
    // 图片
    ShopPhotoListViewController *vc = [[ShopPhotoListViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = self.item;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"商户详情";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    
    // 右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationBookmarkButton ofType:@"png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(bookmarkAction:) forControlEvents:UIControlEventTouchUpInside];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupTabBar {
    self.tabBar.items = [self customButtons];
    for(KKTabBarItem *tabBarItem in self.tabBar.items) {
        [tabBarItem setSelected:NO];
    }
}
- (NSArray *)customButtons {
    NSMutableArray *muableArray = [NSMutableArray array];
    KKTabBarItem *tabrBarItem = nil;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailTabBarItemUpload ofType:@"png"]];
    
    tabrBarItem = [[KKTabBarItem alloc] initWithTitle:nil image:image tag:TAG_TABBAR_UPLOAD];
    tabrBarItem.isHighLight = NO;
    tabrBarItem.isFullItemImage = YES;
    [tabrBarItem setSelected:NO];
    [muableArray addObject:tabrBarItem];
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailTabBarItemSign ofType:@"png"]];
    
    tabrBarItem = [[KKTabBarItem alloc] initWithTitle:nil image:image tag:TAB_TABBAR_SIGN];
    tabrBarItem.isHighLight = NO;
    tabrBarItem.isFullItemImage = YES;
    [tabrBarItem setSelected:NO];
    [muableArray addObject:tabrBarItem];
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailTabBarItemComment ofType:@"png"]];
    
    tabrBarItem = [[KKTabBarItem alloc] initWithTitle:nil image:image tag:TAB_TABBAR_COMMENT];
    tabrBarItem.isHighLight = NO;
    tabrBarItem.isFullItemImage = YES;
    [tabrBarItem setSelected:NO];
    [muableArray addObject:tabrBarItem];
    
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailTabBarItemBug ofType:@"png"]];
    
    tabrBarItem = [[KKTabBarItem alloc] initWithTitle:nil image:image tag:TAB_TABBAR_BUG];
    tabrBarItem.isHighLight = NO;
    tabrBarItem.isFullItemImage = YES;
    [tabrBarItem setSelected:NO];
    [muableArray addObject:tabrBarItem];
    
    return muableArray;
}
#pragma mark - 数据逻辑
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    self.item = [ShopDataManager shopWithId:self.item.shopID];
    
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    NSString *stringText = @"";
    
    // 图片
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailImageCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePic] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 分割符号
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailSepCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeSep] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 标题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailTitleCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 资讯
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeInfo] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 地址
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeAddress] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 电话
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePhone] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 点评
    dictionary = [NSMutableDictionary dictionary];
    stringText = @"";
    if(self.item.lastComment.length > 0) {
        stringText = [NSString stringWithFormat:@"%@", self.item.lastComment];
    }
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailCommentCell cellHeight:_tableView detailString:stringText]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeComment] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 签到
    dictionary = [NSMutableDictionary dictionary];
    stringText = @"";
    if(self.item.lastSignUser.length > 0 && self.item.lastSignDetail.length > 0) {
        stringText = [NSString stringWithFormat:@"%@:%@", self.item.lastSignUser, self.item.lastSignDetail];
    }
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailSignCell cellHeight:_tableView detailString:stringText]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeSign] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 路线查找
    dictionary = [NSMutableDictionary dictionary];
    stringText = @"";
    if(self.item.trafficInfo.length > 0) {
        stringText = self.item.trafficInfo;
    }
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailGuideCell cellHeight:_tableView detailString:stringText]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeTraffic] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 周边商户
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeNear] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    
    self.tableViewArray = array;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
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
            case RowTypePic:{
                // 图片
                DetailImageCell *cell = [DetailImageCell getUITableViewCell:tableView];
                result = cell;
                
                cell.requestImageView.imageUrl = self.item.logo.path;
                cell.requestImageView.imageData = self.item.logo.data;
                cell.requestImageView.contentType = self.item.logo.contentType;
                cell.requestImageView.delegate = self;
                [cell.requestImageView loadImage];
                
                [cell.button addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
            }break;
            case RowTypeTitle:{
                // 标题
                DetailTitleCell *cell = [DetailTitleCell getUITableViewCell:tableView];
                result = cell;
  
                cell.titleLabel.text = self.item.shopName;
                cell.kkRankSelector.curRank = [self.item.score integerValue] / RankOfScore;
                cell.priceAvgLabel.text = [NSString stringWithFormat:@"人均:¥ %@", self.item.priceAvg];
            }break;
            case RowTypeInfo:{
                // 资讯
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = [NSString stringWithFormat:@"商户资讯(共%@条)", self.item.lastInfoCount];
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellPhotoImage ofType:@"png"]];
                cell.sepLineView.hidden = NO;
                cell.backgroundImageView.hidden = NO;
            }break;
            case RowTypeAddress:{
                // 地址
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = self.item.address;
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellAddressImage ofType:@"png"]];
                cell.sepLineView.hidden = NO;
                cell.backgroundImageView.hidden = NO;
            }break;
            case RowTypePhone:{
                // 电话
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = self.item.phone;
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellPhoneImage ofType:@"png"]];
                cell.sepLineView.hidden = NO;
                cell.backgroundImageView.hidden = NO;
            }break;
            case RowTypeComment:{
                // 点评
                DetailCommentCell *cell = [DetailCommentCell getUITableViewCell:tableView];
                result = cell;
                
                NSString *titleString = [NSString stringWithFormat:@"点评 (共%@条)", self.item.totalComment];
                
                cell.userLabel.text = self.item.lastCommentUser;
                cell.kkRankSelector.curRank = [self.item.lastCommentStar integerValue] / 20;
                cell.titleLabel.text = titleString;
                if(self.item.lastComment.length > 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@", self.item.lastComment];
                }
                if(![self.item.lastCommentTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
                    cell.dateLabel.text = [self.item.lastCommentTime toString2YMDHM];
                }
            }break;
            case RowTypeSign:{
                // 签到
                DetailSignCell *cell = [DetailSignCell getUITableViewCell:tableView];
                result = cell;
                
                NSString *titleString = [NSString stringWithFormat:@"签到 (共%@条)", self.item.totalSign];
                cell.titleLabel.text = titleString;
                if(self.item.lastSignUser.length > 0 && self.item.lastSignDetail.length > 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@:%@", self.item.lastSignUser,  self.item.lastSignDetail];
                }
                if(![self.item.lastSignTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
                    cell.dateLabel.text = [self.item.lastSignTime toString2YMDHM];
                }
            }break;
            case RowTypeTraffic:{
                // 路线查找
                DetailGuideCell *cell = [DetailGuideCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"交通、营业时间及其他";
                cell.detailLabel.text = self.item.trafficInfo;
            }break;
            case RowTypeNear:{
                // 周边商户
                CommonTableViewCell *cell = [CommonTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"周边商户";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellNearImage ofType:@"png"]];
                cell.sepLineView.hidden = NO;
                cell.backgroundImageView.hidden = NO;
            }break;
            case RowTypeSep:{
                DetailSepCell *cell = [DetailSepCell getUITableViewCell:tableView];
                result = cell;
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];

        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeInfo:{
                // 资讯
                ShopInfoListViewController *vc = [[ShopInfoListViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeAddress:{
                // 地址
                ShopMapViewController *vc = [[ShopMapViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;
                
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypePhone:{
                // 电话
                if(![UIDevice canDail]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    NSString *stringPhone = [NSString stringWithFormat:@"tel://%@", self.item.phone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringPhone]];
                }
            }break;
            case RowTypeComment:{
                // 点评
                ShopCommentListViewController *vc = [[ShopCommentListViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;
                
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeSign:{
                // 签到
                ShopSignListViewController *vc = [[ShopSignListViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;

                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeTraffic:{
                // 交通
                ShopTrafficViewController *vc = [[ShopTrafficViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeNear:{
                // 周边商户
                [self.navigationController popViewControllerAnimated:YES];
            }break;
            default:break;
        }
    }
}
#pragma mark - UITabBar回调 (UITabBarDelegate)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)tabBarItem {
    KKTabBarItem *kkTabBarItem = (KKTabBarItem *)tabBarItem;
    [kkTabBarItem setSelected:NO];
    
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online != loginManager.loginStatus) {
        // 未登陆,弹出登陆界面
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
        nvc.navigationBar.translucent = NO;
        [self presentModalViewController:nvc animated:YES];
        return;
    }
    switch (tabBarItem.tag) {
        case TAG_TABBAR_UPLOAD:{
            // 上传图片
            UIActionSheet* sheet = [[UIActionSheet alloc] init];
            sheet.delegate = self;
            sheet.tag = TAG_SHEET_UPLOAD;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [sheet addButtonWithTitle:@"上传手机中的图片"];
            }
            [sheet addButtonWithTitle:@"拍照上传"];
            sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"取消"];
            sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [sheet showFromTabBar:self.tabBar];
            break;
        }
        case TAB_TABBAR_SIGN:{
            // 签到
            ShopCommitSignViewController *vc = [[[ShopCommitSignViewController alloc] init] initWithNibName:nil bundle:nil];
            vc.item = self.item;
            KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
            nvc.navigationBar.translucent = NO;
            [self.navigationController presentModalViewController:nvc animated:YES];
        }break;
        case TAB_TABBAR_COMMENT:{
            // 评论
            ShopCommitCommentViewController *vc = [[ShopCommitCommentViewController alloc] initWithNibName:nil bundle:nil];
            vc.item = self.item;
            KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
            nvc.navigationBar.translucent = NO;
            [self.navigationController presentModalViewController:nvc animated:YES];
        }break;
        case TAB_TABBAR_BUG:{
            // 报错
            ShopCommitBugViewController *vc = [[ShopCommitBugViewController alloc] initWithNibName:nil bundle:nil];
            KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
            nvc.navigationBar.translucent = NO;
            [self.navigationController presentModalViewController:nvc animated:YES];
        }break;
        default:
            break;
    }
    [((KKTabBarItem *)tabBarItem) setSelected:NO];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case TAG_SHEET_UPLOAD:{
            if (0 == buttonIndex || 1 == buttonIndex){
                // 0(照片) 1(拍照)
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = (0 == buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
                [self.navigationController presentModalViewController:imagePickerController animated:YES];
            }
            break;
        }
    }
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
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)loadFromServer{
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    return [self.requestOperator updateShopDetail:self.item.shopID];
}
- (void)cancelCommitBookmark {
    if(self.requestOperatorBookmark) {
        [self.requestOperatorBookmark cancel];
    }
}
- (BOOL)commitBookmark {
    [self cancelCommitBookmark];
    if(!self.requestOperatorBookmark) {
        self.requestOperatorBookmark = [[ShopRequestOperator alloc] init];
        self.requestOperatorBookmark.delegate = self;
    }
    return [self.requestOperatorBookmark submitShopBookmark:self.item.shopID];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopDetail:{
            [self cancel];
            [self reloadData:YES];
            break;
        }
        case ShopRequestOperatorStatus_CommitShopBookmark:{
            [self cancelCommitBookmark];
            [self setTopStatusText:@"收藏商户成功"];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopDetail:{
            [self cancel];
            break;
        }
        case ShopRequestOperatorStatus_CommitShopBookmark:{
            [self cancelCommitBookmark];
            [self setTopStatusText:@"收藏商户失败"];
            break;
        }
        default:break;
    }
}
@end
