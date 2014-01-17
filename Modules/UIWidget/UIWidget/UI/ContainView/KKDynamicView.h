//
//  KKDynamicButton.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-1.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKDynamicView;
@protocol KKDynamicViewDelegate <NSObject>
- (UIView *)viewForDetail:(KKDynamicView *)dynamicContainView;
@optional
- (void)didShowDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration;
- (void)didHideDynamicContainView:(KKDynamicView *)dynamicContainView boundsSize:(CGSize)boundsSize duration:(CGFloat)duration;
- (void)didTouchOverlayContainView:(KKDynamicView *)dynamicContainView;
@end
@interface KKDynamicView : UIView {
    
}
@property (nonatomic, assign) IBOutlet id<KKDynamicViewDelegate> delegate;
@property (nonatomic, assign) BOOL isShowOverlay;
@property (nonatomic, assign) BOOL isDown;
- (id)initWithFrame:(CGRect)frame isDown:(BOOL)Down;
- (void)reLoadView;
- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;
@end
