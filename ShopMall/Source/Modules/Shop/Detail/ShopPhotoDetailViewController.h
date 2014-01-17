//
//  ShopPhotoDetailViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-7.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopPhotoDetailViewController : BaseViewController
@property (nonatomic, weak) IBOutlet PZPagingScrollView *pagingScrollView;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) Shop *item;
@property (nonatomic, assign) NSInteger curIndex;

- (IBAction)saveAction:(id)sender;
@end
