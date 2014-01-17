//
//  ShopCategoryViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCategoryViewController.h"
#import "ShopListNearViewController.h"

@interface ShopCategoryViewController () {
}
@property (nonatomic, retain) NSArray *shopCategories;
@end

@implementation ShopCategoryViewController
@synthesize shopCategories;
@synthesize shopCategory;
@synthesize delegate;

#pragma mark - 构造
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
    [self reloadData:YES];
    if(IsNetWorkOK) {
        //[self loadCategoryFromServer:0];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self cancel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)navigationController:(KKNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setupNavigationBar];
}
#pragma mark - 界面布局
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"更多分类";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupBackgroundView {
    [super setupBackgroundView];
}
#pragma mark - 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    self.shopCategories = [ShopDataManager categoryList];
    if(!self.shopCategory) {
        self.shopCategory = [ShopDataManager topCategory];
    }
    if(isReloadView) {
        self.tableView.itemsParent = self.shopCategories;
        self.tableView.category = self.shopCategory;
        [self.tableView reloadData];
    }
}
//#pragma mark - 协议请求
//- (void)cancel {
//    MIT_MobileAppDelegate *appDelegate = (MIT_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate hideNetworkActivityIndicator];
//    
//    if(self.requestOperator) {
//        [self.requestOperator cancel];
//    }
//}
//- (BOOL)loadCategoryFromServer:(NSNumber *)categoryID {
//    // 获取所有行业分类
//    [self cancel];
//    if(!self.requestOperator) {
//        return NO;
//    }
//    MIT_MobileAppDelegate *appDelegate = (MIT_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate showNetworkActivityIndicator];
//    return [self.requestOperator updateCategoryList:categoryID];
//}
//#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
//- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
//    [self cancel];
//    switch(type){
//        case ShopRequestOperatorStatus_UpdateCategory:{
//            [self reloadData:YES];
//            break;
//        }
//        default:break;
//    }
//}
//- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
//    [self cancel];
//    [self setTopStatusText:error];
//    switch(type){
//        case ShopRequestOperatorStatus_UpdateCategory:{
//            break;
//        }
//        default:break;
//    }
//}
- (void)needReloadData:(CategoryTableView *)tableView {
    
}
- (void)tableView:(CategoryTableView *)tableView didSelectShopCategory:(ShopCategory *)item {
    self.shopCategory = item;
    if([self.delegate respondsToSelector:@selector(shouldPopupShopCategoryViewController:)]) {
        if([self.delegate shouldPopupShopCategoryViewController:self]) {
            // 返回上级界面
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    // 进入商户列表
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    ShopListNearViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopListNearViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    vc.shopCategory = self.shopCategory;;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)tableView:(CategoryTableView *)tableView didSelectShopParentCategory:(ShopCategory *)item {
    self.shopCategory = item;
}
@end
