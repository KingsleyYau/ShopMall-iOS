//
//  ShopSignListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "SignTableView.h"
@interface ShopSignListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet SignTableView *tableView;
@property (nonatomic, strong) Shop *item;
@end
