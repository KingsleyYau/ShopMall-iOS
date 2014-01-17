//
//  ShopNewsDetailViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsDetailViewController.h"
#import "LoginViewController.h"
#import "ShopNewsDownloadSmsViewController.h"

#import "NewsDetailTitleCell.h"
#import "DetailImageCell.h"
#import "NewsDetailInfoCell.h"
#import "NewsDetailDateCell.h"
#import "NewsDetailDownLoadCell.h"
#import "NewsDetailDescCell.h"

typedef enum {
    RowTypeTitle,
    RowTypePic,
    RowTypeDetail,
    RowTypeDate,
    RowTypeDownLoad,
    RowTypeDesc,
} RowType;

@interface ShopNewsDetailViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate>
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopNewsDetailViewController

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
        [self loadFromServer];
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
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text =  @"资讯详细";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (IBAction)downloadAction:(id)sender {
    if(LoginManagerInstance().loginStatus == LoginStatus_online) {
        ShopNewsDownloadSmsViewController *vc = [[ShopNewsDownloadSmsViewController alloc] initWithNibName:nil bundle:nil];
        vc.item = self.item;
        
        KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
        [nvc  pushViewController:vc animated:YES gesture:YES];
    }
    else {
        LoginViewController *vc = [[[LoginViewController alloc] init] initWithNibName:nil bundle:nil];
        KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentModalViewController:nvc animated:YES];
    }
}
- (IBAction)savePictureAction:(id)sender {
    if(LoginManagerInstance().loginStatus == LoginStatus_online) {
//        ShopNewsDownLoadPhotoViewController *vc = [[[ShopNewsDownLoadPhotoViewController alloc] init] autorelease];
//        vc.shopNewsID = self.shopNewsID;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        LoginViewController *vc = [[[LoginViewController alloc] init] initWithNibName:nil bundle:nil];
        KKNavigationController *nvc = [[KKNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentModalViewController:nvc animated:YES];
    }
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
    
    NSString *stringText = @"";
    
    // 标题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailTitleCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 图片
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailImageCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePic] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 详细内容
    dictionary = [NSMutableDictionary dictionary];
    stringText = self.item.smsinfo;
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailInfoCell cellHeight:self.tableView detailString:stringText]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDetail] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 日期内容
    dictionary = [NSMutableDictionary dictionary];
    stringText = [NSString stringWithFormat:@"有效期:%@至%@", [self.item.infoBeginDate toStringYMD], [self.item.infoEndDate toStringYMD]];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDateCell cellHeight:self.tableView detailString:stringText]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDate] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 下载
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDownLoadCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDownLoad] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 描述
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDescCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDesc] forKey:ROW_TYPE];
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
            case RowTypeTitle:{
                // 标题
                NewsDetailTitleCell *cell = [NewsDetailTitleCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = self.item.getTips;
            }break;
            case RowTypePic:{
                // 图片
                DetailImageCell *cell = [DetailImageCell getUITableViewCell:tableView];
                result = cell;
                
                cell.requestImageView.imageUrl = self.item.logo.path;
                cell.requestImageView.imageData = self.item.logo.data;
                cell.requestImageView.contentType = self.item.logo.contentType;
                cell.requestImageView.delegate = self;
                [cell.requestImageView loadImage];
            }break;
            case RowTypeDetail:{
                // 详细内容
                NewsDetailInfoCell *cell = [NewsDetailInfoCell getUITableViewCell:tableView];
                result = cell;
                
                cell.detailLabel.text = self.item.smsinfo;
            }break;
            case RowTypeDate:{
                // 有效期
                NewsDetailDateCell *cell = [NewsDetailDateCell getUITableViewCell:tableView];
                result = cell;
                
                cell.detailLabel.text = [NSString stringWithFormat:@"有效期:%@至%@", [self.item.infoBeginDate toStringYMD], [self.item.infoEndDate toStringYMD]];
            }break;
            case RowTypeDownLoad:{
                NewsDetailDownLoadCell *cell = [NewsDetailDownLoadCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
            }break;
            case RowTypeDesc:{
                NewsDetailDescCell *cell = [NewsDetailDescCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = self.item.showTips;
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
            case RowTypePic:{
                // 图片
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
    [self savePictureAction:nil];
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
    
    return [self.requestOperator updateShopNewsDetail:self.item.shopNewsID];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopNewsDetail:{
            [self cancel];
            [self reloadData:YES];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateShopNewsDetail:{
            [self cancel];
            [self setTopStatusText:@"加载资讯详细失败"];
            break;
        }
        default:break;
    }
}
@end
