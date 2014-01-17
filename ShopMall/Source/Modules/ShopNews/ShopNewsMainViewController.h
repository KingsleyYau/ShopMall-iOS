//
//  ShopNewsMainViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "ShopNewsTableView.h"
#import "ShopNewsTypesTableView.h"
#import "CreditTableView.h"
#import "CategoryTableView.h"

@interface ShopNewsMainViewController : BaseViewController <KKDynamicViewDelegate, CreditTableViewDelegate, CategoryTableViewDelegate, ShopNewsTableViewDelegate, ShopNewsTypesTableViewDelegate, KKDynamicViewDelegate> {
    ShopNewsTypesTableView *_shopNewsTypesTableView;
    CategoryTableView *_categoryTableView;
    CreditTableView *_creditTableView;
}
@property (nonatomic, weak) IBOutlet UIView *containView;
@property (nonatomic, weak) IBOutlet ShopNewsTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet KKButtonBar *kkButtonBar;
@property (nonatomic, weak) IBOutlet KKDynamicView *kkDynamicView;
@end
