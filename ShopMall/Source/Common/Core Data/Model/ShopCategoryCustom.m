//
//  ShopCategoryCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCategoryCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"

@implementation ShopCategory (Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:CategoryID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:CategoryName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.categoryName = foundValue;
    }
    
    foundValue = [dict objectForKey:CategoryIcon];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logoImage = file;
    }
    
    foundValue = [dict objectForKey:CategoryParent];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        ShopCategory *parentCategory = [ShopDataManager categaoryInsertWithId:foundValue];
        self.categoryParent = parentCategory;
    }
    
    foundValue = [dict objectForKey:CityHyShopCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.hyfShopCount = foundValue;
    }

    foundValue = [dict objectForKey:CityDsfShopCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.dsfShopCount = foundValue;
    }
}
@end
