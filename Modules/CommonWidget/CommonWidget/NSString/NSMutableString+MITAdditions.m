//
//  NSString+MITAdditions.m
//  CommonWidget
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import "NSMutableString+MITAdditions.h"

@implementation NSMutableString (MITAdditions)
- (void)replaceOccurrencesOfStrings:(NSArray *)targets withStrings:(NSArray *)replacements options:(NSStringCompareOptions)options {
    assert([targets count] == [replacements count]);
    NSInteger i = 0;
    for (NSString *target in targets) {
        [self replaceOccurrencesOfString:target withString:[replacements objectAtIndex:i] options:options range:NSMakeRange(0, [self length])];
        i++;
    }
}
@end
