//
//  MemberMainViewController.M
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MemberMainViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"

#import "MemberShopNewsListViewController.h"
#import "MemberBookmarkListViewController.h"
#import "MemberPhotoListViewController.h"
#import "MemberCommentListViewController.h"
#import "MemberSignListViewController.h"

#import "MemberInfoTableViewCell.h"
#import "MemberLoginTableViewCell.h"
#import "MemberTableViewCell.h"

#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

typedef enum {
    RowTypeLogin,
    RowTypeGoodCredit,
    RowTypeUnionCredit,
    RowTypeCoupon,
    RowTypeBookmark,
    RowTypePicture,
    RowTypeComment,
    RowTypeSign,
} RowType;

@interface MemberMainViewController () <ShopRequestOperatorDelegate, LoginManagerDelegate, RequestImageViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) UIImage *uploadImage;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopRequestOperator *requestOperatorBookmark;
@end

@implementation MemberMainViewController

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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager addDelegate:self];
    [LoginManagerInstance() autoLogin];
    
    [self reloadData:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (IBAction)editButtonAction:(id)sender {
}
//- (IBAction)shopNewsAction:(id)sender {
//}
//- (IBAction)bookmarkAction:(id)sender {
//    if(LoginManagerInstance().loginStatus != LoginStatus_online)
//        return;
//}
//- (IBAction)pictureAction:(id)sender {
//    if(LoginManagerInstance().loginStatus != LoginStatus_online)
//        return;
//}
//- (IBAction)commentAction:(id)sender {
//    if(LoginManagerInstance().loginStatus != LoginStatus_online)
//        return;
//}
//- (IBAction)signAction:(id)sender {
//    if(LoginManagerInstance().loginStatus != LoginStatus_online)
//        return;
//}
- (IBAction)loginAction:(id)sender {
    // 点击登陆
//    UIStoryboard *storyBoard = AppDelegate().storyBoard;
//    LoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.translucent = NO;
    [self presentModalViewController:nvc animated:YES];
}
- (IBAction)logoutAction:(id)sender {
    // 注销事件
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager logout];
}
- (IBAction)registAction:(id)sender {
    // 注册界面
    RegisterViewController *vc = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
#pragma mark - 界面逻辑
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text =  @"我有";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // 右边按钮
    NSMutableArray *array = [NSMutableArray array];
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    
    // 已经登陆才出现注销按钮
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online == loginManager.loginStatus) {
        // 注销按钮
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationLogoutButton ofType:@"png"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [array addObject:barButtonItem];
    }
    else {
        
        barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registAction:)];
        barButtonItem.tintColor = [UIColor whiteColor];
        [array addObject:barButtonItem];
    }
    self.navigationItem.rightBarButtonItems = array;
}
#pragma mark - 数据逻辑
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    LoginManager *loginManager = LoginManagerInstance();
    if (LoginStatus_online == loginManager.loginStatus) {
        // 个人信息
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [MemberInfoTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeLogin] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    else {
        // 登陆
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [MemberLoginTableViewCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeLogin] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    // 好去处积分
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeGoodCredit] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 联通积分
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeUnionCredit] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 我的券券
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCoupon] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 收藏
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeBookmark] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 图片
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePicture] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 点评
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeComment] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 签到
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [MemberTableViewCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeSign] forKey:ROW_TYPE];
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
            case RowTypeLogin:{
                LoginManager *loginManager = LoginManagerInstance();
                if (LoginStatus_online != loginManager.loginStatus) {
                    // 未登陆状态,显示登陆按钮
                    MemberLoginTableViewCell *cell = [MemberLoginTableViewCell getUITableViewCell:tableView];
                    result = cell;

                    [cell.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    // 登陆状态,显示用户信息
                    MemberInfoTableViewCell *cell = [MemberInfoTableViewCell getUITableViewCell:tableView];
                    result = cell;

                    User *user = [ShopDataManager userCurrent];
                    cell.titleLabel.text = user.userName;
                    cell.requestImageView.delegate = self;
                    cell.requestImageView.imageUrl = user.logo.path;
                    cell.requestImageView.imageData = user.logo.data;
                    cell.requestImageView.contentType = user.logo.contentType;
                    [cell.requestImageView loadImage];
                    
                    [cell.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }break;
            case RowTypeGoodCredit:{
                // 好去处积分
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"好去处积分";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellGoodCreditImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].scoreSp) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].scoreSp]];
                }
            }break;
            case RowTypeUnionCredit:{
                // 联通积分
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"联通积分";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellUnionCreditImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].scoreOther) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].scoreOther]];
                }
            }break;
            case RowTypeCoupon:{
                // 我的券券
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"我的券券";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellBookmarkImage ofType:@"png"]];
                
                [cell.badgeButton setBadgeValue:nil];
                if([ShopDataManager userCurrent].scoreOther) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].countInfo]];
                }
            }break;
            case RowTypeBookmark:{
                // 收藏
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"收藏";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellBookmarkImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].countFavour) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].countFavour]];
                }
            }break;
            case RowTypePicture:{
                // 图片
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"图片";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellPhotoImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].countPhoto) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].countPhoto]];
                }
            }break;
            case RowTypeComment:{
                // 点评
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"点评";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellCommentImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].countComment) {
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].countComment]];
                }
            }break;
            case RowTypeSign:{
                // 签到
                MemberTableViewCell *cell = [MemberTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"签到";
                cell.leftImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopDetailCellSignImage ofType:@"png"]];
                
                if([ShopDataManager userCurrent].countSign){
                    [cell.badgeButton setBadgeValue:[NSString stringWithFormat:@"%@", [ShopDataManager userCurrent].countSign]];
                }
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 没有登陆
    if(LoginManagerInstance().loginStatus != LoginStatus_online)
        return;
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];
        
        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            case RowTypeLogin:{
                // 登陆
            }break;
            case RowTypeGoodCredit:{
                // 好去处积分
            }break;
            case RowTypeUnionCredit:{
                // 联通积分
            }break;
            case RowTypeCoupon:{
                // 我的券券
                MemberShopNewsListViewController *vc = [[MemberShopNewsListViewController alloc] initWithNibName:nil bundle:nil];
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeBookmark:{
                // 收藏
                MemberBookmarkListViewController *vc = [[MemberBookmarkListViewController alloc] initWithNibName:nil bundle:nil];
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypePicture:{
                // 图片
                MemberPhotoListViewController *vc = [[MemberPhotoListViewController alloc] initWithNibName:nil bundle:nil];
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeComment:{
                // 点评
                MemberCommentListViewController *vc = [[MemberCommentListViewController alloc] initWithNibName:nil bundle:nil];
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeSign:{
                // 签到
                MemberSignListViewController *vc = [[MemberSignListViewController alloc] initWithNibName:nil bundle:nil];
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            default:break;
        }
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
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
    // 上传图片
    UIActionSheet* sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    //    sheet.tag = TAG_SHEET_UPLOAD;
    sheet.title = @"修改头像";
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [sheet addButtonWithTitle:@"拍照上传"];
    }
    [sheet addButtonWithTitle:@"上传手机中的图片"];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"取消"];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showFromTabBar:self.tabBarController.tabBar];
}
#pragma mark － 登陆状态改变回调（LoginManagerDelegate）
- (void)loginStatusChanged:(LoginStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        MainTabBarController *tvc = (MainTabBarController *)self.tabBarController;
        [tvc updateViewControllers];
        [self reloadData:YES];
    });
}
#pragma mark - 上传图片弹出界面 (UIActionSheetDelegate)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex || 1 == buttonIndex){
        // 0(拍照) 1(照片)
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = (1 == buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
        [self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
}
#pragma mark - 图片选择回调 (UIImagePickerControllerDelegate)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 淡出UIImagePickerController
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
    CGFloat scale = resizeImage.size.width / resizeImage.size.height;
    NSInteger maxSize = 1024.0f;
    if (scale > 1.0f){
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
    }
    else {
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
    }
    self.uploadImage = resizeImage;
    [self uploadUserImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)uploadUserImage {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    
    return  [self.requestOperator uploadUserFace:self.uploadImage];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_UploadUserFace:{
            [self setTopStatusText:@"上传头像成功"];
            [LoginManagerInstance() autoLogin];
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
    switch(type){
        case ShopRequestOperatorStatus_UploadUserFace:{
            break;
        }
        default:break;
    }
}
@end
