//
//  KKRankSelector.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-11.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKRankSelector.h"
#import "KKImageButton.h"
#import "CustomUIView.h"

@interface KKRankSelector() {
    
}
@property (nonatomic, retain) NSArray *items;

- (void)relayout;
@end

@implementation KKRankSelector
@synthesize delegate;
@synthesize items;
@synthesize kkImage;
@synthesize kkSelectedImage;
- (void)dealloc {
    self.delegate = nil;
    self.items = nil;
    self.kkImage = nil;
    self.kkSelectedImage = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image selectImage:(UIImage *)selectImage {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numberOfRank = 0;
        _curRank = 0;
        self.canEditable = YES;
        self.blanking = 0;
        self.kkImage = image;
        self.kkSelectedImage = selectImage;
    }
    return self;
}
- (void)relayout {
    [self removeAllSubviews];
    
    NSInteger curIndex = self.blanking;
    CGFloat itemDefaultWidth = (self.frame.size.width - self.blanking * (_numberOfRank + 1)) / _numberOfRank;
    NSMutableArray *muArray = [NSMutableArray array];
    if(self.canEditable) {
        // 添加按钮
        for (int i = 0; i<_numberOfRank; i++) {
            KKImageButton *button = [KKImageButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:button];
            button.contentMode = UIViewContentModeScaleAspectFit;
            button.tag = i;
            [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            
            button.kkImage = self.kkImage;
            button.kkSelectedImage = self.kkSelectedImage;
            [button setSelected:NO];
            
//            button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
            CGSize size = [button sizeThatFits:CGSizeZero];
            
            CGFloat itemWidth = itemDefaultWidth;
            CGFloat itemHeight = 0;
            if(itemDefaultWidth > self.frame.size.height) {
                itemHeight = self.frame.size.height;
                itemWidth = size.width * itemHeight / size.height;
            }
            else {
                itemHeight = size.height * itemDefaultWidth / size.width;
            }
            
            button.frame = CGRectMake(curIndex, 0, itemWidth, itemHeight);
            curIndex += itemWidth;
            curIndex += self.blanking;
            
            [muArray addObject:button];
        }
    }
    else {
        // 紧添加显示的view
        for (int i = 0; i<_numberOfRank; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = i;
            imageView.image = self.kkImage;
            
            CGSize size = [imageView sizeThatFits:CGSizeZero];
            CGFloat itemWidth = itemDefaultWidth;
            CGFloat itemHeight = 0;
            if(itemDefaultWidth > self.frame.size.height) {
                itemHeight = self.frame.size.height;
                itemWidth = size.width * itemHeight / size.height;
            }
            else {
                itemHeight = size.height * itemDefaultWidth / size.width;
            }
            
            imageView.frame = CGRectMake(curIndex, 0, itemWidth, itemHeight);
            curIndex += itemWidth;
            curIndex += self.blanking;
            
            [muArray addObject:imageView];
        }
    }
    
    self.items = muArray;
}
- (void)setNumberOfRank:(NSInteger)numberOfRank {
    if(_numberOfRank == numberOfRank)
        return;
    _numberOfRank = numberOfRank;
    [self relayout];
}
- (void)setCanEditable:(BOOL)canEditable {
    if(_canEditable == canEditable)
        return;
    _canEditable = canEditable;
    [self relayout];
}
- (void)setCurRank:(NSInteger)curRank {
    _curRank = (curRank > _numberOfRank)?_numberOfRank:curRank;
    if (!self.canEditable) {
        for(int i = 0; i<_numberOfRank; i++) {
            UIImageView *imageView = (UIImageView *)[self.items objectAtIndex:i];
            if(i<_curRank) {
                imageView.image = self.kkSelectedImage;
            }
            else {
                imageView.image = self.kkImage;
            }
        }
    }
    else {
        for(int i = 0; i<_numberOfRank; i++) {
            KKImageButton *button = (KKImageButton *)[self.items objectAtIndex:i];
            if(i<=_curRank) {
                [button setSelected:YES];
            }
            else {
                [button setSelected:NO];
            }
        }
    }

}
- (void)action:(id)sender {
    _curRank = ((KKImageButton *)sender).tag;
    for(int i = 0; i<_numberOfRank; i++) {
        KKImageButton *button = (KKImageButton *)[self.items objectAtIndex:i];
        if(i<=_curRank) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
    }
    if([self.delegate respondsToSelector:@selector(didChangeRank:curRank:)]) {
        [self.delegate didChangeRank:self curRank:_curRank];
    }
}
@end
