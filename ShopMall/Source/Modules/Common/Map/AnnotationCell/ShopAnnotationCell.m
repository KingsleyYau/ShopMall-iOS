//
//  ShopAnnotationCell.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopAnnotationCell.h"

@implementation ShopAnnotationCell
+ (NSString *)cellIdentifier {
    return @"ShopAnnotationCell";
}
+ (NSInteger)cellHeight {
    return 80;
}
+ (id)getCell{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[ShopAnnotationCell cellIdentifier] owner:nil options:nil];
    ShopAnnotationCell *cell = [nib objectAtIndex:0];

    cell.titleLabel.text = @"";
    
    cell.kkRankSelector.kkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorUnSelected ofType:@"png"]];
    cell.kkRankSelector.kkSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:CommonRankSelectorSelected ofType:@"png"]];
    cell.kkRankSelector.canEditable = NO;
    cell.kkRankSelector.numberOfRank = 5;
    
    cell.detailLabel.text = @"";
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
