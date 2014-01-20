//
//  MemberInfoTableViewCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MemberInfoTableViewCell.h"

@implementation MemberInfoTableViewCell
+ (NSString *)cellIdentifier {
    return @"MemberInfoTableViewCell";
}
+ (NSInteger)cellHeight {
    return 115;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    MemberInfoTableViewCell *cell = (MemberInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MemberInfoTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MemberInfoTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
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
- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
