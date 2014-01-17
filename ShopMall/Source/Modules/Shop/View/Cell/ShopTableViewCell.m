//
//  ShopTableViewCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell
+ (NSString *)cellIdentifier {
    return @"ShopTableViewCell";
}
+ (NSInteger)cellHeight {
    return 76;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ShopTableViewCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.titleLabel.text = @"";
    cell.imageCardView.hidden = YES;
    cell.imageGiftView.hidden = YES;
    cell.imageDiscView.hidden = YES;
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = NO;
    cell.kkRankSelector.numberOfRank = 5;
    
    cell.avgLabel.text = @"";
    cell.addressLabel.text = @"";
    cell.catLabel.text = @"";
    cell.disLabel.text = @"";
    
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
    
    // 图标
    NSInteger xCurIndex = self.imageCardView.frame.origin.x;
    
    if(!self.imageCardView.hidden) {
        self.imageCardView.frame = CGRectMake(xCurIndex, self.imageCardView.frame.origin.y, self.imageCardView.frame.size.width, self.imageCardView.frame.size.height);
        xCurIndex -= self.imageCardView.frame.size.width;
        xCurIndex -= BLANKING_X;
    }
    
    if(!self.imageGiftView.hidden) {
        self.imageGiftView.frame = CGRectMake(xCurIndex, self.imageGiftView.frame.origin.y, self.imageGiftView.frame.size.width, self.imageGiftView.frame.size.height);
        xCurIndex -= self.imageGiftView.frame.size.width;
        xCurIndex -= BLANKING_X;
    }
    if(!self.imageDiscView.hidden) {
        self.imageDiscView.frame = CGRectMake(xCurIndex,self.imageDiscView.frame.origin.y,  self.imageDiscView.frame.size.width, self.imageDiscView.frame.size.height);
        xCurIndex -= self.imageDiscView.frame.size.width;
        xCurIndex -= BLANKING_X;
    }
    
    // 地址和分类
    CGSize sizeAddress = [_addressLabel sizeThatFits:CGSizeZero];
    self.addressLabel.frame = CGRectMake(self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, MIN(sizeAddress.width, 100), self.addressLabel.frame.size.height);
    
    
    self.catLabel.frame = CGRectMake(self.addressLabel.frame.origin.x + self.addressLabel.frame.size.width + BLANKING_X, self.catLabel.frame.origin.y, self.catLabel.frame.size.width, self.catLabel.frame.size.height);
}
@end
