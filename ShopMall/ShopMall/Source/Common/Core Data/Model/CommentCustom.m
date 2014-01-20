//
//  CommentCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-4.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CommentCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Comment(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:CommentID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
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
    
    // 点评内容
    foundValue = [dict objectForKey:CommmentBody];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.body = foundValue;
    }

    // 最后更新时间
    foundValue = [dict objectForKey:CommentTime];
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

}
@end
