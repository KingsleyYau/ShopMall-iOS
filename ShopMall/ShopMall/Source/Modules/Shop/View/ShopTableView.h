//
//  ShopTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-26.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopTableView;
@class Shop;
@protocol ShopTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ShopTableView *)tableView;
- (void)tableView:(ShopTableView *)tableView didSelectShop:(Shop *)item;
- (void)tableView:(ShopTableView *)tableView willDeleteShop:(Shop *)item;
- (void)didSelectMore:(ShopTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface ShopTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, weak) IBOutlet id <ShopTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL canDeleteItem;
@end
