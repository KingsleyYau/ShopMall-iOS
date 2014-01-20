//
//  ShopMainViewController.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-12.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopCategoryManager.h"

@interface ShopMainViewController : BaseViewController <IconGridDelegate, RequestImageViewDelegate, ShopCategoryManagerDelegate> {

}
@property (nonatomic, weak) IBOutlet UIView *containView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet IconGrid *iconGridView;
@property (nonatomic, strong) IBOutlet KKSearchBar *kkSearchBar;
@property (nonatomic, strong) MITSearchDisplayController *searchController;

@property (nonatomic, weak) IBOutlet UIButton *areaButton;
@property (nonatomic, weak) IBOutlet UIButton *rankButton;
@property (nonatomic, weak) IBOutlet UIButton *pointButton;

@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;

@property (nonatomic, retain) ShopCategoryManager *shopCategoryManager;

- (IBAction)areaButton:(id)sender;
- (IBAction)rankButton:(id)sender;
- (IBAction)pointButton:(id)sender;
- (IBAction)iconGridButtonAction:(id)sender;
- (IBAction)iconGridMoreButtonAction:(id)sender;
@end
