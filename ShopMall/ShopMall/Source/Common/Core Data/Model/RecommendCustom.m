//
//  RecommendCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RecommendCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Recommend(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:RecommendID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
//    id foundValue = nil;
//    foundValue = [dict objectForKey:RecommendTitle];
//    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
//        self. = foundValue;
//    }

}
@end
