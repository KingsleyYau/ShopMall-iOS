//
//  ShopCommitCommentViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopCommitCommentViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KKTextView *textView;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector1;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector2;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector3;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;
@property (nonatomic, retain) Shop *item;

- (IBAction)backAction:(id)sender;
- (IBAction)commitAction:(id)sender;
@end
