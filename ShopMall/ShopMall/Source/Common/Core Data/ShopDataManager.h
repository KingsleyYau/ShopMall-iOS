//
//  ClassDataManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

#import "FileCustom.h"
#import "CurrentInfoCustom.h"
#import "UserCustom.h"

#import "ShopImageCustom.h"
#import "CityCustom.h"
#import "CityRegionCustom.h"
#import "ShopCustom.h"
#import "ShopCategoryCustom.h"
#import "CreditCustom.h"
#import "RegionCustom.h"
#import "ShopSortTypeCustom.h"
#import "RankCustom.h"

#import "CommentCustom.h"
#import "SignCustom.h"
#import "ShopImageCustom.h"
#import "CustomCustom.h"
#import "RecommendCustom.h"
#import "ProductCustom.h"

// 资讯
#import "ShopNewsCustom.h"
#import "ShopNewsTypeCustom.h"
#import "ShopNewsRankCustom.h"
#import "ShopNewsPhotoCustom.h"
#import "ShopPersonalNewsCustom.h"
@interface ShopDataManager : NSObject
#pragma mark - 重置商户排序
+ (void)resetShopOrder;
#pragma mark - 清除离线数据
+ (void)clearDataBase;
+ (void)clearShops;
+ (void)clearShopNews;
+ (void)clearCategory;
+ (void)clearRegion;
+ (void)clearUserData;
+ (void)clearShopData;
#pragma mark - 文件模块 (File)
// 插入文件
+ (File *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal;
#pragma mark - 图片模块 (ShopImage) 
+ (ShopImage *)imageWithID:(NSNumber *)itemID;
+ (ShopImage *)imageInsertWithID:(NSNumber *)itemID;
+ (ShopImage *)imageInsertWithDict:(NSDictionary *)dict;
#pragma mark - 城市模块 (City)
// 按首字母
+ (NSArray *)cityList:(NSString *)firstChar;
// 按标题或者首字母
+ (NSArray *)cityListBySearchKey:(NSString *)searchString;
// 按省份
+ (NSArray *)cityListByRegion:(NSString *)itemName;
+ (City *)cityWitdhCityId:(NSNumber *)cityID;
+ (City *)cityInsertWithId:(NSNumber *)cityID;
+ (City *)cityInsertWithDict:(NSDictionary *)dict;
#pragma mark - 城市省份模块 (CityRegion)
+ (NSArray *)cityRegionList;
+ (CityRegion *)cityRegionWitdhCityRegionName:(NSString *)itemName;
+ (CityRegion *)cityRegionInsertWitdhCityRegionName:(NSString *)itemName;
#pragma mark - 用户模块
+ (User *)userWithUserID:(NSString *)itemID;
+ (User *)userInsertWithUserID:(NSString *)itemID;
+ (User *)userInsertWithDict:(NSDictionary *)dict;
#pragma mark - 配置模块
+ (CurrentInfo *)currentInfo;
+ (BOOL)cityChangeCurrent:(City *)newCity;
+ (City *)cityCurrent;
+ (BOOL)cityChangeGPS:(City *)newCity;
+ (City *)cityGPS;
+ (BOOL)userChangeCurrent:(User *)newUser;
+ (User *)userCurrent;
#pragma mark - 商区模块 (Region)
#define TopRegionID 0
// 获取顶层商区
+ (NSArray *)regionList;
// 获取子商区
+ (NSArray *)regionListWithParent:(NSNumber *)parentID;
// 获取全部商区
+ (Region *)topRegion;
// 查找商圈
+ (Region *)regionWithId:(NSNumber *)itemID;
// 查找指定城市下的顶层商区
+ (NSArray *)regionWithCityId:(NSNumber *)cityID;
// 添加商区
+ (Region *)regionInsertWithId:(NSNumber *)itemID;
+ (Region *)regionInsertWithDict:(NSDictionary *)dict;
#pragma mark - 行业分类模块 (ShopCategory)
#define TopCategoryID 0
// 初始化本地行业分类
+ (NSArray *)staticCategory;
// 获取所有分类
+ (NSArray *)categoryListAll;
// 获取顶层行业分类
+ (NSArray *)categoryList;
// 获取子行业分类
+ (NSArray *)categoryListWithParent:(NSNumber *)parentID;
// 获取全部频道
+ (ShopCategory *)topCategory;
// 查找行业分类
+ (ShopCategory *)categaoryWithId:(NSNumber *)itemID;
// 查找指定城市下的顶层行业
+ (NSArray *)categoryWithCityId:(NSNumber *)cityID;
// 添加行业分类
+ (ShopCategory *)categaoryInsertWithId:(NSNumber *)itemID;
+ (ShopCategory *)categaoryInsertWithDict:(NSDictionary *)dict;
#pragma mark - 排行榜模块 (Rank)
// 获取有排行榜的行业
+ (NSArray *)categoryListHasRank;
// 根据行业获取所有排行榜分类
+ (NSArray *)rankList:(NSNumber *)categoryID;
// 查找排行榜分类
+ (Rank *)rankWithId:(NSNumber *)itemID categoryID:(NSNumber *)categoryID;
// 添加排行榜分类
+ (Rank *)rankInsertWithId:(NSNumber *)itemID categoryID:(NSNumber *)categoryID;
+ (Rank *)rankInsertWithDict:(NSDictionary *)dict categoryID:(NSNumber *)categoryID;
#pragma mark - 积分分类模块 (Credit)
#define TopCreditID 0
// 默认积分
+ (Credit *)topCredit;
// 获取所有积分分类
+ (NSArray *)creditList;
// 添加积分分类
+ (Credit *)creditInsertWithId:(NSNumber *)itemID;
+ (Credit *)creditInsertWithDict:(NSDictionary *)dict;
#pragma mark - 排行分类模块 (ShopSortType)
#define TopShopSortTypeID 0
// 默认排序
+ (ShopSortType *)topShopSortType;
// 获取所有积分分类
+ (NSArray *)sortList;
// 查找排行分类
+ (ShopSortType *)sortWithId:(NSNumber *)itemID;
// 添加排行分类
+ (ShopSortType *)sortInsertWithId:(NSNumber *)itemID;
+ (ShopSortType *)sortInsertWithDict:(NSDictionary *)dict;
#pragma mark - 商户模块 (Shop)
+ (NSArray *)shopList:(NSNumber *)cityID categoryID:(NSNumber *)categoryID creditID:(NSNumber *)creditID regionID:(NSNumber *)regionID rankID:(NSNumber *)rankID  keyword:(NSString *)keyword;
+ (NSArray *)shopBookmarkList;
// 查找商户
+ (Shop *)shopWithId:(NSNumber *)itemID;
// 添加商户
+ (Shop *)shopInsertWithId:(NSNumber *)itemID;
+ (Shop *)shopInsertWithDict:(NSDictionary *)dict;
#pragma mark - 点评模块 (Comment)
// 获取所有点评
+ (NSArray *)commentAll;
// 获取当前用户点评
+ (NSArray *)CommentWithUserCurrent;
// 获取商户所有点评
+ (NSArray *)commentWithShopID:(NSNumber *)shopID;
// 查找点评
+ (Comment *)commentWithId:(NSNumber *)itemID;
// 添加点评
+ (Comment *)commentInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;
+ (Comment *)commentInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID;
#pragma mark - 签到模块 (Sign)
// 获取所有签到
+ (NSArray *)signAll;
// 获取当前用户签到
+ (NSArray *)signWithUserCurrent;
// 获取商户所有签到
+ (NSArray *)signWithShopID:(NSNumber *)shopID;
// 查找签到
+ (Sign *)signWithId:(NSNumber *)itemID;
// 添加签到
+ (Sign *)signInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;
+ (Sign *)signInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID;
#pragma mark - 商户图片模块 (ShopImage)
// 获取所有商户图片分类
+ (NSArray *)shopImageTypeList;
// 获取所有商户图片
+ (NSArray *)shopImageAll;
// 获取当前用户所有商户图片
+ (NSArray *)shopImageUserCurrent:(NSString *)imageType;
// 获取商户所有商户图片
+ (NSArray *)shopImageWithShopID:(NSNumber *)shopID imageType:(NSString *)imageType;
// 查找商户图片
+ (ShopImage *)shopImageWithId:(NSNumber *)itemID;
// 添加商户图片
+ (ShopImage *)shopImageInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;
+ (ShopImage *)shopImagensertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID;
#pragma mark - 推荐模块 (Recommend)
+ (NSArray *)recommendWithShopID:(NSNumber *)shopID;
// 查找推荐
+ (Recommend *)recommendWithId:(NSNumber *)itemID;
// 添加推荐
+ (Recommend *)recommendInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;;
+ (Recommend *)recommendInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID;
#pragma mark - 产品模块 (Product)
+ (NSArray *)productListWithShopID:(NSNumber *)shopID;
// 查找产品
+ (Product *)productWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;
// 添加产品
+ (Product *)productInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID;;
+ (Product *)productInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID;
#pragma mark - 用户模块 (Custom)
// 查找用户
+ (Custom *)customWithId:(NSString *)itemID;
// 添加用户
+ (Custom *)customInsertWithId:(NSString *)itemID;
+ (Custom *)customInsertWithDict:(NSDictionary *)dict;


#pragma mark -
#pragma mark - 资讯模块 (ShopNews)
// 获取所有资讯
+ (NSArray *)shopNewsList:(NSNumber *)cityID categoryID:(NSNumber *)categoryID creditID:(NSNumber *)creditID shopNewsTypeId:(NSNumber *)shopNewsTypeId keyword:(NSString *)keyword shopId:(NSNumber *)shopId;
// 查找资讯
+ (ShopNews *)shopNewsWithId:(NSNumber *)itemID;
// 添加资讯
+ (ShopNews *)shopNewsInsertWithId:(NSNumber *)itemID;
+ (ShopNews *)shopNewsInsertWithDict:(NSDictionary *)dict;
#pragma mark - 资讯分类模块 (ShopNewsType)
#define TopShopNewsTypeID 0
// 默认排序
+ (ShopNewsType *)topShopNewsType;
// 获取所有资讯分类
+ (NSArray *)shopNewsTypeList;
// 查找资讯分类
+ (ShopNewsType *)shopNewsTypeWithId:(NSNumber *)itemID;
// 添加资讯分类
+ (ShopNewsType *)shopNewsTypeInsertWithId:(NSNumber *)itemID;
+ (ShopNewsType *)shopNewsTypeInsertWithDict:(NSDictionary *)dict;
#pragma mark - 资讯分类排行榜模块 (ShopNewsRank)
// 获取有排行榜的资讯类型
+ (NSArray *)shopNewsRankListHasRank;
// 根据资讯类型获取所有排行榜分类
+ (NSArray *)shopNewsRankList:(NSNumber *)shopNewsTypeID;
// 查找排行榜分类
+ (ShopNewsRank *)shopNewsRankWithId:(NSNumber *)itemID shopNewsTypeID:(NSNumber *)shopNewsTypeID;
// 添加排行榜分类
+ (ShopNewsRank *)shopNewsRankInsertWithId:(NSNumber *)itemID shopNewsTypeID:(NSNumber *)shopNewsTypeID;
+ (ShopNewsRank *)shopNewsRankInsertWithDict:(NSDictionary *)dict shopNewsTypeID:(NSNumber *)shopNewsTypeID;
#pragma mark - 资讯分类模块 (ShopNewsPhoto)
// 查找资讯分类
+ (ShopNewsPhoto *)shopNewsPhotoWithShopNewsId:(NSNumber *)shopNewsID;
// 添加资讯分类
+ (ShopNewsPhoto *)shopNewsPhotoInsertWithShopNewsId:(NSNumber *)shopNewsID;
+ (ShopNewsPhoto *)shopNewsPhotoInsertWithDict:(NSDictionary *)dict shopNewsID:(NSNumber *)shopNewsID;
#pragma mark - 我的券券模块 (ShopNews)
// 获取所有我的券券
+ (NSArray *)shopPersonalNewsList:(NSNumber *)status;
// 查找我的券券
+ (ShopPersonalNews *)shopPersonalNewsWithId:(NSNumber *)itemID;
// 添加我的券券
+ (ShopPersonalNews *)shopPersonalNewsInsertWithId:(NSNumber *)itemID;
+ (ShopPersonalNews *)shopPersonalNewsInsertWithDict:(NSDictionary *)dict;
@end
