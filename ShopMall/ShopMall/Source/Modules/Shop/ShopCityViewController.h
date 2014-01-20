//
//  ShopCityViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "CityTableView.h"
#import "CitySearchTableView.h"
#import "ShopMainViewController.h"

@interface ShopCityViewController : BaseViewController <CityTableViewDelegate, CitySearchTableViewDelegate, MITSearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet KKSearchBar *kkSearchBar;
@property (nonatomic, strong) MITSearchDisplayController *searchController;
@property (nonatomic, weak) IBOutlet UIButton *gpsButton;

@property (nonatomic, weak) IBOutlet CityTableView *tableView;
@property (nonatomic, strong) IBOutlet CitySearchTableView *citySearchTableView;
@property (nonatomic, weak) ShopMainViewController *parentVC;

- (IBAction)gpsButton:(id)sender;

@end
