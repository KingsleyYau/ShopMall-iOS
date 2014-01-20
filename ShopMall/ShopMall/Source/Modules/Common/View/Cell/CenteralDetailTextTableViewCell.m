//
//  CenteralDetailTextTableViewCell.H
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CenteralDetailTextTableViewCell.h"

@implementation CenteralDetailTextTableViewCell
+ (NSString *)cellIdentifier {
    return @"CenteralDetailTextTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString {
    NSInteger height;
    height = 23;
    if(detailString) {
        height += [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.75, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CenteralDetailTextTableViewCell *cell = (CenteralDetailTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CenteralDetailTextTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[CenteralDetailTextTableViewCell cellIdentifier] owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.detailLabel.text = @"";
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
    [self.detailLabel sizeToFit];
}

@end
