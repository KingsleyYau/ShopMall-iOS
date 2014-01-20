//
//  NewsDetailDescCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "NewsDetailDescCell.h"

@implementation NewsDetailDescCell
+ (NSString *)cellIdentifier {
    return @"NewsDetailDescCell";
}
+ (NSInteger)cellHeight {
    return 52;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    NewsDetailDescCell *cell = (NewsDetailDescCell *)[tableView dequeueReusableCellWithIdentifier:[NewsDetailDescCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsDetailDescCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
    
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
