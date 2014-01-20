//
//  NewsDetailInfoCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "NewsDetailInfoCell.h"

@implementation NewsDetailInfoCell
+ (NSString *)cellIdentifier {
    return @"NewsDetailInfoCell";
}
+ (NSInteger)cellHeight {
    return 32;
}
+ (NSInteger)cellHeight:(UITableView *)tableView detailString:(NSString *)detailString {
    NSInteger height;
    height = 11;
    if(detailString) {
        height += [detailString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.85, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    NewsDetailInfoCell *cell = (NewsDetailInfoCell *)[tableView dequeueReusableCellWithIdentifier:[NewsDetailInfoCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsDetailInfoCell" owner:tableView options:nil];
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
}
@end
