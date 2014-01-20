//
//  UserCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "UserCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation User(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict {
    NSString *userID = nil;
    id foundValue = [dict objectForKey:UserID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        userID = foundValue;
    }
    return userID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    // 用户名
    foundValue = [dict objectForKey:UserName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.userName = foundValue;
    }
    // 用户等级
    foundValue = [dict objectForKey:UserLevel];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.level = foundValue;
    }
    // 平台积分
    foundValue = [dict objectForKey:UserScoreSp];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scoreSp = foundValue;
    }
    // 第三方积分
    foundValue = [dict objectForKey:UserScoreOth];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.scoreOther = foundValue;
    }
    // 我的券券
    foundValue = [dict objectForKey:UserInfoCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countInfo = foundValue;
    }
    
    
    // 签到次数
    foundValue = [dict objectForKey:UserCheckInCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countSign = foundValue;
    }
    // 评论次数
    foundValue = [dict objectForKey:UserReviewCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countComment = foundValue;
    }
    // 上传图片数量
    foundValue = [dict objectForKey:UserPhotoCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countPhoto = foundValue;
    }
    // 收藏的商户
    foundValue = [dict objectForKey:UserFavShopCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countFavour = foundValue;
    }
    // 收藏商户未读
    foundValue = [dict objectForKey:UserFavShopInfoCount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.countFavourUnread = foundValue;
    }
    
    // 头像
    foundValue = [dict objectForKey:UserIcon];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logo = file;
    }
}
@end
