//
//  MemberShopNewsListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopPersonalNewsTableView.h"
@interface MemberShopNewsListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet KKButtonBar *kkButtonBar;
@property (nonatomic, weak) IBOutlet ShopPersonalNewsTableView *tableView;
@end
