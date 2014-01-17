//
//  SortTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SortTableView;
@class ShopSortType;
@protocol SortTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(SortTableView *)tableView;
- (void)tableView:(SortTableView *)tableView didSelectSort:(ShopSortType *)item;
@end
@interface SortTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <SortTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) ShopSortType *sort;
@property (nonatomic, retain) NSArray *items;
@end
