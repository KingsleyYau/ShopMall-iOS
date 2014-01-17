//
//  ShopListNearViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MapViewController.h"
#import "ShopTableView.h"
#import "CreditTableView.h"
#import "CategoryTableView.h"
#import "SortTableView.h"
#import "RegionTableView.h"

@interface ShopListNearViewController : MapViewController <ShopTableViewDelegate,  CategoryTableViewDelegate, CreditTableViewDelegate, RegionTableViewDelegate, SortTableViewDelegate, KKDynamicViewDelegate, KKButtonBarDelegete, KKListItemSelectorDelegete>

@property (nonatomic, weak) IBOutlet KKButtonBar *kkButtonBar;
@property (nonatomic, weak) IBOutlet KKDynamicView *kkDynamicView;
@property (nonatomic, weak) IBOutlet ShopTableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet KKListItemSelector *kkListItemSelector;

@property (nonatomic, retain) MITSearchDisplayController *searchController;
@property (nonatomic, retain) KKSearchBar *theSearchBar;

@property (nonatomic, retain) KKLoadingView *kkLoadingView;


@property (nonatomic, retain) ShopCategory *shopCategory;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) Credit *credit;
@property (nonatomic, assign) BOOL isRegion;
@property (nonatomic, retain) NSString *stringSearch;
@end
