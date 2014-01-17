//
//  PZPagingScrollView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"
@protocol PZPagingScrollViewDelegate;

@interface PZPagingScrollView : UIScrollView

@property (assign, nonatomic) IBOutlet id<PZPagingScrollViewDelegate>pagingViewDelegate;
@property (readonly) UIView *visiblePageView;
@property (assign) BOOL suspendTiling;

- (void)displayPagingViewAtIndex:(NSUInteger)index;
- (void)resetDisplay;

@end

@protocol PZPagingScrollViewDelegate <NSObject>

@required

- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index;
- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView;
- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index;
- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index;
- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView didShowPageViewForDisplay:(NSUInteger)index;
@end
