//
//  ShopNewsDownloadSmsFinishViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsDownloadSmsFinishViewController.h"
#import "LoginViewController.h"

#import "MemberShopNewsListViewController.h"

#import "NewsDetailTitleCell.h"
#import "DetailImageCell.h"
#import "NewsDetailInfoCell.h"
#import "NewsDetailDateCell.h"
#import "NewsDetailDownLoadCell.h"
#import "NewsDetailDescCell.h"
#import "NewsDetailUserNameCell.h"

typedef enum {
    RowTypeShowTips,
    RowTypeBack,
    RowTypeMyInfo,
} RowType;

@interface ShopNewsDownloadSmsFinishViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate, UITextFieldDelegate> {
}
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopNewsDownloadSmsFinishViewController

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
    self.buyTips = @"正在获取...";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated {
    [self reloadData:YES];
    if(!self.viewDidAppearEver) {
        [self commit];
    }
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
- (IBAction)backAction:(id)sender {
    // 点击返回
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)infoAction:(id)sender {
    // 点击我的券券
    MemberShopNewsListViewController *vc = [[MemberShopNewsListViewController alloc] initWithNibName:nil bundle:nil];
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我要获取";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
#pragma mark - 数据逻辑
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    self.item = [ShopDataManager shopNewsWithId:self.item.shopNewsID];
    
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // showtips
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailTitleCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeShowTips] forKey:ROW_TYPE];
    [array addObject:dictionary];

    // 返回
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDownLoadCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeBack] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 我的券券
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDownLoadCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeMyInfo] forKey:ROW_TYPE];
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
            case RowTypeShowTips:{
                // 标题
                NewsDetailTitleCell *cell = [NewsDetailTitleCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = self.buyTips;
            }break;
            case RowTypeBack:{
                NewsDetailDownLoadCell *cell = [NewsDetailDownLoadCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button setTitle:@"继续浏览资讯" forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            }break;
            case RowTypeMyInfo:{
                NewsDetailDownLoadCell *cell = [NewsDetailDownLoadCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button setTitle:@"查看我的券券" forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([tableView isEqual:self.tableView]) {
        // 主tableview
        NSDictionary *dictionarry = [self.tableViewArray objectAtIndex:indexPath.row];

        // TODO:类型
        RowType type = (RowType)[[dictionarry valueForKey:ROW_TYPE] intValue];
        switch (type) {
            default:break;
        }
    }
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
}
- (BOOL)commit {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    return [self.requestOperator buyShopNewsInfoSms:self.item.shopNewsID phoneNumber:self.phoneNumber];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_BuyShopNewsSms:{
            [self cancel];
            [self setTopStatusText:@"获取成功"];
            self.buyTips = [[data objectForKey:ShopPersonalNewsesDetail] objectForKey:ShopNewsBuyTips];
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_BuyShopNewsSms:{
            [self cancel];
            self.buyTips = @"获取失败";
            [self setTopStatusText:@"获取失败"];
            break;
        }
        default:break;
    }
}
@end
