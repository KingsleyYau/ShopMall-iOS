//
//  RegisterViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegisterViewController.h"

#import "RegisterImageCell.h"
#import "RegisterPhoneCell.h"
#import "RegisterEmailCell.h"
#import "RegisterGetCheckCodeCell.h"
#import "RegisterCheckCodeCell.h"
#import "RegisterSepCell.h"

#import "RegisterUsernameCell.h"
#import "RegisterPasswordCell.h"
#import "RegisterPassword2Cell.h"
#import "RegisterCommitCell.h"

#define TAG_BUTTON_PHONE     1000
#define TAG_BUTTON_EMAIL     1001

typedef enum{
    RegisterPhoneType,
    RegisterEmailType,
}RegisterType;

typedef enum {
    RowTypeLogoCell,
    RowTypePhoneCell,
    RowTypeEmailCell,
    RowTypeGetCheckCodeCell,
    RowTypeCheckCodeCell,
    RowTypeSepCell,
    
    RowTypeUserNameCell,
    RowTypePasswordCell,
	RowTypePasswordCell2,
	RowTypeCommitCell,
} RowType;

@interface RegisterViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RequestImageViewDelegate, ShopRequestOperatorDelegate, UITextFieldDelegate> {
    CGRect _orgFrame;
    RegisterType _registerType;
    NSInteger _curCount;
}
@property (nonatomic, strong) NSArray *tableViewArray;

@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) ShopRequestOperator *requestOperatorBookmark;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString *count4CheckCodeTips;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *checkCode;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *password2;
@end

@implementation RegisterViewController

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
    _curCount = 0;
    _registerType = RegisterPhoneType;
    [self setupKKButtonBar];
    [self setupLoadingView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _orgFrame = self.tableView.frame;
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self reloadData:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    [self stopTimer];
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)registerMember:(id)sender {
    switch (_registerType) {
        case RegisterPhoneType:{
            // 手机注册
            [self registerPhone];
            break;
        }
        case RegisterEmailType:{
            // 邮箱注册
            [self registerEmail];
            break;
        }
        default:
            break;
    }
}
- (IBAction)getCheckCode:(id)sender {
    // 获取验证码
    [self startTimer];
    [self registerCheckCode];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (void)resetkkButtonBar {
    for(KKImageButton *kkButton in _kkButtonBar.items) {
        [kkButton setSelected:NO];
    }
}
- (void)setupKKButtonBar {
    [self resetkkButtonBar];
    self.kkButtonBar.items = [self customButtons];
}
- (NSArray *)customButtons {
    NSMutableArray *muableArray = [NSMutableArray array];
    KKImageButton *button;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MemberRegisterPhoneButton ofType:@"png"]];
    UIImage *imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MemberRegisterPhoneSelectedButton ofType:@"png"]];
    
    // 手机号码注册
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_PHONE;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    [button setTitle:@"手机号码注册" forState:(UIControlStateNormal)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [muableArray addObject:button];
    
    if(_registerType == RegisterPhoneType) {
        [button setSelected:YES];
    }
    
    // 邮箱注册
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MemberRegisterEmailButton ofType:@"png"]];
    imageSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MemberRegisterEmailSelectedButton ofType:@"png"]];
    
    button = [KKImageButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_BUTTON_EMAIL;
    [button addTarget:self action:@selector(kkButtonBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:KKButtonBarButtonSize];
    button.kkImage = image;
    button.kkSelectedImage = imageSelected;
    [button setSelected:NO];
    [button setTitle:@"邮箱注册" forState:(UIControlStateNormal)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [muableArray addObject:button];
    
    if(_registerType == RegisterEmailType) {
        [button setSelected:YES];
    }
    
    return muableArray;
}
#pragma mark - 数据逻辑
- (BOOL)checkInputData {
    if(_registerType == RegisterPhoneType) {
        // 电话注册
        if(self.phoneNumber.length == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写电话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else if(self.checkCode.length == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    else if(_registerType == RegisterEmailType) {
        // 邮箱注册
        if(self.email.length == 0 ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    if(self.password.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(![self.password isEqualToString:self.password2]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (BOOL)checkInputData4CheckCode {
    if(self.phoneNumber.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写电话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)reloadData:(BOOL)isReloadView {
    // 数据填充
    self.item = [ShopDataManager shopWithId:self.item.shopID];
    
    // 主tableView
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    CGSize viewSize;
    NSValue *rowSize;
    
    // logo图片
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterImageCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeLogoCell] forKey:ROW_TYPE];
    [array addObject:dictionary];

    if(_registerType == RegisterPhoneType) {
        // 手机号码
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterPhoneCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypePhoneCell] forKey:ROW_TYPE];
        [array addObject:dictionary];
        
        // 获取验证码
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterGetCheckCodeCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeGetCheckCodeCell] forKey:ROW_TYPE];
        [array addObject:dictionary];
        
        // 验证码
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterCheckCodeCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeCheckCodeCell] forKey:ROW_TYPE];
        [array addObject:dictionary];
        
        // 分隔
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterSepCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeSepCell] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }
    else {
        // 邮箱
        dictionary = [NSMutableDictionary dictionary];
        viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterEmailCell cellHeight]);
        rowSize = [NSValue valueWithCGSize:viewSize];
        [dictionary setValue:rowSize forKey:ROW_SIZE];
        [dictionary setValue:[NSNumber numberWithInteger:RowTypeEmailCell] forKey:ROW_TYPE];
        [array addObject:dictionary];
    }

    // 用户名
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterUsernameCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeUserNameCell] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 密码
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterPasswordCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePasswordCell] forKey:ROW_TYPE];
    [array addObject:dictionary];
    
    // 确认密码
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterPassword2Cell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypePasswordCell2] forKey:ROW_TYPE];
    [array addObject:dictionary];
    self.tableViewArray = array;
    
    // 注册
    dictionary = [NSMutableDictionary dictionary];
    viewSize = CGSizeMake(_tableView.frame.size.width, [RegisterCommitCell cellHeight]);
    rowSize = [NSValue valueWithCGSize:viewSize];
    [dictionary setValue:rowSize forKey:ROW_SIZE];
    [dictionary setValue:[NSNumber numberWithInteger:RowTypeCommitCell] forKey:ROW_TYPE];
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
            case RowTypeLogoCell:{
                // logo图片
                RegisterImageCell *cell = [RegisterImageCell getUITableViewCell:tableView];
                result = cell;
            }break;
            case RowTypePhoneCell:{
                // 手机号
                RegisterPhoneCell *cell = [RegisterPhoneCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.phoneNumber;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypePhoneCell;
            }break;
            case RowTypeEmailCell:{
                // 邮箱
                RegisterEmailCell *cell = [RegisterEmailCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.email;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeEmailCell;
            }break;
            case RowTypeGetCheckCodeCell:{
                // 获取验证码
                RegisterGetCheckCodeCell *cell = [RegisterGetCheckCodeCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.countLabel.text = self.count4CheckCodeTips;
                if(_curCount > 0) {
                    cell.button.hidden = YES;
                    cell.countLabel.hidden = NO;
                }
                else {
                    cell.button.hidden = NO;
                    cell.countLabel.hidden = YES;
                }
            }break;
            case RowTypeCheckCodeCell:{
                // 输入验证码
                RegisterCheckCodeCell *cell = [RegisterCheckCodeCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.checkCode;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeCheckCodeCell;
            }break;
            case RowTypeSepCell:{
                // 分隔符
                RegisterSepCell *cell = [RegisterSepCell getUITableViewCell:tableView];
                result = cell;
            }break;
                
            case RowTypeUserNameCell:{
                // 用户名
                RegisterUsernameCell *cell = [RegisterUsernameCell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.userName;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypeUserNameCell;
            }break;
            case RowTypePasswordCell:{
                // 密码
                RegisterPasswordCell *cell = [RegisterPasswordCell getUITableViewCell:tableView];
                result = cell;
                cell.textField.text = self.password;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypePasswordCell;
            }break;
            case RowTypePasswordCell2:{
                // 确认密码
                RegisterPassword2Cell *cell = [RegisterPassword2Cell getUITableViewCell:tableView];
                result = cell;
                
                cell.textField.text = self.password2;
                cell.textField.delegate = self;
                cell.textField.tag = RowTypePasswordCell2;
            }break;
            case RowTypeCommitCell:{
                // 注册
                RegisterCommitCell *cell = [RegisterCommitCell getUITableViewCell:tableView];
                result = cell;
                
                [cell.button addTarget:self action:@selector(registerMember:) forControlEvents:UIControlEventTouchUpInside];
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
            default:break;
        }
    }
}
- (void)kkButtonBarButtonAction:(id)sender {
    KKImageButton *button = (KKImageButton *)sender;
    for(KKImageButton *kkButton in _kkButtonBar.items) {
        // 取消其他按钮选中状态
        if(button.tag != kkButton.tag) {
            [kkButton setSelected:NO];
        }
    }
    // 根据按钮,显示界面
    [button setSelected:YES];
    switch (button.tag) {
        case TAG_BUTTON_PHONE:{
            _registerType = RegisterPhoneType;
            break;
        }
        case TAG_BUTTON_EMAIL:{
            _registerType = RegisterEmailType;
            break;
        }
        default:
            break;
    }
    [self reloadData:YES];
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
#pragma mark - 输入回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == RowTypePhoneCell) {
        self.phoneNumber = textField.text;
    }
    else if(textField.tag == RowTypeEmailCell) {
        self.email = textField.text;
    }
    else if(textField.tag == RowTypeCheckCodeCell) {
        self.checkCode = textField.text;
    }
    else if(textField.tag == RowTypeUserNameCell) {
        self.userName = textField.text;
    }
    else if(textField.tag == RowTypePasswordCell) {
        self.password = textField.text;
    }
    else if(textField.tag == RowTypePasswordCell2) {
        self.password2 = textField.text;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == RowTypePhoneCell) {
        self.phoneNumber = textField.text;
    }
    else if(textField.tag == RowTypeEmailCell) {
        self.email = textField.text;
    }
    else if(textField.tag == RowTypeCheckCodeCell) {
        self.checkCode = textField.text;
    }
    else if(textField.tag == RowTypeUserNameCell) {
        self.userName = textField.text;
    }
    else if(textField.tag == RowTypePasswordCell) {
        self.password = textField.text;
    }
    else if(textField.tag == RowTypePasswordCell2) {
        self.password2 = textField.text;
    }
    return YES;
}
#pragma mark - 倒计时
- (void)startTimer {
    // TODO:开始每秒刷新计时状态
    _curCount = 20;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)timerFireMethod:(NSTimer*)theTimer {
    if(_curCount > 0) {
        self.count4CheckCodeTips = [NSString stringWithFormat:@"正在获取验证码，重新获取还需要等待:%d", _curCount--];
    }
    else {
        self.count4CheckCodeTips = [NSString stringWithFormat:@"请输入验证码"];
        [self stopTimer];
    }
    [self reloadData:YES];
}
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
    [self.kkLoadingView cancelLoading];
}
- (BOOL)registerCheckCode {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    if(![self checkInputData4CheckCode])
        return NO;
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator getCheckCode:self.phoneNumber];
}
- (BOOL)registerPhone {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    if(![self checkInputData])
        return NO;
    
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator registerPhoneNumber:self.phoneNumber pwd:self.password checkCode:self.checkCode userName:self.userName];
}
- (BOOL)registerEmail {
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    if(![self checkInputData])
        return NO;
    
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator registerEmail:self.email pwd:self.password userName:self.userName];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    switch(type){
        case ShopRequestOperatorStatus_RegisterCheckCode:{
            [self setTopStatusText:@"获取验证码成功"];
            break;
        }
        case ShopRequestOperatorStatus_RegisterPhone:{
            [self setTopStatusText:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ShopRequestOperatorStatus_RegisterEmail:{
            [self setTopStatusText:@"注册成功"];
            NSString *message = @"注册成功,请查看邮件激活会员";
            id foundValue = [data objectForKey:RegisterMessage];
            if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
                message = foundValue;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.cancelButtonIndex = -1;
            [alertView show];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:error];
    switch(type){
        case ShopRequestOperatorStatus_RegisterCheckCode:{
            break;
        }
        case ShopRequestOperatorStatus_RegisterPhone:{
            break;
        }
        case ShopRequestOperatorStatus_RegisterEmail:{
            break;
        }
        default:break;
    }
}
@end
