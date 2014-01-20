//
//  ShopSortTypeCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopSortTypeCustom.h"
#import "CommonRequestDefine.h"
@implementation ShopSortType(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:SortID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:SortName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.sortName = foundValue;
    }
}
@end
