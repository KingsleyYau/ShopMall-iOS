//
//  LoginViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-3.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate,  LoginManagerDelegate> {
    CGRect _orgFrame;
}

@end

@implementation LoginViewController

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
    _orgFrame = self.scrollView.frame;
    // 添加键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LoginManagerInstance() addDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancel];
    [self closeKeyboard];
    // 去除键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [LoginManagerInstance() removeDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面布局
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)loginAction:(id)sender {
    [self commit];
}
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"登陆";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    UIButton *button = nil;
    
    // 左边边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 返回按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationBackButton2 ofType:@"png"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.leftBarButtonItems = array;
}
#pragma mark - 界面逻辑
- (void)closeKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
- (BOOL)checkInputData {
    if(self.usernameTextField.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(self.passwordTextField.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark - 处理键盘回调
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:duration];
    if(height > 0) {
        // 弹出键盘
        self.scrollView.frame = CGRectMake(_orgFrame.origin.x, _orgFrame.origin.y, _orgFrame.size.width, _orgFrame.size.height - height);
    }
    else {
        self.scrollView.frame = _orgFrame;
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
    if(textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }
    else if(textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - 协议请求
- (void)cancel {
    LoginManager *loginManager = LoginManagerInstance();
    [loginManager cancel];
    [self.kkLoadingView cancelLoading];
}
- (BOOL)commit {
    if(![self checkInputData]) {
        return NO;
    }
    [self.kkLoadingView startLoadingInView:self.view];
    LoginManager *loginManager = LoginManagerInstance();
    return [loginManager login:self.usernameTextField.text password:self.passwordTextField.text];
}

#pragma mark - LoginManagerDelegate
- (void)loginStatusChanged:(LoginStatus)status
{
    if (LoginStatus_online == status) {
        // 登陆成功
    }
    else {
        // 注销成功
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self backAction:nil];
    });
}
- (void)handleError:(LoginManagerHandleStatus)status error:(NSString*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancel];
        [self setTopStatusText:error];
    });
}
@end
