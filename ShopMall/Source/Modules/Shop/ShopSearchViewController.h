//
//  ShopSearchViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-9.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopSearchViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIButton *regionButton;
@property (nonatomic, weak) IBOutlet UIButton *categoryButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

- (IBAction)regionAction:(id)sender;
- (IBAction)categoryAction:(id)sender;
- (IBAction)commitAction:(id)sender;
@end
