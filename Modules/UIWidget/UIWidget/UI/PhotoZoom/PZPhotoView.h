//
//  PZPhotoView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PZPhotoViewDelegate;

@interface PZPhotoView : UIScrollView

@property (assign, nonatomic) IBOutlet id<PZPhotoViewDelegate> photoViewDelegate;

- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;

- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;

@end

@protocol PZPhotoViewDelegate <NSObject>

@optional

- (void)photoViewDidSingleTap:(PZPhotoView *)photoView;
- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView;
- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView;
- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView;

@end