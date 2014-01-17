//
//  ShopCommitPhotoViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopCommitPhotoViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;

@property (nonatomic, retain) Shop *item;
@property (nonatomic, retain) UIImage *image;


- (IBAction)commitAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
