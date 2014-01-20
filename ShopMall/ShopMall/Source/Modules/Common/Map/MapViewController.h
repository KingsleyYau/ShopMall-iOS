//
//  MapViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#define REGION_RADUS 100

@protocol MapViewControllerDelegate <NSObject>
@optional
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view;
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : BaseViewController /*<MKMapViewDelegate>*/ <MAMapViewDelegate>{
    //MKMapView *_mapView;
    MAMapView *_mapView;
}
//@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, strong) MAMapView *mapView;
//@property(nonatomic, assign) id<MapViewControllerDelegate> delegate;

- (void)setupMapView;
@end
