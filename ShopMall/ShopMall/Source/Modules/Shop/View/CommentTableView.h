//
//  CommentTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentTableView;
@class Comment;
@protocol CommentTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(CommentTableView *)tableView;
- (void)tableView:(CommentTableView *)tableView didSelectComment:(Comment *)item;
- (void)didSelectMore:(CommentTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface CommentTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <CommentTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
