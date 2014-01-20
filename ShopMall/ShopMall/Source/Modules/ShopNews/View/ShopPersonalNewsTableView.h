//
//  ShopPersonalNewsTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopPersonalNews;
@class ShopPersonalNewsTableView;

@protocol ShopPersonalNewsTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ShopPersonalNewsTableView *)tableView;
- (void)tableView:(ShopPersonalNewsTableView *)tableView didSelectShopPersonalNews:(ShopPersonalNews *)item;
- (void)didSelectMore:(ShopPersonalNewsTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface ShopPersonalNewsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, weak) IBOutlet id <ShopPersonalNewsTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
