//
//  ShopCommitSignViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopCommitSignViewController.h"

#define ImagePickerReferenceURLKey  @"UIImagePickerControllerReferenceURL"
#define ImagePickerOriginalImageKey @"UIImagePickerControllerOriginalImage"

@interface ShopCommitSignViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShopRequestOperatorDelegate> {
    CGRect _orgFrame;
}
@property (nonatomic, retain) ShopRequestOperator *requestOperator;
@end

@implementation ShopCommitSignViewController

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
    
    self.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector.canEditable = YES;
    self.kkRankSelector.numberOfRank = 5;
    self.textView.text = @"";
    
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
- (IBAction)cameraAction:(id)sender {
    // 上传图片
    UIActionSheet* sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [sheet addButtonWithTitle:@"拍照上传"];
    }
    [sheet addButtonWithTitle:@"上传手机中的图片"];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"取消"];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}
- (IBAction)commitAction:(id)sender {
    [self commit];
}
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)closeKeyboard {
    [self.textView resignFirstResponder];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能提交" message:@"您至少输入6字留言！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        bFlag = NO;
    }
    return bFlag;
}
#pragma mark - 图片功能 (UIActionSheetDelegate)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex || 1 == buttonIndex){
        // 0(拍照) 1(照片)
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = (1 == buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
        [self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
}
#pragma mark - 图片功能 (UIImagePickerControllerDelegate)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 淡出UIImagePickerController
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *resizeImage = (UIImage*)[info objectForKey:ImagePickerOriginalImageKey];
    CGFloat scale = resizeImage.size.width / resizeImage.size.height;
    NSInteger maxSize = 1024.0f;
    if (scale > 1.0f){
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize, maxSize / scale) interpolationQuality:kCGInterpolationDefault];
    }
    else {
        resizeImage = [resizeImage resizedImage:CGSizeMake(maxSize * scale, maxSize) interpolationQuality:kCGInterpolationDefault];
    }
    self.signImage = resizeImage;
    [self.cameraButton setImage:self.signImage forState:UIControlStateNormal];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
    if(![self checkInputData])
        return NO;
    [self cancel];
    if(!self.requestOperator) {
        self.requestOperator = [[ShopRequestOperator alloc] init];
        self.requestOperator.delegate = self;
    }
    [self.kkLoadingView startLoadingInView:self.view];
    return [self.requestOperator submitShopSign:self.item.shopID score:self.kkRankSelector.curRank * RankOfScore body:self.textView.text image:self.signImage];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {

    switch(type){
        case ShopRequestOperatorStatus_CommitShopSign:{
            [self cancel];
            [self setTopStatusText:@"签到成功"];
            [self backAction:nil];
        } break;
        default:break;
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {

    switch(type){
        case ShopRequestOperatorStatus_CommitShopSign:{
            [self cancel];
            [self setTopStatusText:@"签到失败"];
            
        }break;
        default:break;
    }
}

@end
