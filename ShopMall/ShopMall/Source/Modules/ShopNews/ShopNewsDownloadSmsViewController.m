//
//  ShopNewsDownloadSmsViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsDownloadSmsViewController.h"
#import "LoginViewController.h"

#import "ShopNewsDownloadSmsFinishViewController.h"

#import "NewsDetailTitleCell.h"
#import "DetailImageCell.h"
#import "NewsDetailInfoCell.h"
#import "NewsDetailDateCell.h"
#import "NewsDetailDownLoadCell.h"
#import "NewsDetailDescCell.h"
#import "NewsDetailUserNameCell.h"

typedef enum {
    RowTypeShowTips,
    RowTypeShopTitle,
    RowTypeInfoTitle,
    RowTypePic,
    RowTypeDetail,
    RowTypeDate,
    RowTypeUserName,
    RowTypeDownLoad,
    RowTypeDesc,
} RowType;

@interface ShopNewsDownloadSmsViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate, UITextFieldDelegate> {
    CGRect _orgFrame;
}
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) NSString *phoneNumber;
@end

@implementation ShopNewsDownloadSmsViewController

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
    _orgFrame = self.tableView.frame;
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self closeKeyboard];
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (void)closeKeyboard {
    self.tableView.frame = _orgFrame;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"立即兑换";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (IBAction)downloadAction:(id)sender {
    // 点击我要获取
    [self closeKeyboard];
    if(![self checkInputData]) {
        return;
    }
    
    ShopNewsDownloadSmsFinishViewController *vc = [[ShopNewsDownloadSmsFinishViewController alloc] initWithNibName:nil bundle:nil];
    vc.item = self.item;
    vc.phoneNumber = self.phoneNumber;
    
    KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
    [nvc pushViewController:vc animated:YES gesture:YES];
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
        nvc.navigationBar.translucent = NO;
        [self.navigationController presentModalViewController:nvc animated:YES];
    }
}
- (BOOL)checkInputData {
    BOOL bFlag = YES;
    if([self.item.getType integerValue] == 2) {
        if(self.phoneNumber.length == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"请您输入电话号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            bFlag = NO;
        }
        else if(![self.phoneNumber isPhoneNum]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"请您输入正确的手机电话号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            bFlag = NO;
        }
    }
    return bFlag;
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
    
    // showtips
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailTitleCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeShowTips] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 商户标题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, 22);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeShopTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 资讯标题
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, 22);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeInfoTitle] forKey:ROW_TYPE];
    [array addObject:dictionary];
//    
//    // 图片
//    dictionary = [NSMutableDictionary dictionary];
//    viewSize = CGSizeMake(_tableView.frame.size.width, [DetailImageCell cellHeight]);
//    rowSize = [NSValue valueWithCGSize:viewSize];
//    [dictionary setValue:rowSize forKey:ROW_SIZE];
//    [dictionary setValue:[NSNumber numberWithInteger:RowTypePic] forKey:ROW_TYPE];
//    [array addObject:dictionary];
    
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
    
    if([self.item.getType integerValue] == 2) {
        // 用户名
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailUserNameCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeUserName] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    // 下载
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [NewsDetailDownLoadCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeDownLoad] forKey:ROW_TYPE];
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
    static NSString *cellIdentifier;
    
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
                
                cell.titleLabel.text = self.item.showTips;
            }break;
            case RowTypeShopTitle:{
                cellIdentifier = @"RowTypeShopTitle";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                }
                result = cell;
                cell.textLabel.text = self.item.shop.shopName;
            }break;
            case RowTypeInfoTitle:{
                cellIdentifier = @"RowTypeInfoTitle";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                }
                result = cell;
                cell.textLabel.text = self.item.infoTitle;
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
            case RowTypeUserName:{
                // 用户名
                NewsDetailUserNameCell *cell = [NewsDetailUserNameCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.phoneNumber;
                cell.textField.delegate = self;
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
#pragma mark - 输入回调
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.phoneNumber = textField.text;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.phoneNumber = textField.text;
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.phoneNumber = textField.text;
    return YES;
}
#pragma mark - 处理键盘回调
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:duration];
    if(height > 0) {
        // 弹出键盘
        self.tableView.frame = CGRectMake(_orgFrame.origin.x, _orgFrame.origin.y, _orgFrame.size.width, _orgFrame.size.height - height);
    }
    else {
        self.tableView.frame = _orgFrame;
    }
    //动画结束
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}
@end
