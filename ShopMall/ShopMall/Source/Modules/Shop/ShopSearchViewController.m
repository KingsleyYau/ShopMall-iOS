//
//  ShopSearchViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-9.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopSearchViewController.h"
#import "ShopListNearViewController.h"
#import "ShopCategoryViewController.h"
#import "ShopRegionViewController.h"

@interface ShopSearchViewController () <ShopCategoryViewControllerDelegate, ShopRegionViewControllerDelegate>
@property (nonatomic, retain) ShopCategory *shopCategory;
@property (nonatomic, retain) Region *region;
@end

@implementation ShopSearchViewController

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
    [self.regionButton setTitle:@"" forState:UIControlStateNormal];
    [self.categoryButton setTitle:@"" forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"搜翻天";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (IBAction)regionAction:(id)sender {
    // 点击分区
    ShopRegionViewController *vc = [[ShopRegionViewController alloc] initWithNibName:nil bundle:nil];
    vc.region = self.region;
    vc.delegate = self;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)categoryAction:(id)sender {
    // 点击分类
//    UIStoryboard *storyBoard = AppDelegate().storyBoard;
//    ShopCategoryViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopCategoryViewController"];
    ShopCategoryViewController *vc = [[ShopCategoryViewController alloc] initWithNibName:nil bundle:nil];
    vc.shopCategory = self.shopCategory;
    vc.delegate = self;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (IBAction)commitAction:(id)sender {
    [self commit];
}
- (void)reloadData:(BOOL)isReloadView {
    // 数据绑定
    if(!self.region) {
        self.region = [ShopDataManager topRegion];
    }
    if(!self.shopCategory) {
        self.shopCategory = [ShopDataManager topCategory];
    }
    
    if(isReloadView) {
        // 刷新界面
        [self.regionButton setTitle:self.region.regionName forState:UIControlStateNormal];
        [self.categoryButton setTitle:self.shopCategory.categoryName forState:UIControlStateNormal];
    }
}
- (void)commit {
    // 提交搜索
    UIStoryboard *storyBoard = AppDelegate().storyBoard;
    ShopListNearViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopListNearViewController"];
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    vc.shopCategory = self.shopCategory;
    vc.region = self.region;
    vc.isRegion = YES;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
#pragma mark - 选择商区和分类界面回调 (ShopCategoryViewControllerDelegate / ShopRegionViewControllerDelegate)
- (BOOL)shouldPopupShopCategoryViewController:(ShopCategoryViewController *)vc {
    self.shopCategory = vc.shopCategory;
    [self reloadData:YES];
    return YES;
}
- (BOOL)shouldPopupShopRegionViewController:(ShopRegionViewController *)vc {
    self.region = vc.region;
    [self reloadData:YES];
    return YES;
}
@end
