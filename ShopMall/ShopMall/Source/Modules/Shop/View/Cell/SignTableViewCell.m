//
//  SignTableViewCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SignTableViewCell.h"

@implementation SignTableViewCell
+ (NSString *)cellIdentifier {
    return @"SignTableViewCell";
}
+ (NSInteger)cellHeight {
    return 97;
}
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString {
    NSInteger height;
    height = 76;
    if(detailString) {
        height += [detailString sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.875, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    SignTableViewCell *cell = (SignTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[SignTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SignTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = NO;
    cell.kkRankSelector.numberOfRank = 5;
    
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
    
//    [self.detailLabel sizeToFit];
    CGSize size = [self.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(self.frame.size.width * 0.875, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByCharWrapping];

    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.frame.size.width * 0.875, size.height);

    self.detailBackgroundImageView.frame = CGRectMake(self.detailBackgroundImageView.frame.origin.x, self.detailBackgroundImageView.frame.origin.y, self.detailBackgroundImageView.frame.size.width, self.detailLabel.frame.size.height + 20);
    
    NSInteger yIndex = self.detailBackgroundImageView.frame.origin.y + self.detailBackgroundImageView.frame.size.height;
    
    self.userLabel.frame = CGRectMake(self.userLabel.frame.origin.x, yIndex, self.userLabel.frame.size.width, self.userLabel.frame.size.height);
    
    self.kkRankSelector.frame = CGRectMake(self.kkRankSelector.frame.origin.x, yIndex, self.kkRankSelector.frame.size.width, self.kkRankSelector.frame.size.height);
    yIndex += self.userLabel.frame.size.height;
    
    self.dateLabel.frame = CGRectMake(self.dateLabel.frame.origin.x, yIndex, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
}
@end
