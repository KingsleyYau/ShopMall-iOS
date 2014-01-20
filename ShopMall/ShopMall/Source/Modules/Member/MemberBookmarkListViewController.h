//
//  MemberBookmarkListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopTableView.h"
@interface MemberBookmarkListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet ShopTableView *tableView;
@property (nonatomic, strong) Shop *item;
@end
