//
//  BaseViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-4-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKViewController.h"
@interface BaseViewController : KKViewController
- (void)setTopStatusText:(NSString *)text;
- (void)setupNavigationBar;
- (void)setupBackgroundView;
@end
