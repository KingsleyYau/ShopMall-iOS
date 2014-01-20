//
//  CityTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-30.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityTableView;
@class City;
@class CityRegion;
@protocol CityTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(CityTableView *)tableView;
- (void)tableView:(CityTableView *)tableView didSelectCity:(City *)item;
- (void)tableView:(CityTableView *)tableView didSelectCityRegion:(CityRegion *)item;
@end
@interface CityTableView : UIView <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_categoryParent;
    UITableView *_categorySub;
}
@property (nonatomic, weak) IBOutlet id <CityTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *cityRegions;
- (void)reloadData;
@end
