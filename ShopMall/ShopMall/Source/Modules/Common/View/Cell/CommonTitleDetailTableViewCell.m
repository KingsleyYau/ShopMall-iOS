//
//  CommonTitleDetailTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-10-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonTitleDetailTableViewCell.h"

@implementation CommonTitleDetailTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommonTitleDetailTableViewCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (NSInteger)cellHeight:(UITableView *)tableView titleString:(NSString *)titleString detailString:(NSString *)detailString {
    NSInteger height;
    height = 14;
    if(titleString.length > 0) {
        height += [titleString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.9375, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    if(detailString.length > 0) {
        height += [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.9375, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonTitleDetailTableViewCell *cell = (CommonTitleDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonTitleDetailTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[CommonTitleDetailTableViewCell cellIdentifier] owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
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
    [self.titleLabel sizeToFit];
    [self.detailLabel sizeToFit];
    
    NSInteger xCurIndexY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    xCurIndexY += BLANKING_Y;
    
    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, xCurIndexY, self.detailLabel.frame.size.width, self.detailLabel.frame.size.height);
}

@end
