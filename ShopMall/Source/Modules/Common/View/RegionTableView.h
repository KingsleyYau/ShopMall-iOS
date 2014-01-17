//
//  RegionTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegionTableView;
@class Region;

@protocol RegionTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(RegionTableView *)tableView;
- (void)tableView:(RegionTableView *)tableView didSelectRegion:(Region *)item;
- (void)tableView:(RegionTableView *)tableView didSelectParentRegion:(Region *)item;
@end
@interface RegionTableView : UIView <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_regionParent;
    UITableView *_regionSub;
}
@property (nonatomic, weak) IBOutlet id <RegionTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSArray *itemsParent;
- (void)reloadData;
@end
