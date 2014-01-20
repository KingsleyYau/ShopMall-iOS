//
//  NewsDetailUserNameCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "NewsDetailUserNameCell.h"

@implementation NewsDetailUserNameCell
+ (NSString *)cellIdentifier {
    return @"NewsDetailUserNameCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    NewsDetailUserNameCell *cell = (NewsDetailUserNameCell *)[tableView dequeueReusableCellWithIdentifier:[NewsDetailUserNameCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsDetailUserNameCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.textField.text = @"";
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
