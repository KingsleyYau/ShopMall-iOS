//
//  ShopRankDetailViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopTableView.h"
@interface ShopRankDetailViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ShopTableView *tableView;
@property (nonatomic, strong) Rank *rank;
@property (nonatomic, strong) ShopCategory *category;
@end
