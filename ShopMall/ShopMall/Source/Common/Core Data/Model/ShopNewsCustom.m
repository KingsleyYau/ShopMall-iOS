//
//  ShopNewsCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-9.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"

@implementation ShopNews(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:ShopNewsID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    // 生效开始时间
    foundValue = [dict objectForKey:ShopNewsInfoBeginDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.infoBeginDate = [NSDate dateWithTimeIntervalSince1970:[foundValue intValue]];
    }
    // 生效结束时间
    foundValue = [dict objectForKey:ShopNewsInfoEndDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.infoEndDate = [NSDate dateWithTimeIntervalSince1970:[foundValue intValue]];
    }
    // 公布开始时间
    foundValue = [dict objectForKey:ShopNewsBeginDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.beginDate = [NSDate dateWithTimeIntervalSince1970:[foundValue intValue]];
    }
    // 截至结束时间
    foundValue = [dict objectForKey:ShopNewsEndDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.endDate = [NSDate dateWithTimeIntervalSince1970:[foundValue intValue]];
    }
    // 标题
    foundValue = [dict objectForKey:ShopNewsTitle];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.infoTitle = foundValue;
    }
    // 短信基础内容
    foundValue = [dict objectForKey:ShopNewsSmsInfo];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.smsinfo = foundValue;
    }
    // 是否需要短信验证码(0:否 1:是)
    foundValue = [dict objectForKey:ShopNewsEndDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.hassms = [NSNumber numberWithBool:[foundValue boolValue]];
    }
    // 描述 (Html格式)
    foundValue = [dict objectForKey:ShopNewsDesc];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.infoDes = foundValue;
    }
    
    // showType
    foundValue = [dict objectForKey:ShopNewsShowType];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.showType = foundValue;
    }
    // getType
    foundValue = [dict objectForKey:ShopNewsGetType];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.getType = foundValue;
    }
    // showType
    foundValue = [dict objectForKey:ShopNewsShowType];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.showType = foundValue;
    }
    // showTips
    foundValue = [dict objectForKey:ShopNewsShowTips];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.showTips = foundValue;
    }
    // getTips
    foundValue = [dict objectForKey:ShopNewsGetTips];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.getTips = foundValue;
    }
    
    // 内容图
    foundValue = [dict objectForKey:ShopNewsDetailPhoto];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.detailPhoto = file;
    }
    // 缩略图
    foundValue = [dict objectForKey:ShopNewsDefaultPic];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.logo = file;
    }
    // 城市
    foundValue = [dict objectForKey:CityID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        City *city = [ShopDataManager cityInsertWithId:foundValue];
        self.city = city;
    }
    // 所属商铺
    foundValue = [dict objectForKey:ShopID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        Shop *shop = [ShopDataManager shopInsertWithId:foundValue];
        foundValue = [dict objectForKey:ShopName];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
            shop.shopName = foundValue;
        }
        self.shop = shop;
    }
    // 资讯分类
    foundValue = [dict objectForKey:ShopNewsTypeID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        ShopNewsType *shopNewsType = [ShopDataManager shopNewsTypeInsertWithId:foundValue];
        foundValue = [dict objectForKey:ShopNewsTypeName];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
            shopNewsType.shopNewsTypeName = foundValue;
        }
        self.shopNewsType = shopNewsType;
    }
    // 行业
    foundValue = [dict objectForKey:CategoryID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        ShopCategory *category = [ShopDataManager categaoryInsertWithId:foundValue];
        foundValue = [dict objectForKey:CategoryName];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
            category.categoryName = foundValue;
        }
        self.category = category;
    }
    // 商圈
    foundValue = [dict objectForKey:RegionID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        Region *region = [ShopDataManager regionInsertWithId:foundValue];
        foundValue = [dict objectForKey:RegionName];
        if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
            region.regionName = foundValue;
        }
        self.region = region;
    }
}
@end
