//
//  CreditImageTableViewCell.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestImageView;
@interface CreditImageTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
