//
//  ShopNewsRankCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsRankCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation ShopNewsRank(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:ShopNewsRankID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:ShopNewsRankName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.rankName = foundValue;
    }
    foundValue = [dict objectForKey:ShopNewsTypeRankIcon];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logo = file;
    }
}
@end
