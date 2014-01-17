//
//  ProductTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductTableView;
@class Product;
@protocol ProductTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ProductTableView *)tableView;
- (void)tableView:(ProductTableView *)tableView didSelectProduct:(Product *)item;
- (void)didSelectMore:(ProductTableView *)tableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@interface ProductTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet id <ProductTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) BOOL hasMore;
@end
