//
//  ShopCreditViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCreditViewController.h"
#import "ShopListNearViewController.h"

@interface ShopCreditViewController () {
}
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopCreditViewController

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
    titleLabel.text = @"积分";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupBackgroundView {
    [super setupBackgroundView];
}
#pragma mark - 界面逻辑
- (void)reloadData:(BOOL)isReloadView {
    self.items = [ShopDataManager creditList];
    if(isReloadView) {
        _tableView.items = self.items;
        [_tableView reloadData];
    }
}
- (void)needReloadData:(CreditTableView *)tableView {
    
}
- (void)tableView:(CreditTableView *)tableView didSelectCredit:(Credit *)item {
    self.credit = item;
    // 进入商户列表
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    ShopListNearViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopListNearViewController"];
    vc.credit = self.credit;
    vc.isRegion = YES;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
@end
