//
//  NSString+UrlCode.m
//  DrPalm
//
//  Created by fgx_lion on 12-2-2.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "NSString+UrlCode.h"

@implementation NSString (UrlCode)
- (NSString*)UrlDecode
{
    NSString *decode = [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decode;
}

- (NSString*)UrlEncode
{
    NSString *result = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
@end
