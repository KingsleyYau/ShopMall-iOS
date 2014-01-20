//
//  SearchBarEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-22.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "SearchBarEntitlement.h"

@implementation SearchBarEntitlement
@synthesize searchBarTintColor = _searchBarTintColor;
@synthesize sectionBackgroundColor = _sectionBackgroundColor;
@synthesize sectionFontColor = _sectionFontColor;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.searchBarTintColor = nil;
        self.sectionFontColor = nil;
        self.sectionBackgroundColor = nil;
    }
    return self;
}

- (void)dealloc
{
    self.searchBarTintColor = nil;
    self.sectionFontColor = nil;
    self.sectionBackgroundColor = nil;
    [super dealloc];
}
@end
