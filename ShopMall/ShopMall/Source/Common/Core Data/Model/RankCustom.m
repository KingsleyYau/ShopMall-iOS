//
//  RankCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RankCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Rank(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:RankID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:RankName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.rankName = foundValue;
    }
    foundValue = [dict objectForKey:RankIcon];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logo = file;
    }
}
@end
