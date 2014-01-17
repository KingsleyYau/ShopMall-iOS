//
//  RankListTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankListTableView;
@class Rank;
@protocol RankListTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(RankListTableView *)tableView;
- (void)tableView:(RankListTableView *)tableView didSelectRank:(Rank *)item;
- (void)didSelectMore:(RankListTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface RankListTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <RankListTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) Rank *rank;
@property (nonatomic, assign) BOOL hasMore;
@end
