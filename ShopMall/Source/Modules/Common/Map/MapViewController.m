//
//  MapViewController.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
- (id)init {
    if(self = [super init]) {
    }
    return self;
}
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
//    [self setupMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* Load mapView to view hierarchy. */
    [self setupMapView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    
    /* Reset map view. */
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.rotationDegree = 0.f;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    /* Remove from view hierarchy. */
    [self.mapView removeFromSuperview];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setupMapView {
//    if(!self.mapView) {
//        self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
//    }
    self.mapView = AppDelegate().mapView;
    self.mapView.delegate = self;
    self.mapView.frame = self.view.bounds;
    self.mapView.showsUserLocation = NO;
    [self.view addSubview:self.mapView];
}

- (NSString*)keyForMap {
    return @"340049090983b7a436499d9c67aa7e57";
}


/*!
 @brief 地图加载成功
 @param mapView 地图View
 @param dataSize 数据大小
 */
- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView dataSize:(NSInteger)dataSize {
    NSLog(@"地图加载成功 size:%d", dataSize);
}
/*!
 @brief 地图加载失败
 @param mapView 地图View
 @param error 错误信息
 */
- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error {
    NSLog(@"地图加载失败:%@", [error description]);
//    [self.mapView reloadMap];
}
/*!
 @brief 离线地图数据将要被加载, 调用reloadMap会触发该回调，离线数据生效前的回调.
 @param mapview 地图View
 */
- (void)offlineDataWillReload:(MAMapView *)mapView {
     NSLog(@"离线地图数据将要被加载");
}

/*!
 @brief 离线地图数据加载完成, 调用reloadMap会触发该回调，离线数据生效后的回调.
 @param mapview 地图View
 */
- (void)offlineDataDidReload:(MAMapView *)mapView {
    NSLog(@"离线地图数据加载完成");
}

/*!
 @brief 用户位置更新后，会调用此函数
 @param mapView 地图View
 @param userLocation 新的用户位置
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation {
    NSLog(@"用户位置更新后完成");
}
@end
