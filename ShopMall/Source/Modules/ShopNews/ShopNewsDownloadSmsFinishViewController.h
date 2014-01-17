//
//  ShopNewsDownloadSmsFinishViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopNewsDownloadSmsFinishViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ShopNews *item;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *buyTips;

- (IBAction)backAction:(id)sender;
- (IBAction)infoAction:(id)sender;
@end


