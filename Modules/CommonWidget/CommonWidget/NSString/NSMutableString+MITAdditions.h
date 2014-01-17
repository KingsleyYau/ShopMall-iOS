//
//  NSString+MITAdditions.h
//  CommonWidget
//
//  Created by KingsleyYau on 13-10-17.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (MITAdditions)
- (void)replaceOccurrencesOfStrings:(NSArray *)targets withStrings:(NSArray *)replacements options:(NSStringCompareOptions)options;
@end
