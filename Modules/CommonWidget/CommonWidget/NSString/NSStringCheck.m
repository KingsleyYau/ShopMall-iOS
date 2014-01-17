//
//  NSStringCheck.m
//  DrPalm
//
//  Created by JiangBo on 13-1-6.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "NSStringCheck.h"

@implementation NSString (Check)
//检查是否合法手机号
- (BOOL)isPhoneNum {
    if([self length] != 11)
        return NO;
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}
- (BOOL)isSearchString {
    NSString *regex = @"^[A-Z,a-z,0-9,u4e00-u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (NSString *)commitString {
    NSString *retString = self;
    
    NSMutableArray *checkArray = [NSMutableArray arrayWithObjects:@"\\", @"'", @"\"", @">", @"<", nil];
    
    for(NSString *checkString in checkArray) {
        NSString *withString = [NSString stringWithFormat:@"\\%@", checkString];
        retString = [retString stringByReplacingOccurrencesOfString:checkString withString:withString];
    }    
    return retString;
}
@end
