//
//  ShopRegionViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "RegionTableView.h"

@class ShopRegionViewController;
@protocol ShopRegionViewControllerDelegate  <NSObject>
@optional
- (BOOL)shouldPopupShopRegionViewController:(ShopRegionViewController *)vc;
@end
@interface ShopRegionViewController : BaseViewController
@property (nonatomic, weak) IBOutlet id<ShopRegionViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet RegionTableView *tableView;

@property (nonatomic, retain) Region *region;
@end
