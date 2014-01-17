//
//  CommonListTextTableViewCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonListTextTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subLabel;
@property (nonatomic, weak) IBOutlet UILabel  *timeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *bookmarkView;
@property (nonatomic, weak) IBOutlet UIImageView *attachmenttView;
@property (nonatomic, weak) IBOutlet UIImageView *emergentView;
@property (nonatomic, weak) IBOutlet UIImageView *commentView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
