//
//  ProductCustom.m
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ProductCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Product(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:ProductID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:ProductName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.productName = foundValue;
    }
    
    foundValue = [dict objectForKey:ProductDefaultPic];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.productImage = file;
    }
    
}
@end
