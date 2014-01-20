//
//  CategoryTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-2.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryTableView;
@class ShopCategory;
@protocol CategoryTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(CategoryTableView *)tableView;
- (void)tableView:(CategoryTableView *)tableView didSelectShopCategory:(ShopCategory *)item;
- (void)tableView:(CategoryTableView *)tableView didSelectShopParentCategory:(ShopCategory *)item;
@end
@interface CategoryTableView : UIView <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_categoryParent;
    UITableView *_categorySub;
}
@property (nonatomic, weak) IBOutlet id <CategoryTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) ShopCategory *category;
@property (nonatomic, retain) NSArray *itemsParent;
- (void)reloadData;
@end
