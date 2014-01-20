//
//  ShopAnnotationCell.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKRankSelector;

@interface ShopAnnotationCell : UIView {
}
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet KKRankSelector *kkRankSelector;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIImageView *accessoryView;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getCell;
@end
