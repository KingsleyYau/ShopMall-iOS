//
//  DetailTitleCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "DetailTitleCell.h"

@implementation DetailTitleCell
+ (NSString *)cellIdentifier {
    return @"DetailTitleCell";
}
+ (NSInteger)cellHeight {
    return 56;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    DetailTitleCell *cell = (DetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:[DetailTitleCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailTitleCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = NO;
    cell.kkRankSelector.numberOfRank = 5;
    
    cell.priceAvgLabel.text = @"";
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
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
