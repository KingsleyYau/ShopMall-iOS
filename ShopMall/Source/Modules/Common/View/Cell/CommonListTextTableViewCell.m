//
//  CommonListTextTableViewCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommonListTextTableViewCell.h"

@implementation CommonListTextTableViewCell
+ (NSString *)cellIdentifier {
    return @"SchoolListTextTableViewCell";
}
+ (NSInteger)cellHeight {
    return 76;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    CommonListTextTableViewCell *cell = (CommonListTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CommonListTextTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonListTextTableViewCell" owner:tableView options:nil];
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
    
    NSInteger xCurIndex = self.titleLabel.frame.origin.x;
    
    if(self.bookmarkView.image) {
        self.bookmarkView.frame = CGRectMake(xCurIndex, self.bookmarkView.frame.origin.y, self.bookmarkView.frame.size.width, self.bookmarkView.frame.size.height);
        xCurIndex += self.bookmarkView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(self.attachmenttView.image) {
        self.attachmenttView.frame = CGRectMake(xCurIndex, self.attachmenttView.frame.origin.y, self.attachmenttView.frame.size.width, self.attachmenttView.frame.size.height);
        xCurIndex += self.attachmenttView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(self.emergentView.image) {
        self.emergentView.frame = CGRectMake(xCurIndex,self.emergentView.frame.origin.y,  self.emergentView.frame.size.width, self.emergentView.frame.size.height);
        xCurIndex += self.emergentView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
    if(self.commentView.image) {
        self.commentView.frame = CGRectMake(xCurIndex,self.commentView.frame.origin.y,  self.commentView.frame.size.width, self.commentView.frame.size.height);
        xCurIndex += self.commentView.frame.size.width;
        xCurIndex += BLANKING_X;
    }
}
@end
