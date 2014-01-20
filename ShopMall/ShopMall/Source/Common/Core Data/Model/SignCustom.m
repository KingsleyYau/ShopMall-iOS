//
//  SignCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-10.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SignCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Sign(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:SignID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    
    // 签到内容
    foundValue = [dict objectForKey:SignBody];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.body = foundValue;
    }
    
    // 最后更新时间
    foundValue = [dict objectForKey:SignTime];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.time = [NSDate dateWithTimeIntervalSince1970:[foundValue integerValue]];
    }
    
    // 总体评分
    foundValue = [dict objectForKey:Score];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.score = foundValue;
    }
    // 产品评分
    foundValue = [dict objectForKey:Score1];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scorePdu = foundValue;
    }
    // 气氛评分
    foundValue = [dict objectForKey:Score2];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scoreEnv = foundValue;
    }
    // 客服评分
    foundValue = [dict objectForKey:Score3];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scoreSrv = foundValue;
    }
    // 其他评分
    foundValue = [dict objectForKey:Score4];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scoreOth = foundValue;
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
    
    // 商户信息
    foundValue = [dict objectForKey:ShopID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        Shop *shop = [ShopDataManager shopInsertWithId:foundValue];
        foundValue = [dict objectForKey:ShopName];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
            shop.shopName = foundValue;
        }
        self.shop = shop;
    }
    
    // 会员信息
    Custom *custom = [ShopDataManager customInsertWithDict:dict];
    self.custom = custom;

    // 附件
    foundValue = [dict objectForKey:SignAtachment];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.attachment = file;
    }
}
@end
