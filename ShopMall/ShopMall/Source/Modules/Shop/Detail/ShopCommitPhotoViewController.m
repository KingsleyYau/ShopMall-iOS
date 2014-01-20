//
//  ShopCommitPhotoViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCommitPhotoViewController.h"
#import "ShopProductListViewController.h"

#import "PhotoTypeCell.h"
#import "PhotoNameCell.h"
#import "PhotoRankCell.h"
#import "PhotoPriceCell.h"
#import "PhotoCommitCell.h"

typedef enum {
    RowTypeType,
    RowTypeName,
    RowTypeStar,
    RowTypePrice,
    RowTypeCommit,
} RowType;

@interface ShopCommitPhotoViewController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate, KKRankSelectorDelegete, ShopProductViewControllerDelegate> {
    CGRect _orgFrame;
}
@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) NSString *imageType;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, assign) NSInteger imagePrice;
@property (nonatomic, assign) NSInteger imgRank;
@end

@implementation ShopCommitPhotoViewController

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
    [self setupLoadingView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _orgFrame = self.view.frame;
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
    [self cancel];
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
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"上传图片";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (IBAction)commitAction:(id)sender {
    [self commit];
}
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 数据逻辑
- (NSArray *)customButtons {
    NSMutableArray *muableArray = [NSMutableArray array];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopPhotoTypeBarItemImage ofType:@"png"]];
    UIImage *imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopPhotoTypeBarItemSelectedImage ofType:@"png"]];
    
    if(self.typeArray.count > 0) {
        for(int i=0; i<self.typeArray.count; i++) {
            KKImageButton *button = [KKImageButton buttonWithType:UIButtonTypeCustom];
            [muableArray addObject:button];
            
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
            button.kkImage = image;
            button.kkSelectedImage = imageSelected;
            [button setSelected:NO];
            if([self.imageType isEqualToString:[self.typeArray objectAtIndex:i]]) {
                [button setSelected:YES];
            }
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:[self.typeArray  objectAtIndex:i] forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return muableArray;
}
- (void)initType {
    self.typeArray = [ShopDataManager shopImageTypeList];
    if(!self.imageType && self.typeArray.count > 0) {
        self.imageType = [self.typeArray objectAtIndex:0];
    }
}
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    self.item = [ShopDataManager shopWithId:self.item.shopID];
    [self initType];
    
    [self.imageView setImage:self.image];
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // 图片类型
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [PhotoTypeCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeType] forKey:ROW_TYPE];
    [array addObject:dictionary];

    // 图片名字
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [PhotoNameCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeName] forKey:ROW_TYPE];
    [array addObject:dictionary];

    // 评分
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [PhotoRankCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeStar] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    if([self.imageType isEqualToString:ImageTypeProduct]) {
        // 图片类型为产品显示价格
        // 价格
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [PhotoPriceCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypePrice] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    
    // 提交
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [PhotoCommitCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCommit] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    self.tableViewArray = array;
    
    if(isReloadView) {
        [self.tableView reloadData];
    }
}
- (BOOL)checkInputData {
    BOOL bFlag = YES;
    [self closeKeyboard];
    if(self.imageType.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"请选择图片类型！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(self.imageName.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"请选择图片名字！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return bFlag;
}
- (UIImage *)resizeImage {
    UIImage *resizeImage = self.image;
    CGFloat scale = resizeImage.size.width / resizeImage.size.height;
    NSInteger maxSize = 1024.0f;
    if (scale > 1.0f){
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
    }
    else {
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
    }
    return resizeImage;
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
            case RowTypeType:{
                // 图片类型
                PhotoTypeCell *cell = [PhotoTypeCell getUITableViewCell:tableView];
                result = cell;
                
                cell.titleLabel.text = @"类型";
                cell.kkButtonBar.items = [self customButtons];
            }break;
            case RowTypeName:{
                // 图片名字
                PhotoNameCell *cell = [PhotoNameCell getUITableViewCell:tableView];
                result = cell;
                
                cell.kkTextField.tag = (NSInteger)RowTypeName;
                cell.kkTextField.delegate = self;
                
                if([self.imageType isEqualToString:ImageTypeProduct]) {
                    // 产品
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.kkTextField.enabled = NO;
                    cell.kkTextField.placeholder = @"请选择产品标题";
                }
                else {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.kkTextField.enabled = YES;
                    cell.kkTextField.placeholder = @"请输入图片标题";
                }
                
                if(self.imageName.length > 0) {
                    cell.kkTextField.text = self.imageName;
                }
                else {
                    cell.kkTextField.text = nil;
                }
            }break;
            case RowTypeStar:{
                // 图片评分
                PhotoRankCell *cell = [PhotoRankCell getUITableViewCell:tableView];
                result = cell;
                
                cell.kkRankSelector.delegate = self;
                cell.kkRankSelector.curRank = self.imgRank;
            }break;
            case RowTypePrice:{
                PhotoPriceCell *cell = [PhotoPriceCell getUITableViewCell:tableView];
                result = cell;
                
                cell.kkTextField.tag = (NSInteger)RowTypePrice;
                cell.kkTextField.delegate = self;
                
                
            }break;
            case RowTypeCommit:{
                // 提交
                PhotoCommitCell *cell = [PhotoCommitCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
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
            case RowTypeType:{
                // 图片类型
            }break;
            case RowTypeName:{
                // 图片名字
                ShopProductListViewController *vc = [[ShopProductListViewController alloc] initWithNibName:nil bundle:nil];
                vc.item = self.item;
                vc.productName = self.imageName;
                vc.delegate = self;
                KKNavigationController *nvc = (KKNavigationController *)self.navigationController;
                [nvc pushViewController:vc animated:YES gesture:YES];
            }break;
            case RowTypeCommit:{
                // 提交
            }break;
            default:break;
        }
    }
}
- (void)kkButtonBarButtonAction:(id)sender {
    KKImageButton *button = (KKImageButton *)sender;
    
    KKButtonBar *kkButtonBar = (KKButtonBar *)button.superview;
    for(KKImageButton *kkButton in kkButtonBar.items) {
        // 取消其他按钮选中状态
        if(button.tag != kkButton.tag) {
            [kkButton setSelected:NO];
        }
    }
    // 根据按钮,显示详细界面
    [button setSelected:YES];
    
    if([self.imageType isEqualToString:[self.typeArray objectAtIndex:button.tag]]) {
        return;
    }
    else {
        self.imageType = [self.typeArray objectAtIndex:button.tag];
        if([self.imageType isEqualToString:ImageTypeProduct]) {
            // 产品
            self.imageName = @"";
        }
        [self reloadData:YES];
    }
}
#pragma mark - 处理键盘回调
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:duration];
    if(height > 0) {
        // 弹出键盘
        self.view.frame = CGRectMake(_orgFrame.origin.x, _orgFrame.origin.y, _orgFrame.size.width, _orgFrame.size.height - height);
    }
    else {
        self.view.frame = _orgFrame;
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
#pragma mark - 输入回调
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if((NSInteger)RowTypeName == textField.tag) {
        // 图片名字
        self.imageName = textField.text;
    }
    else if((NSInteger)RowTypePrice == textField.tag){
        // 图片价格
        self.imagePrice = [textField.text intValue];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if((NSInteger)RowTypeName == textField.tag) {
        // 图片名字
        self.imageName = textField.text;
    }
    else if((NSInteger)RowTypePrice == textField.tag){
        // 图片价格
        self.imagePrice = [textField.text intValue];
    }
    return YES;
}
#pragma mark - 评分控件回调 (KKRankSelectorDelegete)
- (void)didChangeRank:(KKRankSelector *)kkRankSelector curRank:(NSInteger)curRank {
    self.imgRank = curRank;
}
#pragma mark - 产品界面回调
- (void)viewController:(ShopProductListViewController *)viewController didSelectedProductName:(NSString *)productName {
    self.imageName = productName;
    [self reloadData:YES];
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
    [self.kkLoadingView cancelLoading];
}
- (BOOL)commit {
    if(![self checkInputData]) {
        return NO;
    }
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator submitShopImage:self.item.shopID imageType:self.imageType imageName:self.imageName star:self.imgRank * RankOfScore price:self.imagePrice image:[self resizeImage]];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_CommitShopPicture:{
            [self cancel];
            [self setTopStatusText:@"上传成功"];
            [self backAction:nil];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_CommitShopPicture:{
            [self cancel];
            [self setTopStatusText:@"上传失败"];
            break;
        }
        default:break;
    }
}
@end
