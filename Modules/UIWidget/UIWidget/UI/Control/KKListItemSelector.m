//
//  KKListItemSelector.m
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKListItemSelector.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"
#import "KKToolBar.h"
@implementation KKListItemSelector
@synthesize buttonRefresh = _buttonRefresh;

@synthesize labelText =_labelText;
@synthesize buttonPre = _buttonPre;
@synthesize buttonNext = _buttonNext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        KKToolBar *kkToolBar = [[[KKToolBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:kkToolBar];
        kkToolBar.backgroundColor = [UIColor clearColor];
        [kkToolBar setCustomBackgroundImage:nil];
        
        UIBarButtonItem *barButtonItem = nil;
        NSMutableArray *mutArray = [NSMutableArray array];
        
        _buttonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonRefresh setBackgroundImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:ListItemSelectorRefresh]] forState:UIControlStateNormal];
        [_buttonRefresh sizeToFit];
        [_buttonRefresh addTarget:self action:@selector(buttonRefreshAction:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_buttonRefresh] autorelease];
        [mutArray addObject:barButtonItem];
        
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [mutArray addObject:barButtonItem];
                
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
        barButtonItem.width = 120;
        [mutArray addObject:barButtonItem];
        
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [mutArray addObject:barButtonItem];

        _buttonPre = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonPre setBackgroundImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:ListItemSelectorLeftArrow]] forState:UIControlStateNormal];
        [_buttonPre sizeToFit];
        [_buttonPre addTarget:self action:@selector(buttonLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_buttonPre] autorelease];
        [mutArray addObject:barButtonItem];
        
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [mutArray addObject:barButtonItem];
        
        _labelText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height)] autorelease];
        _labelText.backgroundColor = [UIColor clearColor];
        _labelText.textColor = [UIColor grayColor];
        _labelText.text = @"";
        _labelText.textAlignment = NSTextAlignmentCenter;
        barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_labelText] autorelease];
        [mutArray addObject:barButtonItem];
        
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [mutArray addObject:barButtonItem];
        
        _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonNext setBackgroundImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:ListItemSelectorRightArrow]] forState:UIControlStateNormal];
        [_buttonNext sizeToFit];
        [_buttonNext addTarget:self action:@selector(buttonRightAction:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_buttonNext] autorelease];
        [mutArray addObject:barButtonItem];
        
        kkToolBar.items = mutArray;
    }
    return self;
}

#pragma mark - 按钮事件
- (void)buttonRefreshAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(didPressRefresh:)]) {
        [self.delegate didPressRefresh:self];
    }
}
- (void)buttonLeftAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(didPressPre:)]) {
        [self.delegate didPressPre:self];
    }
}
- (void)buttonRightAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(didPressNext:)]) {
        [self.delegate didPressNext:self];
    }
}
@end
