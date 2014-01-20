//
//  NewsDetailInfoCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailInfoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
