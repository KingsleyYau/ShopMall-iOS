//
//  CalendarEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-20.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarEntitlement : NSObject
{
@private
    UIColor*    _datePickerTintColor;
}
@property (nonatomic, retain) UIColor*  datePickerTintColor;
@end
