//
//  ShopCommitBugViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopCommitBugViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;
@property (nonatomic, retain) Shop *item;
@property (nonatomic, retain) UIImage *signImage;

- (IBAction)backAction:(id)sender;
- (IBAction)commitAction:(id)sender;
@end
