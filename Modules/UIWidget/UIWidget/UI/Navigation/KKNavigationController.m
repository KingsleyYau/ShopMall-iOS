//
//  KKNavigationController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKNavigationController.h"
#import "CustomNavigationBar.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"
@interface KKNavigationController () <UINavigationControllerDelegate, UINavigationBarDelegate> {
}
// 手势
- (void)setUpGestureRecognizers:(UIViewController *)viewController;
- (void)removeGestureRecognizers:(UIViewController *)viewController;
// 默认风格
- (void)setupNavigationBar:(UIViewController *)viewController;
// 自定义返回按钮
- (void)setCustomBackButton:(UINavigationItem *)item;
@end

@implementation KKNavigationController
@synthesize kkDelegate = _kkDelegate;
@synthesize customTitleImage;
#pragma mark - 界面旋转控制
- (BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}
- (NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
#pragma mark - 重载父类
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self setupNavigationBar:nil];
    self.isCustomBackButton = YES;
    self.kkDelegate = nil;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)initDelegate {
    self.delegate = (id<UINavigationControllerDelegate>)self;
}
- (id)init {
    if(self = [super init]) {
    }
    return self;
}
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    if(self = [super initWithRootViewController:rootViewController]) {
        [self setupNavigationBar:rootViewController];
    }
    return self;
}
- (void)dealloc {
    self.kkDelegate = nil;
    self.customTitleImage = nil;
    [super dealloc];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Custom here
    [self setupNavigationBar:viewController];
    
    // TODO:改变KKNavigationControllerDelegate回调对象为最顶层界面
    self.kkDelegate = (id<KKNavigationControllerDelegate>) viewController;
    if(self.kkDelegate && [self.kkDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]){
        [self.kkDelegate navigationController:self willShowViewController:viewController animated:animated];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Custom here
    if(self.kkDelegate && [self.kkDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]){
        [self.kkDelegate navigationController:self didShowViewController:viewController animated:animated];
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated gesture:(BOOL)gesture {
    if(gesture) {
        // TODO:加入栈之前先添加手势
        [self setUpGestureRecognizers:viewController];
    }
    [self pushViewController:viewController animated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // TODO:自定义标题
    [self setTitleView:viewController.navigationItem];

    if(self.isCustomBackButton) {
        // TODO:自定义后退按钮
        viewController.navigationItem.hidesBackButton = YES;
        UINavigationItem *item = viewController.navigationItem;
        [self setCustomBackButton:item];
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // TODO:出栈之后先去除手势
    self.kkDelegate = nil;
    UIViewController *uIViewController = [super popViewControllerAnimated:animated];
    [self removeGestureRecognizers:uIViewController];
    return uIViewController;
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.kkDelegate = nil;
    // TODO:出栈之后先去除手势
    NSArray *array = [super popToViewController:viewController animated:animated];
    for(UIViewController *uIViewController in array) {
        [self removeGestureRecognizers:uIViewController];
    }
    return array;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    // TODO:出栈之后先去除手势
    NSArray *array = [super popToRootViewControllerAnimated:animated];
    for(UIViewController *uIViewController in array) {
        [self removeGestureRecognizers:uIViewController];
    }
    return array;
}
#pragma mark - 添加手势
- (void)setUpGestureRecognizers:(UIViewController *)viewController {
    // TODO:加入向右边滑动手势
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesture:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [viewController.view addGestureRecognizer:rightSwipeGesture];
    [rightSwipeGesture release];
    
    // TODO:加入向左边滑动手势
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [viewController.view addGestureRecognizer:leftSwipeGesture];
    [leftSwipeGesture release];
}
- (void)removeGestureRecognizers:(UIViewController *)viewController {
    for (UIGestureRecognizer *gestureRecognizer in [viewController.view gestureRecognizers]) {
        [viewController.view removeGestureRecognizer:gestureRecognizer];
    }
}
#pragma mark - 手势回调
- (void)leftSwipeGesture:(UIGestureRecognizer *)gestureRecognizer {
    // TODO:向左边滑动手势回调
}
- (void)rightSwipeGesture:(UIGestureRecognizer *)gestureRecognizer {
    // TODO:向右边滑动手势回调
    [self popViewControllerAnimated:YES];
}
#pragma mark - 导航栏默认布局风格
- (void)setupNavigationBar:(UIViewController *)viewController {
    // TODO:导航栏默认背景
    [self.navigationBar setDefaultBackgroundImage];
}
#pragma mark - 导航栏控件回调
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    if(!self.isCustomBackButton) {
        // TODO:重定义默认后退按钮事件触发
        UINavigationItem *backItem = navigationBar.backItem;
        backItem.backBarButtonItem.target = self;
        backItem.backBarButtonItem.action = @selector(backAction:);
    }
}
#pragma mark - 自定义导航栏

- (void)setCustomBackButton:(UINavigationItem *)item {
    // TODO:自定义返回按钮
    UIImage *image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:NavigationBackButton]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(!self.isCustomNoTitleBackButton) {
        [button setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:NavigationBackButtonC]];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:NavigationBackButton]] forState:UIControlStateNormal];
//    [backButton sizeToFit];
    
    UIBarButtonItem *leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    item.leftBarButtonItem = leftBarButtonItem;
}
- (void)setTitleView:(UINavigationItem *)item {
    if (self.customTitleImage && (nil == item.titleView)){
        UIImageView *titleView = [[[UIImageView alloc] initWithImage:self.customTitleImage] autorelease];
        item.titleView = titleView;
    }
}
- (void)backAction:(id)sender {
    // TODO:ViewController自己处理是否返回
    if(self.kkDelegate && [self.kkDelegate respondsToSelector:@selector(backAction)]) {
        [self.kkDelegate backAction];
    }
    else
        [self popViewControllerAnimated:YES];
}
@end
