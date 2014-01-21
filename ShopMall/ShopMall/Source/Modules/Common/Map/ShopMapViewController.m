//
//  ShopMapViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 14-1-10.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "ShopMapViewController.h"

#import "SelfMapAnnotation.h"
#import "ShopMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"
#import "ShopAnnotationCell.h"

#define TAG_VIEW_SHOPCELL      1001

@interface ShopMapViewController ()
@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) SelfMapAnnotation *selfAnnotation;
@end

@implementation ShopMapViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
    self.mapView.showsUserLocation = NO;
}
#pragma mark - 界面逻辑
- (void)setupMapView {
    [super setupMapView];
    self.mapView.showsUserLocation = YES;
    self.mapView.hidden = NO;
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
    [self setAnnotions];
}
- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"商户地址";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // 右边按钮
    NSMutableArray *array = [NSMutableArray array];
    UIBarButtonItem *barButtonItem = nil;
    
    barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(guideAction:)];
    
    if(NSOrderedAscending == [[[UIDevice currentDevice] systemVersion] compare:@"7.0"]) {
        // ios 7 before
    }
    else {
        barButtonItem.tintColor = [UIColor whiteColor];
    }
    
    [array addObject:barButtonItem];
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setAnnotions {
    // 根据当前位置显示位置
    SignInManager *signManager = SignInManagerInstance();
    
    CGFloat regionRadus = MAX(REGION_RADUS, [signManager getDistanceMeter:[self.item.lat doubleValue] lon:[self.item.lon doubleValue]]);
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([signManager.checkInLocation toMarsLocation].coordinate.latitude, [signManager.checkInLocation toMarsLocation].coordinate.longitude);
    
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location, 3 * regionRadus,3 * regionRadus);
    MACoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    // 商店标签
    CLLocation *shopLocation = [[[CLLocation alloc] initWithLatitude:[self.item.lat doubleValue] longitude:[self.item.lon doubleValue]] toMarsLocation];

    ShopMapAnnotation *shopAnnotation = [[ShopMapAnnotation alloc] initWithLatitude:shopLocation.coordinate.latitude andLongitude:shopLocation.coordinate.longitude];
    [self.mapView addAnnotation:shopAnnotation];
}
- (void)guideAction:(id)sender {
    // 根据当前位置显示位置
    SignInManager *signManager = SignInManagerInstance();
    
    // 系统地图导航
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        // ios6以下，调用google map
        CLLocation *selfLocation = [signManager.checkInLocation toMarsLocation];
        
        CLLocation *shopLocation = [[[CLLocation alloc] initWithLatitude:[self.item.lat doubleValue] longitude:[self.item.lon doubleValue]] toMarsLocation];
        
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",selfLocation.coordinate.latitude, selfLocation.coordinate.longitude, shopLocation.coordinate.latitude, shopLocation.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        CLLocation *shopLocation = [[[CLLocation alloc] initWithLatitude:[self.item.lat doubleValue] longitude:[self.item.lon doubleValue]] toMarsLocation];
        
        CLLocationCoordinate2D to;
        to.latitude = shopLocation.coordinate.latitude;//[self.item.lat doubleValue];
        to.longitude = shopLocation.coordinate.longitude;//[self.item.lon doubleValue];
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    
    //    // 高德地图导航
    //    CLLocation *selfLocation = [signManager.checkInLocation toMarsLocation];
    //
    //    CLLocation *shopLocation = [[[[CLLocation alloc] initWithLatitude:[self.item.lat doubleValue] longitude:[self.item.lon doubleValue]] autorelease] toMarsLocation];
    //
    //    MARouteSearchOption *searchOption = [[[MARouteSearchOption alloc] init] autorelease];
    //
    //    searchOption.x1 = [NSString stringWithFormat:@"%f", selfLocation.coordinate.longitude];
    //    searchOption.y1 = [NSString stringWithFormat:@"%f", selfLocation.coordinate.latitude];
    //    searchOption.x2 = [NSString stringWithFormat:@"%f", shopLocation.coordinate.longitude];
    //    searchOption.y2 = [NSString stringWithFormat:@"%f", shopLocation.coordinate.latitude];
    //    searchOption.config= @"R";
    //
    //    MASearch *search = [MASearch maSearchWithDelegate:self];
    //    [search routeSearchWithOption:searchOption];
}
#pragma mark - 地图回调
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        // 商铺弹出
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CallOutAnnotationView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CallOutAnnotationView"];
            
            ShopAnnotationCell *cell = [ShopAnnotationCell getCell];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.layer.borderColor = [[UIColor brownColor] CGColor];
            cell.layer.borderWidth = 2;
            cell.layer.cornerRadius = 5;
            
            cell.tag = TAG_VIEW_SHOPCELL;
            [annotationView.contentView addSubview:cell];
        }
        else {
            annotationView.annotation = annotation;
        }
        ShopAnnotationCell *cell = (ShopAnnotationCell *)[annotationView.contentView viewWithTag:TAG_VIEW_SHOPCELL];
        
        cell.accessoryView.hidden = YES;
        cell.titleLabel.text = self.item.shopName;
        cell.kkRankSelector.curRank = [self.item.score integerValue] / RankOfScore;
        NSString *detail = [NSString stringWithFormat:@"%@ %@", self.item.address, self.item.category.categoryName];
        cell.detailLabel.text = detail;
        return annotationView;
    }
    if ([annotation isKindOfClass:[ShopMapAnnotation class]]) {
        // 商铺
        //        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopMapAnnotationView"];
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopMapAnnotationView"];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:@"ShopMapAnnotationView"];
            annotationView.animatesDrop = YES; // 从天而降的效果
            annotationView.canShowCallout = NO; // 可以弹出
            annotationView.pinColor = MAPinAnnotationColorRed;
            //            cell.image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:ShopAnnotationImage]];
        }
        else {
            annotationView.annotation = annotation;
        }
		return annotationView;
    }
    else if([annotation isKindOfClass:[SelfMapAnnotation class]]){
        // 当前位置
        //        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SelfMapAnnotationView"];
        MAAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SelfMapAnnotationView"];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SelfMapAnnotationView"];
            annotationView.canShowCallout = YES; // 可以弹出
            annotationView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SelfAnnotationImage ofType:@"png"]];
        }
        else {
            annotationView.annotation = annotation;
        }
		return annotationView;
    }
	return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
	if ([view.annotation isKindOfClass:[ShopMapAnnotation class]]) {
        // 点击商铺
        if (self.calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude &&
            self.calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (self.calloutAnnotation) {
            [mapView removeAnnotation:self.calloutAnnotation];
            self.calloutAnnotation = nil;
        }
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:view.annotation.coordinate.latitude
                                  andLongitude:view.annotation.coordinate.longitude];
        self.calloutAnnotation.tag = ((ShopMapAnnotation *)view.annotation).tag;
        [mapView addAnnotation:self.calloutAnnotation];
        
        [mapView setCenterCoordinate:self.calloutAnnotation.coordinate animated:YES];
	}
    else {
        if([view.annotation isKindOfClass:[CalloutMapAnnotation class]]){
            // 点击商户弹出界面
        }
        else if([view.annotation isKindOfClass:[SelfMapAnnotation class]]){
            // 点击当前位置
        }
        if(self.calloutAnnotation) {
            [mapView removeAnnotation:self.calloutAnnotation];
            self.calloutAnnotation = nil;
        }
    }
}
@end
