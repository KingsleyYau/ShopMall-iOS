//
//  ShopCreditViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "CreditTableView.h"

@class ShopCreditViewController;
@interface ShopCreditViewController : BaseViewController
@property (nonatomic, weak) IBOutlet CreditTableView *tableView;
@property (nonatomic, retain) Credit *credit;
@end
