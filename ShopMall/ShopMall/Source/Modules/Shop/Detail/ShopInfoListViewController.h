//
//  ShopInfoListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopNewsTableView.h"
@interface ShopInfoListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ShopNewsTableView *tableView;
@property (nonatomic, strong) Shop *item;
@end
