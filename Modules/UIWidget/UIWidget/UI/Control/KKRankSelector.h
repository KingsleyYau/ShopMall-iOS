//
//  KKRankSelector.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKRankSelector;
@protocol KKRankSelectorDelegete <NSObject>
@optional
- (void)didChangeRank:(KKRankSelector *)kkRankSelector curRank:(NSInteger)curRank;
@end
@interface KKRankSelector : UIView {
    NSInteger _numberOfRank;
    NSInteger _curRank;
    BOOL _canEditable;
}
@property (nonatomic, assign) BOOL canEditable;
@property (nonatomic, assign) NSInteger numberOfRank;
@property (nonatomic, assign) NSInteger curRank;
@property (nonatomic, assign) NSInteger blanking;

@property (nonatomic, retain) UIImage *kkImage;
@property (nonatomic, retain) UIImage *kkSelectedImage;
@property (nonatomic, assign) IBOutlet id<KKRankSelectorDelegete> delegate;
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image selectImage:(UIImage *)selectImage;
- (void)relayout;
@end
