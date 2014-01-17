//
//  CustomCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-4.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CustomCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Custom(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict {
    NSString *itemId = nil;
    id foundValue = [dict objectForKey:CustomUserID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        itemId = foundValue;
    }
    return itemId;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:CustomUserName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.customName = foundValue;
    }
    foundValue = [dict objectForKey:CustomUserIcon];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logo = file;
    }
}
@end
