//
//  KKLoadingView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-24.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKLoadingView;
@protocol KKLoadingViewDelegate <NSObject>
@optional
- (void)didCancelLoading:(KKLoadingView *)kkLoadingView;
@end
@interface KKLoadingView : UIView {
    
}
@property (nonatomic, assign) id<KKLoadingViewDelegate> delegate;
- (void)startLoadingInView:(UIView *)view;
- (void)cancelLoading;
@end
