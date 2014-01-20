//
//  RankListTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankTableView;
@class ShopCategory;
@protocol RankTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(RankTableView *)tableView;
- (void)tableView:(RankTableView *)tableView didSelectCategory:(ShopCategory *)item;
- (void)didSelectMore:(RankTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface RankTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <RankTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) ShopCategory *category;
@property (nonatomic, assign) BOOL hasMore;
@end
