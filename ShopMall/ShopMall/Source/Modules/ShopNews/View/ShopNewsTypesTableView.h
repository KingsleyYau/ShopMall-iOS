//
//  ShopNewsTypesTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-9.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopNewsTypesTableView;
@class ShopNewsType;
@protocol ShopNewsTypesTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(ShopNewsTypesTableView *)tableView;
- (void)tableView:(ShopNewsTypesTableView *)tableView didSelectShopNewsType:(ShopNewsType *)item;
@end
@interface ShopNewsTypesTableView : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, assign) id <ShopNewsTypesTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) ShopNewsType *type;
@property (nonatomic, retain) NSArray *items;
@end
