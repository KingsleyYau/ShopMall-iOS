//
//  CalendarEntitlement.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-20.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "CalendarEntitlement.h"

@implementation CalendarEntitlement
@synthesize datePickerTintColor = _datePickerTintColor;

- (id)init
{
    self = [super init];
    if (nil != self){
        self.datePickerTintColor = nil;
    }
    return self;
}

- (void)dealloc
{
    self.datePickerTintColor = nil;
    [super dealloc];
}
@end
