//
//  CityCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-24.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CityCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"

@implementation City(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:CityID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:CityName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        // 小写存储
        self.cityName = [foundValue lowercaseString];
    }
    
    foundValue = [dict objectForKey:CityChar];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.firstChar = foundValue;
    }
    
    foundValue = [dict objectForKey:CityAreaCode];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.cityCode = foundValue;
    }
    
    foundValue = [dict objectForKey:CityRegionName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        CityRegion *item = [ShopDataManager cityRegionInsertWitdhCityRegionName:foundValue];
        self.cityRegion = item;
    }
    
    foundValue = [dict objectForKey:CityIsHot];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isHot = foundValue;
    }
    
    foundValue = [dict objectForKey:CityIsPromo];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isPromo = foundValue;
    }
    
    foundValue = [dict objectForKey:CityTop];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isTop = foundValue;
    }
    
    foundValue = [dict objectForKey:LAT];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.lat = [NSNumber numberWithDouble:[foundValue doubleValue]];
    }
    
    foundValue = [dict objectForKey:LNG];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.lon = [NSNumber numberWithDouble:[foundValue doubleValue]];
    }
}
@end
