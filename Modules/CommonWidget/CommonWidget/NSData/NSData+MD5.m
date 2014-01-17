//
//  NSData+MD5.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-23.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)
- (NSString*)toMD5String
{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(str, [self length], result);
    NSMutableString *code = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [code appendFormat:@"%02x", result[i]];
    }
    return code;
}
@end
