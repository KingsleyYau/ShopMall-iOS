//
//  ShopProductListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductTableView.h"
@class ShopProductListViewController;
@protocol ShopProductViewControllerDelegate <NSObject>
@optional
- (void)viewController:(ShopProductListViewController *)viewController didSelectedProductName:(NSString *)productName;
@end

@interface ShopProductListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet KKTextField *textField;
@property (nonatomic, weak) IBOutlet ProductTableView *tableView;
@property (nonatomic, weak) IBOutlet id <ShopProductViewControllerDelegate> delegate;

@property (nonatomic, strong) Shop *item;
@property (nonatomic, retain) NSString *productName;

- (IBAction)backAction:(id)sender;
@end
