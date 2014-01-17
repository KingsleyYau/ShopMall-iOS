//
//  NavigationBarEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-20.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "NavigationBarEntitlement.h"

@implementation NavigationBarEntitlement
@synthesize isShowImage = _isShowImage;
@synthesize titleImage = _titleImage;
@synthesize titleString = _titleString;
@synthesize tintColor = _tintColor;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.isShowImage = NO;
        self.titleImage = nil;
        self.titleString = nil;
        self.tintColor = nil;
    }
    return self;
}

- (void)dealloc
{
    self.titleString = nil;
    self.titleImage = nil;
    self.tintColor = nil;
    [super dealloc];
}
@end
