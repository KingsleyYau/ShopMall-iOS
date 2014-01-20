//
//  ShopCategoryViewController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "CategoryTableView.h"

@class ShopCategoryViewController;
@protocol ShopCategoryViewControllerDelegate  <NSObject>
@optional
- (BOOL)shouldPopupShopCategoryViewController:(ShopCategoryViewController *)vc;
@end
@interface ShopCategoryViewController : BaseViewController <CategoryTableViewDelegate>
@property (nonatomic, weak) IBOutlet id<ShopCategoryViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet CategoryTableView *tableView;

@property (nonatomic, retain) ShopCategory *shopCategory;
@end
