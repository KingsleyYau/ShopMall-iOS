//
//  WebViewController.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-6.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>{
    NSString *_webPath;
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic, retain) NSString  *webPath;
@end
