//
//  ShopCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation Shop(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict {
    NSNumber *numberID = nil;
    id foundValue = [dict objectForKey:ShopID];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        numberID = foundValue;
    }
    return numberID;
}
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    // 商户名字
    foundValue = [dict objectForKey:ShopName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.shopName = foundValue;
    }
    // 商户地址
    
    // 加入时间
    foundValue = [dict objectForKey:ShopAddDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.addDate = [NSDate dateWithTimeIntervalSince1970:[foundValue integerValue]];
    }
    // 最后更新时间
    foundValue = [dict objectForKey:ShopLastDate];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.lastDate = [NSDate dateWithTimeIntervalSince1970:[foundValue integerValue]];
    }
    // 纬度
    foundValue = [dict objectForKey:LAT];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.lat = foundValue;
    }
    // 经度
    foundValue = [dict objectForKey:LNG];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.lon = foundValue ;
    }
    // 英文名字
    foundValue = [dict objectForKey:ShopEngName];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.shopNameEng = foundValue;
    }
    // 打折
    foundValue = [dict objectForKey:ShopIfDiscount];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isDiscount = foundValue;
    }
    // 优惠券
    foundValue = [dict objectForKey:ShopIfPromo];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isPromo = foundValue;
    }
    // 赠送
    foundValue = [dict objectForKey:ShopIfGift];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isGift = foundValue;
    }
    // 会员卡
    foundValue = [dict objectForKey:ShopIfCard];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isCard = foundValue;
    }
    // 是否合作商家
    foundValue = [dict objectForKey:ShopIfHyf];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isHyf = foundValue;
    }
    // 是否第三方
    foundValue = [dict objectForKey:ShopIfDsf];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.isDsf = foundValue;
    }
    // 平均价格
    foundValue = [dict objectForKey:ShopPriceAvg];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
        self.priceAvg = foundValue;
    }
    // 价格描述
    foundValue = [dict objectForKey:ShopPriceText];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.priceText = foundValue;
    }
    // 地址
    foundValue = [dict objectForKey:ShopAddress];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.address = foundValue;
    }
    // 商家描述
    foundValue = [dict objectForKey:ShopWriteup];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.writeUp = foundValue;
    }
    // 电话
    foundValue = [dict objectForKey:ShopPhone];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.phone = foundValue;
    }
    // 电话2
    foundValue = [dict objectForKey:ShopPhone2];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.phone2 = foundValue;
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
    // 商家评分描述
    foundValue = [dict objectForKey:ShopScoreText];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.scoreText = foundValue;
    }
    // 交通描述
    foundValue = [dict objectForKey:ShopTrafficInfo];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        self.trafficInfo = foundValue;
    }
    // 资讯相关
    foundValue = [dict objectForKey:ShopInfoSituation];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSDictionary class]]) {
        // 资讯数量
        id foundValueSub = [foundValue objectForKey:ShopInfoCount];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.lastInfoCount = foundValueSub;
        }
        // 最新资讯标题
        foundValueSub = [foundValue objectForKey:ShopInfoLastTitle];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            self.lastInfoTitle = foundValueSub;
        }
    }

    // 最后评论
    foundValue = [dict objectForKey:ShopCommentSituation];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSDictionary class]]) {
        id foundValueSub = [foundValue objectForKey:ShopCommentTotal];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.totalComment = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopCommentCuruser];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            self.lastCommentUser = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopCommentCurcommentStar];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.lastCommentStar = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopCommentCurcomment];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            self.lastComment = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopCommentCurcommentTime];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.lastCommentTime = [NSDate dateWithTimeIntervalSince1970:[foundValueSub doubleValue]];
        }
    }
    
    // 最后签到
    foundValue = [dict objectForKey:ShopSignSituation];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSDictionary class]]) {
        id foundValueSub = [foundValue objectForKey:ShopSignTotal];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.totalSign = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopSignCuruser];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            self.lastSignUser = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopSignDetail];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSString class]]) {
            self.lastSignDetail = foundValueSub;
        }
        foundValueSub = [foundValue objectForKey:ShopSignCurSignTime];
        if(nil != foundValueSub && [NSNull null] != foundValueSub && [foundValueSub isKindOfClass:[NSNumber class]]) {
            self.lastSignTime = [NSDate dateWithTimeIntervalSince1970:[foundValueSub doubleValue]];
        }
    }
    
    
    // 图片
    foundValue = [dict objectForKey:ShopDefaultPic];
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
    // 网友推荐
    foundValue = [dict objectForKey:ShopRecommendTags];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictSub in foundValue) {
            
            id foundValueSub = [dictSub objectForKey:ShopRecommendID];
            if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSNumber class]]) {
                Recommend *recommend = [ShopDataManager recommendInsertWithId:foundValueSub shopID:self.shopID];
                foundValueSub = [dict objectForKey:ShopRecommendTag];
                if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
                    recommend.recommendTag = foundValueSub;
                }
            }
        }
    }
    
}
@end
