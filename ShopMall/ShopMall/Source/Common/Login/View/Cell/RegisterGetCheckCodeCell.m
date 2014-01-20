//
//  RegisterGetCheckCodeCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegisterGetCheckCodeCell.h"

@implementation RegisterGetCheckCodeCell
+ (NSString *)cellIdentifier {
    return @"RegisterGetCheckCodeCell";
}
+ (NSInteger)cellHeight {
    return 52;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    RegisterGetCheckCodeCell *cell = (RegisterGetCheckCodeCell *)[tableView dequeueReusableCellWithIdentifier:[RegisterGetCheckCodeCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[RegisterGetCheckCodeCell cellIdentifier] owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.countLabel.text = @"";
    cell.countLabel.hidden = YES;
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
