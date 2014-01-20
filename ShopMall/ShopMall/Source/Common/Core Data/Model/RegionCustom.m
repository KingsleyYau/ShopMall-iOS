//
//  RegionCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegionCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Region(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:RegionID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:RegionName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.regionName = foundValue;
    }
    
    // 纬度
    foundValue = [dict objectForKey:LAT];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.lat = [NSNumber numberWithDouble:[foundValue doubleValue]];
    }
    // 经度
    foundValue = [dict objectForKey:LNG];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.lon = [NSNumber numberWithDouble:[foundValue doubleValue]];
    }
    
    foundValue = [dict objectForKey:RegionParent];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        Region *parent = [ShopDataManager regionInsertWithId:foundValue];
        self.parent = parent;
    }
}
@end
