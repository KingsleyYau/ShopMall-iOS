//
//  PhotoTableView.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoTableView;
@protocol PhotoTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(PhotoTableView *)tableView;
- (void)tableView:(PhotoTableView *)tableView didSelectShopImage:(ShopImage *)item;
- (void)didSelectMore:(PhotoTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface PhotoTableView : UITableView <UITableViewDataSource, UITableViewDelegate, RequestImageViewDelegate>
@property (nonatomic, weak) IBOutlet id <PhotoTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
