//
//  KKButtonBar.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-20.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKButtonBar.h"
#import "CustomUIView.h"
@interface KKButtonBar () {
    UIImageView *_backgroundView;
    NSArray *_items;
}
@end
@implementation KKButtonBar
@synthesize items = _items;
@synthesize isVertical;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.blanking = 0;
        self.isVertical = NO;
        self.backgroundColor = [UIColor clearColor];

        _backgroundView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:_backgroundView];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)dealloc {
    self.delegate = nil;
    self.items = nil;
    [super dealloc];
}
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundView.image = backgroundImage;
}
- (void)setItems:(NSArray *)items {
//    [self removeAllSubviews];
    if(_items) {
        for(UIView *view in _items) {
            [view removeFromSuperview];
        }
        [_items release];
        _items = nil;
    }
    if(items)
        _items = [items retain];
    
    CGFloat curIndex = self.blanking;
    if(!isVertical) {
        // 水平排版
        CGFloat itemWidth = (self.frame.size.width - self.blanking * (items.count + 1)) / items.count;
        
        for(UIView *view in items) {
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [view removeFromSuperview];
            [self addSubview:view];
            view.frame = CGRectMake(curIndex, 0, itemWidth, self.frame.size.height);
            curIndex += itemWidth;
            curIndex += self.blanking;
        }
    }
    else {
        // 垂直排版
        CGFloat itemHeight = (self.frame.size.height - self.blanking * (items.count + 1)) / items.count;
        
        for(UIView *view in items) {
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [view removeFromSuperview];
            [self addSubview:view];
            view.frame = CGRectMake(0, curIndex, self.frame.size.width, itemHeight);
            curIndex += itemHeight;
            curIndex += self.blanking;
        }
    }

    if([self.delegate respondsToSelector:@selector(itemsDidLayout:)]) {
        [self.delegate itemsDidLayout:self];
    }
    [self setNeedsLayout];
}
- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    
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
