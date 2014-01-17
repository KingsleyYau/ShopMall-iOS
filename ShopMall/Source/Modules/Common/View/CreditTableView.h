//
//  CreditTableView.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-2.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreditTableView;
@class Credit;
@protocol CreditTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(CreditTableView *)tableView;
- (void)tableView:(CreditTableView *)tableView didSelectCredit:(Credit *)item;
@end
@interface CreditTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <CreditTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) Credit *credit;
@property (nonatomic, retain) NSArray *items;
@end
