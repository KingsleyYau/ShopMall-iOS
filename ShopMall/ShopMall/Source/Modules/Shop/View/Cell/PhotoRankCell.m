//
//  PhotoRankCell.m
//  DrPalm4EBaby
//
//  Created by PhotoNameCell on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "PhotoRankCell.h"

@implementation PhotoRankCell
+ (NSString *)cellIdentifier {
    return @"PhotoRankCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    PhotoRankCell *cell = (PhotoRankCell *)[tableView dequeueReusableCellWithIdentifier:[PhotoRankCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoRankCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = YES;
    cell.kkRankSelector.numberOfRank = 5;
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
