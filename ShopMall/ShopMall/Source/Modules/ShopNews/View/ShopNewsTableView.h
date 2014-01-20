//
//  ShopNewsTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopNews;
@class ShopNewsTableView;

@protocol ShopNewsTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ShopNewsTableView *)tableView;
- (void)tableView:(ShopNewsTableView *)tableView didSelectShopNews:(ShopNews *)item;
- (void)didSelectMore:(ShopNewsTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface ShopNewsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, weak) IBOutlet id <ShopNewsTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
