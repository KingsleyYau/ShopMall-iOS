//
//  NSDate+ToString.m
//  MIT Mobile
//
//  Created by fgx_lion on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+ToString.h"

@implementation NSDate (ToString)
-(NSString*)toStringMDHM
{
    NSUInteger componentFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    NSInteger hour = [comoponents hour];
    NSInteger minute = [comoponents minute];
    
    return [NSString stringWithFormat:@"%d-%d %.2d:%.2d", month, day, hour, minute];
}

-(NSString*)toStringHM
{
    NSUInteger componentFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger hour = [comoponents hour];
    NSInteger minute = [comoponents minute];
    
    return [NSString stringWithFormat:@"%.2d:%.2d", hour, minute];
}

-(NSString*)toStringYMD
{
//    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
//    NSInteger year = [comoponents year];
//    NSInteger month = [comoponents month];
//    NSInteger day = [comoponents day];
//    
//    return [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:self];
    [formatter release];
    return string;
}

-(NSString*)toStringMD
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    
    return [NSString stringWithFormat:@"%d-%d", month, day];
}
-(NSString*)toStringMDCH
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    
    return [NSString stringWithFormat:@"%d月%d日", month, day];
}
-(NSString*)toStringYMDHMS
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger year = [comoponents year];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    NSInteger hour = [comoponents hour];
    NSInteger minute = [comoponents minute];
    NSInteger second = [comoponents second];
    
    return [NSString stringWithFormat:@"%d-%d-%d %d:%.2d:%.2d", year, month, day, hour, minute, second];
}

-(NSString*)toStringYMDHM
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger year = [comoponents year];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    NSInteger hour = [comoponents hour];
    NSInteger minute = [comoponents minute];
    
    return [NSString stringWithFormat:@"%.4d-%.2d-%.2d %.2d:%.2d", year, month, day, hour, minute];
}

-(NSString*)toString2YMDHM
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSInteger year = [comoponents year];
    NSInteger month = [comoponents month];
    NSInteger day = [comoponents day];
    NSInteger hour = [comoponents hour];
    NSInteger minute = [comoponents minute];
    
    return [NSString stringWithFormat:@"%.2d-%.2d-%.2d %.2d:%.2d", year%100, month, day, hour, minute];
}
- (NSString *)toStringToday {
    NSDate *dayBegin = [[NSDate date] getDayStartTime];
    NSDate *dayEnd = [[NSDate date] getDayEndTime];
    if([[self earlierDate:dayEnd] isEqualToDate:[self laterDate:dayBegin]]) {
        // today
        return [self toStringHM];
    }
    else 
        return [self toStringYMD];
}

- (NSString *)dateStringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSString *dateString = nil;
    NSString *timeString = nil;
    // date
    if (NSDateFormatterNoStyle != dateStyle){
        [formatter setDateStyle:dateStyle];
        dateString = [formatter stringFromDate:self];
        [formatter setDateStyle:NSDateFormatterNoStyle];
    }
    
    // time
    if (NSDateFormatterNoStyle != dateStyle){
        [formatter setTimeStyle:timeStyle];
        timeString = [formatter stringFromDate:self];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    if (NSDateFormatterNoStyle != dateStyle && NSDateFormatterNoStyle != dateStyle){
        return [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    }
    else{
        return (NSDateFormatterNoStyle!=dateStyle ? dateString : timeString);
    }
}

// return the time set for start hour. ie yyyy-mm-dd 00:00:00
-(NSDate*)getDayStartTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* strDate = [NSString stringWithFormat:@"%@ 00:00:00", [self toStringYMD]];
    NSDate *startDate = [formatter dateFromString:strDate];
    
    [formatter release];
    
    return startDate;
}

// return the time set for end hour, minute, secend. ie yyyy-mm-dd 23:59:59
-(NSDate*)getDayEndTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate = [NSString stringWithFormat:@"%@ 23:59:59", [self toStringYMD]];
    NSDate *endDate = [formatter dateFromString:strDate];
    
    [formatter release];
    
    return endDate;
}

// offset day. ie self=2012-01-05 day=1 return 2012-01-06, self=2012-01-05 day=-1 return 2012-01-04.
-(NSDate*)offsetDay:(NSInteger)day
{
    NSTimeInterval interval = (86400.0*day);
    return [self dateByAddingTimeInterval:interval];
}

-(NSDate*)dateAfterMonth:(NSInteger)month
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate* date = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    [componentsToAdd release];
    return date;
}
@end
