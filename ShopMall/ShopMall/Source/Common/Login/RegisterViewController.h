//
//  RegisterViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (nonatomic, weak) IBOutlet KKButtonBar *kkButtonBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;

@property (nonatomic, retain) Shop *item;

- (IBAction)bookmarkAction:(id)sender;
- (IBAction)photoAction:(id)sender;
@end
