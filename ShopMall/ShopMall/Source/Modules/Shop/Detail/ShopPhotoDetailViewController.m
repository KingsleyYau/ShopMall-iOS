//
//  ShopPhotoDetailViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-7.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopPhotoDetailViewController.h"

#define TITLE_WIDTH 115
#define TIME_WIDTH 140

@interface ShopPhotoDetailViewController () <RequestImageViewDelegate> {
    BOOL _fullScreen;
}
@property (nonatomic, retain) NSArray *items;
@end

@implementation ShopPhotoDetailViewController

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
    
    self.userLabel.text = @"";
    self.titleLabel.text = @"";
    self.timeLabel.text = @"";
    self.priceLabel.text = @"";
    
    self.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    self.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    self.kkRankSelector.canEditable = NO;
    self.kkRankSelector.numberOfRank = 5;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupNavigationBar];
    [self reloadData:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetNavigationBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面逻辑
- (IBAction)saveAction:(id)sender {
    ShopImage *shopImage = [self.items objectAtIndex:_curIndex];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:shopImage.fullFile.data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)resetNavigationBar {
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBar.alpha = 1.0;
}
- (void)setupNavigationBar {
    [super setupNavigationBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"商户图片详细";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    

    UIBarButtonItem *barButtonItem = nil;
    UIImage *image = nil;
    
    // 右边按钮
    NSMutableArray *array = [NSMutableArray array];
    // 最新按钮
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NavigationDownloadButton ofType:@"png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [array addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems = array;

    if (!_fullScreen) {
        self.navigationController.navigationBar.alpha = 0.8;
        // fade in navigation
    }
    else {
        // fade out navigation
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
}
#pragma mark - 数据逻辑
- (void)reloadDetailView {
    if(self.items.count > 0 && _curIndex < self.items.count) {
        // 加载数据
        ShopImage *shopImage = [self.items objectAtIndex:_curIndex];
        self.userLabel.text = shopImage.uploadUser;
        self.kkRankSelector.curRank = [shopImage.star integerValue];
        self.titleLabel.text = shopImage.imgName;
        self.timeLabel.text = [NSString stringWithFormat:@"上传于:%@", [shopImage.uploadTime  toStringYMDHM]];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", shopImage.price];
        
        // 重画界面
        CGSize sizeTitle = [self.titleLabel sizeThatFits:CGSizeZero];
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, MIN(sizeTitle.width, TITLE_WIDTH), _titleLabel.frame.size.height);
        
        CGSize sizeTime = [self.timeLabel sizeThatFits:CGSizeZero];
        self.timeLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + BLANKING_X, self.timeLabel.frame.origin.y, MIN(TIME_WIDTH, sizeTime.width), self.timeLabel.frame.size.height);
    }
}
- (void)reloadData:(BOOL)isReloadView{
    self.items = [ShopDataManager shopImageWithShopID:self.item.shopID imageType:nil];
    if(isReloadView && self.items.count > 0) {
        [self.pagingScrollView displayPagingViewAtIndex:_curIndex];
        [self reloadDetailView];
    }
}
#pragma mark - 图片画廊回调 (PZPagingScrollViewDelegate)
- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index {
    return [RequestImageView class];
}

- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView {
    //return self.images.count;
    return (nil == self.items)?0:self.items.count;
}
- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index {
    UIView *view = nil;
    RequestImageView *requestView = [[RequestImageView alloc] initWithFrame:self.view.bounds];
    requestView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    requestView.contentMode = UIViewContentModeScaleAspectFit;
    requestView.backgroundColor = [UIColor clearColor];
    requestView.isPhotoView = YES;
    requestView.delegate = self;
    view = requestView;
    
    return view;
}

- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index {
    //assert([pageView isKindOfClass:[PZPhotoView class]]);
    assert(index < self.items.count);
    
    ShopImage *shopImage = [self.items objectAtIndex:index];
    RequestImageView *requestView = (RequestImageView *)pageView;
    requestView.imageUrl = shopImage.fullFile.path;
    requestView.imageData = shopImage.fullFile.data;
    requestView.contentType = shopImage.fullFile.contentType;
    [requestView loadImage];
}
- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView didShowPageViewForDisplay:(NSUInteger)index {
    _curIndex = index;
    [self reloadDetailView];
}
#pragma mark - 缩略图界面回调 (RequestImageViewDelegate)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    NSInteger index = imageView.tag;
    File *file = [ShopDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
        [self reloadData:NO];
    }
    if(_pagingScrollView)
        [_pagingScrollView displayPagingViewAtIndex:index];
}
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
    // 竖屏才能显示工具栏
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _fullScreen = !_fullScreen;
        [self toggleFullScreen];
    }
}
#pragma mark - 全屏显示 ()
- (void)toggleFullScreen {
    [self setupNavigationBar];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(!error && image) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
@end
