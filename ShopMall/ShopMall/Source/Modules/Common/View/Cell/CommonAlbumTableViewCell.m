//
//  HomeTableViewCell.m
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonAlbumTableViewCell.h"

@implementation CommonAlbumTableViewCell
+ (NSString *)cellIdentifier {
    return @"CommonAlbumTableViewCell";
}
+ (NSInteger)cellHeight {
    return 150;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonAlbumTableViewCell *cell = (CommonAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonAlbumTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonAlbumTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel1.text = @"";
    cell.titleLabel2.text = @"";
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

@end
