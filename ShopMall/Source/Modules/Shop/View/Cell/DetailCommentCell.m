//
//  DetailCommentCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "DetailCommentCell.h"

@implementation DetailCommentCell
+ (NSString *)cellIdentifier {
    return @"DetailCommentCell";
}
+ (NSInteger)cellHeight {
    return 120;
}
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString {
    NSInteger height;
    height = 99;
    if(detailString) {
        height += [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.75, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    DetailCommentCell *cell = (DetailCommentCell *)[tableView dequeueReusableCellWithIdentifier:[DetailCommentCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailCommentCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = NO;
    cell.kkRankSelector.numberOfRank = 5;
    
    cell.priceAvgLabel.text = @"";
    cell.detailLabel.text = @"";
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
    
    [self.detailLabel sizeToFit];
//    CGSize size = [self.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.frame.size.width * 0.75, MAXFLOAT)
//                                        lineBreakMode:NSLineBreakByCharWrapping];
//    
//    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.frame.size.width * 0.75, size.height);
//    
//    NSInteger yIndex = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + BLANKING_Y;
    
//    self.dateLabel.frame = CGRectMake(self.dateLabel.frame.origin.x, yIndex, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
    
}
@end
