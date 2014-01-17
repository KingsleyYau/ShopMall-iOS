//
//  LoadingView.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-26.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    UIActivityIndicatorView*    _activityIndicatorView;
    BOOL    _isShowLoading;
}

-(void)showLoading:(UIView*)parent animated:(BOOL)animated;
-(void)hideLoading:(BOOL)animated;
@end
