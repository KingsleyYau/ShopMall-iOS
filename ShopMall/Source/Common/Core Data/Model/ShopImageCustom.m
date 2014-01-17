//
//  ShopImageCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopImageCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation ShopImage(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:ImageID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    // 名字
    foundValue = [dict objectForKey:ImageName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.imgName = foundValue;
    }
    // 类型
    foundValue = [dict objectForKey:ImageType];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.imgType = foundValue;
    }
    // 上传事件
    foundValue = [dict objectForKey:ImageUploadTime];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.uploadTime = [NSDate dateWithTimeIntervalSince1970:[foundValue intValue]];
    }
    // 上传用户
    foundValue = [dict objectForKey:ImageUploadUser];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.uploadUser = foundValue;
    }
    // 评分
    foundValue = [dict objectForKey:ImageStar];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.star = foundValue;
    }
    // 人均价格
    foundValue = [dict objectForKey:ImagePrice];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.price = foundValue;
    }
    // 标签
    foundValue = [dict objectForKey:ImageTag];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.tag = foundValue;
    }
    
    // 缩略图
    foundValue = [dict objectForKey:ImageThumbUrl];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.thumFile = file;
    }
    // 原始图
    foundValue = [dict objectForKey:ImageFullUrl];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.fullFile = file;
    }
}
@end
