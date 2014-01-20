//
//  GlobalUIEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-22.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "GlobalUIEntitlement.h"

@implementation GlobalUIEntitlement
@synthesize navigationBarEntitlement = _navigationBarEntitlement;
@synthesize searchBarEntitlement = _searchBarEntitlement;
@synthesize baseViewControllerBackgroundColor = _baseViewControllerBackgroundColor;
@synthesize egoRefreshTableHeaderViewColor = _egoRefreshTableHeaderViewColor;
- (id)init
{
    self = [super init];
    if (nil != self){
        self.navigationBarEntitlement = nil;
        self.searchBarEntitlement = nil;
        self.baseViewControllerBackgroundColor = nil;
        self.egoRefreshTableHeaderViewColor = nil;
    }
    return self;
}

- (void)dealloc
{
    self.navigationBarEntitlement = nil;
    self.searchBarEntitlement = nil;
    self.baseViewControllerBackgroundColor = nil;
    self.egoRefreshTableHeaderViewColor = nil;
    [super dealloc];
}
@end
