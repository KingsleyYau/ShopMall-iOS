//
//  ShopTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageDiscView;
@property (nonatomic, weak) IBOutlet UIImageView *imageGiftView;
@property (nonatomic, weak) IBOutlet UIImageView *imageCardView;

@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
@property (nonatomic, weak) IBOutlet UILabel *avgLabel;

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *catLabel;
@property (nonatomic, weak) IBOutlet UILabel *disLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
