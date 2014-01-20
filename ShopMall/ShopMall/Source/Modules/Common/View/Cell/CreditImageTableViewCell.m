//
//  CreditImageTableViewCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CreditImageTableViewCell.h"

@implementation CreditImageTableViewCell
+ (NSString *)cellIdentifier {
    return @"CreditImageTableViewCell";
}
+ (NSInteger)cellHeight {
    return 76;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CreditImageTableViewCell *cell = (CreditImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CreditImageTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreditImageTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
