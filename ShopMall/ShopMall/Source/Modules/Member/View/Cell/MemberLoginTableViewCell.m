//
//  MemberLoginTableViewCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "MemberLoginTableViewCell.h"

@implementation MemberLoginTableViewCell
+ (NSString *)cellIdentifier {
    return @"MemberLoginTableViewCell";
}
+ (NSInteger)cellHeight {
    return 115;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    MemberLoginTableViewCell *cell = (MemberLoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MemberLoginTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MemberLoginTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
