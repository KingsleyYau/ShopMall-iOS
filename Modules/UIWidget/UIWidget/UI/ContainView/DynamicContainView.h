//
//  DynamicContainView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-21.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicContainView;
@protocol DynamicContainViewDelegete <NSObject>
- (UIView *)viewForDetail:(DynamicContainView *)dynamicContainView;
- (UIView *)dynamicContainView:(DynamicContainView *)dynamicContainView viewForPithy:(CGRect)frame wholeFrame:(CGRect)wholeFrame;
@optional
- (void)didShowDynamicContainView:(DynamicContainView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration;
- (void)didHideDynamicContainView:(DynamicContainView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration;
@end
@interface DynamicContainView : UIView {
    Boolean _isAnimating;
}
@property (nonatomic, assign) IBOutlet id<DynamicContainViewDelegete> delegate;
@property (nonatomic, assign, readonly) UIButton *showButton;
@property (nonatomic, readonly) Boolean isAnimating;
@property (nonatomic, assign) BOOL isDown;
           
- (id)initWithFrame:(CGRect)frame isDown:(BOOL)Down;
- (void)reLoadView;
- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;
- (void)initialize;
@end
