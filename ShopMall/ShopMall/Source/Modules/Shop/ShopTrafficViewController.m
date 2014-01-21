//
//  ShopTrafficViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopTrafficViewController.h"

#import "DetailTrafficCell.h"
#import "CommonTitleDetailTableViewCell.h"

typedef enum {
    RowTypeTraffic,
    RowTypeDetail,
} RowType;

@interface ShopTrafficViewController () <ShopRequestOperatorDelegate, UIWebViewDelegate> {
    CGRect _webFrame;
}
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) UIImage *uploadImage;
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopRequestOperator *requestOperatorBookmark;
@end

@implementation ShopTrafficViewController

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
    _webFrame = CGRectZero;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    titleLabel.text =  @"交通、营业时间及其他";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
#pragma mark - 数据逻辑
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 交通信息
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailTrafficCell cellHeight:self.tableView titleString:@"交通信息" webViewHeight:_webFrame.size.height]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeTraffic] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 商户详情
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [CommonTitleDetailTableViewCell cellHeight:self.tableView titleString:@"商户详情" detailString:self.item.writeUp]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDetail] forKey:ROW_TYPE];
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
            case RowTypeTraffic:{
                // 交通信息
                DetailTrafficCell *cell = [DetailTrafficCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"交通信息";
                cell.webView.frame = _webFrame;
                
                cell.webView.delegate = self;
                [cell.webView loadHTMLString:([DetailTrafficCell htmlStringFromString:self.item.trafficInfo]) baseURL:nil];
            }break;
            case RowTypeDetail:{
                // 商户信息
                CommonTitleDetailTableViewCell *cell = [CommonTitleDetailTableViewCell getUITableViewCell:tableView];
                result = cell;
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.titleLabel.text = @"商户信息";
                cell.detailLabel.text = self.item.writeUp;
            }break;
            default:break;
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark - UIWebView回调
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// calculate webView height, if it change we need to reload table
    CGFloat oldDescriptionHeight = webView.frame.size.height;
	CGFloat newDescriptionHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"main-content\").scrollHeight;"] floatValue];
    if(newDescriptionHeight > 0) {
        newDescriptionHeight += 10;
    }
    CGRect frame = webView.frame;
    frame.size.height = newDescriptionHeight;
    webView.frame = frame;
    _webFrame = frame;
    
	if(newDescriptionHeight != oldDescriptionHeight) {
		oldDescriptionHeight = newDescriptionHeight;
        [self reloadData:YES];
	}
}
@end
