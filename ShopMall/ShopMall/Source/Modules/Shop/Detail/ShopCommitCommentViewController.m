//
//  ShopCommitCommentViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopCommitCommentViewController.h"

@interface ShopCommitCommentViewController () <UIActionSheetDelegate, ShopRequestOperatorDelegate> {
    CGRect _orgFrame;
}
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@property (nonatomic, retain) NSString *priceString;
@property (nonatomic, retain) NSString *bodyString;
@end

@implementation ShopCommitCommentViewController

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
    
    self.textView.text = @"";
    [self setupKKRankSelectors];
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
- (IBAction)commitAction:(id)sender {
    [self commit];
}
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)closeKeyboard {
    [self.textView resignFirstResponder];
}
- (void)setupKKRankSelectors {
    self.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector.canEditable = YES;
    self.kkRankSelector.numberOfRank = 5;
    
    self.kkRankSelector1.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector1.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector1.canEditable = YES;
    self.kkRankSelector1.numberOfRank = 5;
    
    self.kkRankSelector2.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector2.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector2.canEditable = YES;
    self.kkRankSelector2.numberOfRank = 5;
    
    self.kkRankSelector3.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector3.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector3.canEditable = YES;
    self.kkRankSelector3.numberOfRank = 5;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"添加签到";
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
- (void)setupLoadingView {
    self.kkLoadingView = [[KKLoadingView alloc] initWithFrame:CGRectZero];
}
- (BOOL)checkInputData {
    BOOL bFlag = YES;
    if(self.textView.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"您至少输入6字点评！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        bFlag = NO;
    }
    return bFlag;
}
#pragma mark - 输入回调
- (void)textViewDidChange:(UITextView *)textView {
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([textView isKindOfClass:[KKTextView class]]) {
        KKTextView *kkTextView = (KKTextView *)textView;
        if(textView.text.length < 6) {
            kkTextView.tipsLabel.text = [NSString stringWithFormat:@"您还需要输入%d字", 6 - textView.text.length];
        }
        else {
            kkTextView.tipsLabel.text = @"";
        }
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([textView isKindOfClass:[KKTextView class]]) {
        KKTextView *kkTextView = (KKTextView *)textView;
        if(textView.text.length < 6) {
            kkTextView.tipsLabel.text = [NSString stringWithFormat:@"您还需要输入%d字", 6 - textView.text.length];
        }
        else {
            kkTextView.tipsLabel.text = @"";
        }
    }
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
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
#pragma mark - 协议请求
- (void)cancel {
    if(self.requestOperator) {
        [self.requestOperator cancel];
    }
    [self.kkLoadingView cancelLoading];
}
- (BOOL)commit {
    [self closeKeyboard];
    if(![self checkInputData])
        return NO;
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator submitShopComment:self.item.shopID score:RankOfScore * (self.kkRankSelector.curRank) scorePdu:RankOfScore * (self.kkRankSelector1.curRank) scoreEnv:RankOfScore * (self.kkRankSelector2.curRank) scoreSrv:RankOfScore * (self.kkRankSelector3.curRank) scoreOth:0 body:self.self.textView.text];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:@"点评成功"];
    switch(type){
        case ShopRequestOperatorStatus_CommitShopComment:{
            [self backAction:nil];
            break;
        }
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    [self cancel];
    [self setTopStatusText:@"点评失败"];
    switch(type){
        case ShopRequestOperatorStatus_CommitShopComment:{
            break;
        }
        default:break;
    }
}

@end
