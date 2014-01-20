//
//  MemberTableViewCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell
+ (NSString *)cellIdentifier {
    return @"MemberTableViewCell";
}
+ (NSInteger)cellHeight {
    return 58;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    MemberTableViewCell *cell = (MemberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MemberTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MemberTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.leftImageView.image = nil;
    [cell.badgeButton setBadgeValue:nil];
    cell.titleLabel.text = @"";
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
    [self.titleLabel sizeToFit];
    self.badgeButton.frame = CGRectMake(self.titleLabel.frame.origin.x + 25, self.titleLabel.frame.origin.y + 4, self.titleLabel.frame.size.width, self.badgeButton.frame.size.height);
}
@end
