//
//  NSString+MD5HexDigest.m
//  DrPalm
//
//  Created by fgx_lion on 12-2-2.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "NSString+MD5HexDigest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5HexDigest)
- (NSString*)toMD5String
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(str, strlen(str), result);
    NSMutableString *code = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [code appendFormat:@"%02X", result[i]];
    }
    return code;
}
@end
