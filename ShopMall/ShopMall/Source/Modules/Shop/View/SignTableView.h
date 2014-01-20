//
//  SignTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignTableView;
@class Sign;
@protocol SignTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(SignTableView *)tableView;
- (void)tableView:(SignTableView *)tableView didSelectSign:(Sign *)item;
- (void)didSelectMore:(SignTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface SignTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <SignTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
