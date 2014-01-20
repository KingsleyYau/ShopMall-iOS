//
//  ShopRankListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopTableView.h"
#import "RankListTableView.h"

@interface ShopRankListViewController : BaseViewController <ShopTableViewDelegate, KKDynamicViewDelegate, KKButtonBarDelegete>

@property (nonatomic, weak) IBOutlet KKButtonBar *kkButtonBar;
@property (nonatomic, weak) IBOutlet KKDynamicView *kkDynamicView;
@property (nonatomic, weak) IBOutlet ShopTableView *tableView;
@property (nonatomic, weak) IBOutlet RankListTableView *rankListTableView;
@property (nonatomic, weak) IBOutlet KKImageButton *titleButton;

@property (nonatomic, retain) KKLoadingView *kkLoadingView;

- (IBAction)titleAction:(id)sender;
@end
