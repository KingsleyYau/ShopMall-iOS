//
//  SignTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *detailBackgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
