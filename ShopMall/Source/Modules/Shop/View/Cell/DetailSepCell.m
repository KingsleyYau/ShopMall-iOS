//
//  DetailSepCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "DetailSepCell.h"

@implementation DetailSepCell
+ (NSString *)cellIdentifier {
    return @"DetailSepCell";
}
+ (NSInteger)cellHeight {
    return 20;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    DetailSepCell *cell = (DetailSepCell *)[tableView dequeueReusableCellWithIdentifier:[DetailSepCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailSepCell" owner:tableView options:nil];
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
@end
