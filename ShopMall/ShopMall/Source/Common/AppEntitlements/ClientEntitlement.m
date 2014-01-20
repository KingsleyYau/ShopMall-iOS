//
//  ClientEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-21.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ClientEntitlement.h"

@implementation ClientEntitlement
@synthesize centerDomain = _centerDomain;
@synthesize schoolKey = _schoolKey;
//@synthesize iTunesId = _iTunesId;
- (id)init
{
    self = [super init];
    if (nil != self){
        self.centerDomain = nil;
        self.schoolKey = nil;
        //self.iTunesId = nil;
    }
    return self;
}

- (void)dealloc
{
    self.centerDomain = nil;
    self.schoolKey = nil;
    //self.iTunesId = nil;
    [super dealloc];
}
@end
