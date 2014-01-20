//
//  RegisterCommitCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegisterCommitCell.h"

@implementation RegisterCommitCell
+ (NSString *)cellIdentifier {
    return @"RegisterCommitCell";
}
+ (NSInteger)cellHeight {
    return 52;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    RegisterCommitCell *cell = (RegisterCommitCell *)[tableView dequeueReusableCellWithIdentifier:[RegisterCommitCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[RegisterCommitCell cellIdentifier]  owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
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
