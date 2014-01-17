//
//  ShareEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-29.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ShareEntitlement.h"

@implementation ShareItemEntitlement
@synthesize name = _name;
@synthesize type = _type;
@synthesize show = _show;
@synthesize url = _url;
@synthesize logo = _logo;
@synthesize appKey = _appKey;
- (id)init
{
    self = [super init];
    if (nil != self){
        self.name = nil;
        self.type = nil;
        self.show = NO;
        self.url = nil;
        self.appKey = nil;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.type = nil;
    self.show = NO;
    self.url = nil;
    self.appKey = nil;
    [super dealloc];
}
@end

@implementation ShareEntitlement
@synthesize shares = _shares;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.shares = nil;
    }
    return self;
}

- (void)dealloc
{
    self.shares = nil;
    [super dealloc];
}
@end
