//
//  RegisterPassword2Cell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegisterPassword2Cell.h"

@implementation RegisterPassword2Cell
+ (NSString *)cellIdentifier {
    return @"RegisterPassword2Cell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    RegisterPassword2Cell *cell = (RegisterPassword2Cell *)[tableView dequeueReusableCellWithIdentifier:[RegisterPassword2Cell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[RegisterPassword2Cell cellIdentifier] owner:tableView options:nil];
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
