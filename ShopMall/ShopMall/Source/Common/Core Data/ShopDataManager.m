//
//  ClassDataManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopDataManager.h"
#import "LoginManager.h"
#import "ResourceManager.h"
@implementation ShopDataManager
#pragma mark - 重置商户排序
+ (void)resetShopOrder {
    NSArray *items = [ShopDataManager shopList:nil categoryID:nil creditID:nil regionID:nil rankID:nil keyword:nil];
    for(Shop *item in items) {
        item.sortOrder = [NSNumber numberWithInteger:99999];
    }
    [CoreDataManager saveData];
}
#pragma mark - 清除离线数据
+ (void)clearDataBase {
//    [ShopDataManager clearCategory];
    [ShopDataManager clearRegion];
    [ShopDataManager clearShops];
    [ShopDataManager clearShopNews];
    [ShopDataManager clearUserData];
    [CoreDataManager saveData];
}
+ (void)clearShops {
    NSArray *items = [ShopDataManager shopList:nil categoryID:nil creditID:nil regionID:nil rankID:nil keyword:nil];
    [CoreDataManager deleteObjects:items];
    
    items = [ShopDataManager commentAll];
    [CoreDataManager deleteObjects:items];
    
    items = [ShopDataManager signAll];
    [CoreDataManager deleteObjects:items];
    
}
+ (void)clearShopNews {
    NSArray *items = [ShopDataManager shopNewsList:nil categoryID:nil creditID:nil shopNewsTypeId:nil keyword:nil shopId:nil];
    [CoreDataManager deleteObjects:items];
}
+ (void)clearCategory {
    NSArray *items = [ShopDataManager categoryListAll];
    [CoreDataManager deleteObjects:items];
}
+ (void)clearRegion {
    NSArray *items = [ShopDataManager regionListAll];
    [CoreDataManager deleteObjects:items];
}
+ (void)clearUserData {
    NSArray *items = [ShopDataManager shopBookmarkList];
    [CoreDataManager deleteObjects:items];
    
    items = [ShopDataManager CommentWithUserCurrent];
    [CoreDataManager deleteObjects:items];
    
    items= [ShopDataManager signWithUserCurrent];
    [CoreDataManager deleteObjects:items];
    
    items = [ShopDataManager shopImageUserCurrent:nil];
    [CoreDataManager deleteObjects:items];
}
#pragma mark - 文件模块 ()
// 插入文件
+ (File *)fileWithUrl:(NSString *)url isLocal:(Boolean)isLocal {
    File *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", url];
    item = [[CoreDataManager objectsForEntity:ShopFileEntityName matchingPredicate:predicate] lastObject];
    if (!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopFileEntityName];
    }
    [item updateWithFileUrl:url isLocal:isLocal];
    return item;
}
#pragma mark - 图片模块 (ShopImage) 
+ (ShopImage *)imageWithID:(NSNumber *)itemID {
    ShopImage *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imgID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:ShopImageEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (ShopImage *)imageInsertWithID:(NSNumber *)itemID {
    ShopImage *item = [ShopDataManager imageWithID:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopImageEntityName];
        item.imgID = itemID;
    }
    return item;
}
+ (ShopImage *)imageWithDict:(NSDictionary *)dict {
    ShopImage *item = nil;
    NSNumber *itemId = [ShopImage idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager imageInsertWithID:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 城市模块 (City)
// 按首字母
+ (NSArray *)cityList:(NSString *)firstChar {
    NSArray *array = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cityID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstChar == %@", firstChar];
    array = [CoreDataManager objectsForEntity:ShopCityEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
// 按标题或者首字母
+ (NSArray *)cityListBySearchKey:(NSString *)searchString {
    NSArray *array = [NSArray array];
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cityID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(cityName like[cd] %@) or (firstChar == %@)", [NSString stringWithFormat:@"*%@*", searchString], [searchString lowercaseString]];
    
    array = [CoreDataManager objectsForEntity:ShopCityEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
// 按省份
+ (NSArray *)cityListByRegion:(NSString *)itemName {
    NSArray *array = [NSArray array];
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cityID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(cityRegion.cityRegionName == %@)",  itemName];
    
    array = [CoreDataManager objectsForEntity:ShopCityEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
+ (City *)cityWitdhCityId:(NSNumber *)cityID {
    City *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityID == %@", cityID];
    item = [[CoreDataManager objectsForEntity:ShopCityEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (City *)cityInsertWithId:(NSNumber *)cityID {
    City *item = [ShopDataManager cityWitdhCityId:cityID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopCityEntityName];
        item.cityID = cityID;
    }
    return item;
}
+ (City *)cityInsertWithDict:(NSDictionary *)dict {
    City *item = nil;
    NSNumber *itemId = [City idWithDict:dict];
    item = [ShopDataManager cityInsertWithId:itemId];
    [item updateWithDict:dict];
    return item;
}
#pragma mark - 城市省份模块 (CityRegion)
+ (NSArray *)cityRegionList {
    NSArray *array = [NSArray array];
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"cityRegionName" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    
    array = [CoreDataManager objectsForEntity:ShopCityRegionEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
+ (CityRegion *)cityRegionWitdhCityRegionName:(NSString *)itemName {
    CityRegion *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityRegionName == %@", itemName];
    item = [[CoreDataManager objectsForEntity:ShopCityRegionEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (CityRegion *)cityRegionInsertWitdhCityRegionName:(NSString *)itemName {
    CityRegion *item = [ShopDataManager cityRegionWitdhCityRegionName:itemName];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopCityRegionEntityName];
        item.cityRegionName = itemName;
    }
    return item;
}
#pragma mark - 用户模块
+ (User *)userWithUserID:(NSString *)itemID {
    User *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:UserEntityName matchingPredicate:predicate] lastObject];
    return item;
}
+ (User *)userInsertWithUserID:(NSString *)itemID {
    User *item = [ShopDataManager userWithUserID:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:UserEntityName];
        item.userID = itemID;
    }
    return item;
}
+ (User *)userInsertWithDict:(NSDictionary *)dict {
    User *item = nil;
    NSString *itemId = [User idWithDict:dict];
    item = [ShopDataManager userInsertWithUserID:itemId];
    [item updateWithDict:dict];
    return item;
}
#pragma mark - 配置模块
+ (CurrentInfo *)currentInfo {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceInfo == %@", DEVICEINFO];
    CurrentInfo *item = [[CoreDataManager objectsForEntity:CurrentInfoEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CurrentInfoEntityName];
    }
    return item;
}
+ (BOOL)cityChangeCurrent:(City *)newCity {
    CurrentInfo *info = [ShopDataManager currentInfo];
    info.cityCurrent = newCity;
    [CoreDataManager saveData];
    return YES;
}
+ (City *)cityCurrent {
    City *item = nil;
    CurrentInfo *info = [ShopDataManager currentInfo];
    item = info.cityCurrent;
    return item;
}
+ (BOOL)cityChangeGPS:(City *)newCity {
    CurrentInfo *info = [ShopDataManager currentInfo];
    info.cityGPS = newCity;
    [CoreDataManager saveData];
    return YES;
}
+ (City *)cityGPS {
    City *item = nil;
    CurrentInfo *info = [ShopDataManager currentInfo];
    item = info.cityGPS;
    return item;
}
+ (BOOL)userChangeCurrent:(User *)newUser {
    CurrentInfo *info = [ShopDataManager currentInfo];
    info.user = newUser;
    [CoreDataManager saveData];
    return YES;
}
+ (User *)userCurrent {
    User *item = nil;
    CurrentInfo *info = [ShopDataManager currentInfo];
    item = info.user;
    return item;
}
#pragma mark - 商区模块 (Region)
#define TopRegionID 0
// 获取所有商区
+ (NSArray *)regionListAll {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"regionID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    NSArray *items = [CoreDataManager objectsForEntity:RegionEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取顶层商区
+ (NSArray *)regionList {
    // 父分类为空
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.regionID == %d", TopRegionID];
    NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"regionID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    NSArray *items = [CoreDataManager objectsForEntity:RegionEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取子商区
+ (NSArray *)regionListWithParent:(NSNumber *)parentID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.regionID == %@", parentID];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"regionID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    NSArray *items = [CoreDataManager objectsForEntity:RegionEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取顶层商区
+ (Region *)topRegion {
    Region *regionTop = [ShopDataManager regionInsertWithId:[NSNumber numberWithInteger:TopRegionID]];
    regionTop.regionName = @"全部商区";
    [CoreDataManager saveData];
    return regionTop;
}
// 查找商区
+ (Region *)regionWithId:(NSNumber *)itemID {
    Region *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:RegionEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 查找指定城市下的顶层商区
+ (NSArray *)regionWithCityId:(NSNumber *)cityID {
    NSArray *items = nil;
    City *city = [ShopDataManager cityWitdhCityId:cityID];
    if(city) {
        NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"regionID" ascending:YES] autorelease];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(any city == %@) and (parent.regionID == %d)", city, TopRegionID];
        items = [CoreDataManager objectsForEntity:RegionEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    }
    return items;
}
// 添加商区
+ (Region *)regionInsertWithId:(NSNumber *)itemID {
    Region *item = nil;
    item = [ShopDataManager regionWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:RegionEntityName];
        item.regionID = itemID;
    }
    return item;
}
+ (Region *)regionInsertWithDict:(NSDictionary *)dict {
    Region *item = nil;
    NSNumber *itemId = [Region idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager regionInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 排行榜模块 (Rank)
// 获取有排行榜的行业
+ (NSArray *)categoryListHasRank {
    NSArray *items = [NSArray array];
    NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"any ranks.rankID > 0"];
    items = [CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 根据行业获取所有排行榜分类
+ (NSArray *)rankList:(NSNumber *)categoryID {
    NSArray *items = [NSArray array];

    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"rankID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.categoryID == %@", categoryID];
    items = [CoreDataManager objectsForEntity:RankEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
// 查找排行分类
+ (Rank *)rankWithId:(NSNumber *)itemID categoryID:(NSNumber *)categoryID {
    Rank *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rankID == %@) and (category.categoryID == %@)", itemID, categoryID];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rankID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:RankEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加排行分类
+ (Rank *)rankInsertWithId:(NSNumber *)itemID categoryID:(NSNumber *)categoryID {
    Rank *item = [ShopDataManager rankWithId:itemID categoryID:categoryID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:RankEntityName];
        item.rankID = itemID;
        
        ShopCategory *category = [ShopDataManager categaoryInsertWithId:categoryID];
        item.category = category;
    }
    return item;
}
+ (Rank *)rankInsertWithDict:(NSDictionary *)dict categoryID:(NSNumber *)categoryID {
    Rank *item = nil;
    NSNumber *itemId = [Rank idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager rankInsertWithId:itemId categoryID:categoryID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 行业分类模块 (ShopCategory)
// 全部频道
+ (ShopCategory *)topCategory {
    ShopCategory *categoryTop = [ShopDataManager categaoryInsertWithId:[NSNumber numberWithInteger:TopCategoryID]];
    categoryTop.categoryName = @"全部频道";
    [CoreDataManager saveData];
    return categoryTop;
}
// 查找分类
+ (ShopCategory *)categaoryWithId:(NSNumber *)categoryID {
    ShopCategory *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID == %@", categoryID];
    item = [[CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 查找指定城市下的顶层行业
+ (NSArray *)categoryWithCityId:(NSNumber *)cityID {
    NSArray *items = nil;
    City *city = [ShopDataManager cityWitdhCityId:cityID];
    if(city) {
        NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES] autorelease];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"any city == %@", city];
        items = [CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    }
    return items;
}
// 添加分类
+ (ShopCategory *)categaoryInsertWithId:(NSNumber *)categoryID {
    ShopCategory *item = nil;
    item = [ShopDataManager categaoryWithId:categoryID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopCategoryEntityName];
        item.categoryID = categoryID;
    }
    return item;
}
+ (ShopCategory *)categaoryInsertWithDict:(NSDictionary *)dict {
    ShopCategory *item = nil;
    NSNumber *itemId = [ShopCategory idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager categaoryInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
// 获取所有分类
+ (NSArray *)categoryListAll {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    NSArray *items = [CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取顶层行业分类
+ (NSArray *)categoryList {
    // 父分类为空
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(categoryParent.categoryID == %d)", TopCategoryID];
    NSSortDescriptor *categoryIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];

    NSArray *items = [CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
+ (NSArray *)categoryListWithParent:(NSNumber *)parentID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(categoryParent.categoryID == %@)", parentID];
    NSSortDescriptor *categoryIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:categoryIdSortDescriptor, nil];
    [categoryIdSortDescriptor release];
    NSArray *items = [CoreDataManager objectsForEntity:ShopCategoryEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 初始化本地分类
+ (NSArray *)staticCategory {
    ShopCategory *categoryTop = [ShopDataManager topCategory];
	NSString *path = [ResourceManager pathForResource:@"staticTypes" ofType:@"plist" inDirectory:@"shop"];
	NSArray *staticTypeData = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSDictionary *typeInfo in staticTypeData) {
		ShopCategory *category = [ShopDataManager categaoryInsertWithId:[typeInfo objectForKey:@"categoryID"]];
        category.categoryName = [typeInfo objectForKey:@"categoryName"];
        category.sortOrder = [NSNumber numberWithInteger:[[typeInfo objectForKey:@"sortOrder"] integerValue]];
        
        // 图标
        NSString *logoPath = [typeInfo objectForKey:@"logoPath"];
        File *file = [ShopDataManager fileWithUrl:logoPath isLocal:YES];
		category.logoImage = file;
        
        [categoryTop addCategorySubsObject:category];
        category.categoryParent = categoryTop;
        
		[mutableArray addObject:category];
	}
    [CoreDataManager saveData];
	return [NSArray arrayWithArray:mutableArray];
}
#pragma mark - 积分分类模块 (Credit)
// 默认积分
+ (Credit *)topCredit {
    Credit *item = [ShopDataManager creditInsertWithId:[NSNumber numberWithInteger:TopCreditID]];
    item.creditName = @"全部积分";
    [CoreDataManager saveData];
    return item;
}
// 获取所有积分分类
+ (NSArray *)creditList {
    NSArray *array = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"creditID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    array = [CoreDataManager objectsForEntity:CreditEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
// 添加积分分类
+ (Credit *)creditInsertWithId:(NSNumber *)itemID {
    Credit *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creditID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:CreditEntityName matchingPredicate:predicate] lastObject];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CreditEntityName];
        item.creditID = itemID;
    }
    return item;
}
+ (Credit *)creditInsertWithDict:(NSDictionary *)dict {
    Credit *item = nil;
    NSNumber *itemId = [Credit idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager creditInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 排行分类模块 (ShopSortType)
// 默认排序
+ (ShopSortType *)topShopSortType {
    ShopSortType *item = [ShopDataManager sortInsertWithId:[NSNumber numberWithInteger:TopShopSortTypeID]];
    item.sortName = @"默认";
    return item;
}
// 获取所有积分分类
+ (NSArray *)sortList {
    NSArray *array = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    array = [CoreDataManager objectsForEntity:ShopSortTypeEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
// 查找排行分类
+ (ShopSortType *)sortWithId:(NSNumber *)itemID {
    ShopSortType *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sortID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:ShopSortTypeEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加排行分类
+ (ShopSortType *)sortInsertWithId:(NSNumber *)itemID {
    ShopSortType *item = [ShopDataManager sortWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopSortTypeEntityName];
        item.sortID = itemID;
    }
    return item;
}
+ (ShopSortType *)sortInsertWithDict:(NSDictionary *)dict {
    ShopSortType *item = nil;
    NSNumber *itemId = [ShopSortType idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager sortInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 商户模块 (Shop)
+ (NSArray *)shopList:(NSNumber *)cityID categoryID:(NSNumber *)categoryID creditID:(NSNumber *)creditID regionID:(NSNumber *)regionID rankID:(NSNumber *)rankID keyword:(NSString *)keyword{
    NSArray *items = [NSArray array];
    NSMutableString *formatString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    NSNumber *city = [ShopDataManager cityCurrent].cityID;
    if(city) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(city.cityID == %@)"];
        [valueArray addObject:city];
    }
    if(categoryID && [categoryID integerValue] != TopCategoryID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"((category.categoryID == %@)"];
        [valueArray addObject:categoryID];
        
        NSArray *subArray = [ShopDataManager categoryListWithParent:categoryID];
        if(subArray.count > 0) {
            [formatString appendString:@" or "];
            [formatString appendString:@"(category in %@)"];
            [valueArray addObject:subArray];
        }
        [formatString appendString:@")"];
    }
    if(creditID && [creditID intValue] != TopCreditID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(any credit.creditID == %@)"];
        [valueArray addObject:creditID];
    }
    if(regionID && [regionID intValue] != TopRegionID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(region.regionID == %@)"];
        [valueArray addObject:regionID];
    }
    if(rankID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(any rank.rankID == %@)"];
        [valueArray addObject:rankID];
    }
//    if(sortID) {
//        if(formatString.length > 0)
//            [formatString appendString:@" and "];
//        [formatString appendString:@"(shopOrder.shopSortType.sortID == %@)"];
//        [valueArray addObject:sortID];
//    }
    if(keyword.length > 0) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(shopName like[cd] %@)"];
        [valueArray addObject:[NSString stringWithFormat:@"*%@*", keyword]];
    }
    NSSortDescriptor *sortOrderDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES] autorelease];
    NSSortDescriptor *idDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, idDescriptor, nil];
    
    NSPredicate *predicate = nil;
    if(formatString.length > 0) {
        predicate = [NSPredicate predicateWithFormat:formatString argumentArray:valueArray];
    }
    else {
        predicate = [NSPredicate predicateWithValue:YES];
    }
    
    items = [CoreDataManager objectsForEntity:ShopEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
+ (NSArray *)shopBookmarkList {
    NSArray *items = [NSArray array];
    NSSortDescriptor *sortOrderDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"any userBookmark.userID == %@", [ShopDataManager userCurrent].userID];
    items = [CoreDataManager objectsForEntity:ShopEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
// 查找商户
+ (Shop *)shopWithId:(NSNumber *)itemID {
    Shop *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopID == %@", itemID];
    item = [[CoreDataManager objectsForEntity:ShopEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加商户
+ (Shop *)shopInsertWithId:(NSNumber *)itemID {
    Shop *item = [ShopDataManager shopWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopEntityName];
        item.shopID = itemID;
    }
    return item;
}
+ (Shop *)shopInsertWithDict:(NSDictionary *)dict {
    Shop *item = nil;
    NSNumber *itemId = [Shop idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}

#pragma mark - 点评模块 (Comment)
// 获取所有点评
+ (NSArray *)commentAll {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    items = [CoreDataManager objectsForEntity:CommentEntityName matchingPredicate:predicate];
    return items;
}
// 获取当前用户点评
+ (NSArray *)CommentWithUserCurrent {
    NSArray *items = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"commentID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.userID == %@", [ShopDataManager userCurrent].userID];
    items = [CoreDataManager objectsForEntity:CommentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取商户所有点评
+ (NSArray *)commentWithShopID:(NSNumber *)shopID {
    NSArray *items = [NSArray array];
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"commentID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shop.shopID == %@", shopID];
    items = [CoreDataManager objectsForEntity:CommentEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 查找点评
+ (Comment *)commentWithId:(NSNumber *)itemID {
    Comment *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(commentID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:CommentEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加点评
+ (Comment *)commentInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    Comment *item = [ShopDataManager commentWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CommentEntityName];
        item.commentID = itemID;
    }
    item.shop = [ShopDataManager shopInsertWithId:shopID];
    return item;
}
+ (Comment *)commentInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID {
    Comment *item = nil;
    NSNumber *itemId = [Comment idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager commentInsertWithId:itemId shopID:shopID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 签到模块 (Sign)
// 获取所有签到
+ (NSArray *)signAll {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    items = [CoreDataManager objectsForEntity:SignEntityName matchingPredicate:predicate];
    return items;
}
// 获取当前用户签到
+ (NSArray *)signWithUserCurrent {
    NSArray *items = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"signID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.userID == %@", [ShopDataManager userCurrent].userID];
    items = [CoreDataManager objectsForEntity:SignEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取商户所有签到
+ (NSArray *)signWithShopID:(NSNumber *)shopID {
    NSArray *items = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"signID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shop.shopID == %@", shopID];
    items = [CoreDataManager objectsForEntity:SignEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 查找签到
+ (Sign *)signWithId:(NSNumber *)itemID {
    Sign *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(signID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:SignEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加签到
+ (Sign *)signInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    Sign *item = [ShopDataManager signWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:SignEntityName];
        item.signID = itemID;
    }
    item.shop = [ShopDataManager shopInsertWithId:shopID];
    return item;
}
+ (Sign *)signInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID {
    Sign *item = nil;
    NSNumber *itemId = [Sign idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager signInsertWithId:itemId shopID:shopID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 商户图片模块 (ShopImage)
// 获取所有商户图片分类
+ (NSArray *)shopImageTypeList {
    NSMutableArray *muableArray = [NSMutableArray array];
    [muableArray addObject:ImageTypeProduct];
    [muableArray addObject:ImageTypeAir];
    [muableArray addObject:ImageTypeOther];
    return muableArray;
}
// 获取所有商户图片
+ (NSArray *)shopImageAll {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    items = [CoreDataManager objectsForEntity:ShopImageEntityName matchingPredicate:predicate];
    return items;
}
// 获取当前用户所有商户图片
+ (NSArray *)shopImageUserCurrent:(NSString *)imageType {
    NSArray *items = [NSArray array];
    NSMutableString *formatString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    if(imageType) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(imgType == %@)"];
        [valueArray addObject:imageType];
    }
    if([ShopDataManager userCurrent]) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(user.userID == %@)"];
        [valueArray addObject:[ShopDataManager userCurrent].userID];
    }
    
    
    NSPredicate *predicate = nil;
    if(formatString.length > 0) {
        predicate = [NSPredicate predicateWithFormat:formatString argumentArray:valueArray];
    }
    else {
        predicate = [NSPredicate predicateWithValue:NO];
    }

    NSSortDescriptor *idDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"imgID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shop.shopID == %@)", shopID];
    items = [CoreDataManager objectsForEntity:ShopImageEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 获取商户所有商户图片
+ (NSArray *)shopImageWithShopID:(NSNumber *)shopID imageType:(NSString *)imageType {
    NSArray *items = [NSArray array];
    NSMutableString *formatString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    if(shopID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(shop.shopID == %@)"];
        [valueArray addObject:shopID];
    }
    if(imageType) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(imgType == %@)"];
        [valueArray addObject:imageType];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    if(valueArray.count > 0) {
        predicate = [NSPredicate predicateWithFormat:formatString argumentArray:valueArray];
    }
    NSSortDescriptor *idDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"imgID" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idDescriptor, nil];

    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shop.shopID == %@)", shopID];
    items = [CoreDataManager objectsForEntity:ShopImageEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 查找商户图片
+ (ShopImage *)shopImageWithId:(NSNumber *)itemID {
    ShopImage *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imgID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:ShopImageEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加商户图片
+ (ShopImage *)shopImageInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    ShopImage *item = [ShopDataManager shopImageWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopImageEntityName];
        item.imgID = itemID;
    }
    if([ShopDataManager shopInsertWithId:shopID])
        item.shop = [ShopDataManager shopInsertWithId:shopID];
    return item;
}
+ (ShopImage *)shopImagensertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID {
    ShopImage *item = nil;
    NSNumber *itemId = [ShopImage idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopImageInsertWithId:itemId shopID:shopID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 推荐模块 (Recommend)
+ (NSArray *)recommendWithShopID:(NSNumber *)shopID {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shop.shopID == %@)", shopID];
    items = [CoreDataManager objectsForEntity:RecommendEntityName matchingPredicate:predicate];
    return items;
}
// 查找推荐
+ (Recommend *)recommendWithId:(NSNumber *)itemID {
    Recommend *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(recommendID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:RecommendEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加推荐
+ (Recommend *)recommendInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    Recommend *item = [ShopDataManager recommendWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:RecommendEntityName];
        item.recommendID = itemID;
        item.shop = [ShopDataManager shopInsertWithId:shopID];
    }
    return item;
}
+ (Recommend *)recommendInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID {
    Recommend *item = nil;
    NSNumber *itemId = [Recommend idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager recommendInsertWithId:itemId shopID:shopID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 产品模块 (Product)
+ (NSArray *)productListWithShopID:(NSNumber *)shopID {
    NSArray *items = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shop.shopID == %@)", shopID];
    items = [CoreDataManager objectsForEntity:ProductEntityName matchingPredicate:predicate];
    return items;
}
// 查找产品
+ (Product *)productWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    Product *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(productID == %@) and (shop.shopID == %@)", itemID, shopID];
    item = [[CoreDataManager objectsForEntity:ProductEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加产品
+ (Product *)productInsertWithId:(NSNumber *)itemID shopID:(NSNumber *)shopID {
    Product *item = [ShopDataManager productWithId:itemID shopID:shopID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ProductEntityName];
        item.productID = itemID;
        item.shop = [ShopDataManager shopInsertWithId:shopID];
    }
    return item;
}
+ (Product *)productInsertWithDict:(NSDictionary *)dict shopID:(NSNumber *)shopID {
    Product *item = nil;
    NSNumber *itemId = [Product idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager productInsertWithId:itemId shopID:shopID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 用户模块 (Custom)
// 查找用户
+ (Custom *)customWithId:(NSString *)itemID {
    Custom *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(customID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:CustomEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加用户
+ (Custom *)customInsertWithId:(NSString *)itemID {
    Custom *item = [ShopDataManager customWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:CustomEntityName];
        item.customID = itemID;
    }
    return item;
}
+ (Custom *)customInsertWithDict:(NSDictionary *)dict {
    Custom *item = nil;
    NSString *itemId = [Custom idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager customInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}

#pragma mark - 资讯模块 (ShopNews)
// 获取所有资讯
+ (NSArray *)shopNewsList:(NSNumber *)cityID categoryID:(NSNumber *)categoryID creditID:(NSNumber *)creditID shopNewsTypeId:(NSNumber *)shopNewsTypeId keyword:(NSString *)keyword shopId:(NSNumber *)shopId{
    NSArray *items = [NSArray array];
    NSMutableString *formatString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    NSNumber *city = [ShopDataManager cityCurrent].cityID;
    if(city) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(city.cityID == %@)"];
        [valueArray addObject:city];
    }
    if(categoryID && [categoryID integerValue] != TopCategoryID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"((category.categoryID == %@)"];
        [valueArray addObject:categoryID];
        
        NSArray *subArray = [ShopDataManager categoryListWithParent:categoryID];
        if(subArray.count > 0) {
            [formatString appendString:@" or "];
            [formatString appendString:@"(category in %@)"];
            [valueArray addObject:subArray];
        }
        [formatString appendString:@")"];
    }
    if(creditID && [creditID intValue] != TopCreditID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(any credit.creditID == %@)"];
        [valueArray addObject:creditID];
    }
    if(shopNewsTypeId && [shopNewsTypeId intValue] != TopShopNewsTypeID) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(shopNewsType.shopNewsTypeID == %@)"];
        [valueArray addObject:shopNewsTypeId];
    }
    if(keyword.length > 0) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendFormat:@"(shopName like[cd] %@)", [NSString stringWithFormat:@"*%@*", keyword]];
    }
    if(shopId) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendFormat:@"(shop.shopID == %@)", shopId];
    }
    
    NSPredicate *predicate = nil;
    if(formatString.length > 0) {
        predicate = [NSPredicate predicateWithFormat:formatString argumentArray:valueArray];
    }
    else {
        predicate = [NSPredicate predicateWithValue:YES];
    }
    
    NSSortDescriptor *idDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopNewsID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    
    items = [CoreDataManager objectsForEntity:ShopNewsEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
// 查找资讯
+ (ShopNews *)shopNewsWithId:(NSNumber *)itemID {
    ShopNews *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shopNewsID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:ShopNewsEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加资讯
+ (ShopNews *)shopNewsInsertWithId:(NSNumber *)itemID {
    ShopNews *item = [ShopDataManager shopNewsWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopNewsEntityName];
        item.shopNewsID = itemID;
    }
    return item;
}
+ (ShopNews *)shopNewsInsertWithDict:(NSDictionary *)dict {
    ShopNews *item = nil;
    NSNumber *itemId = [ShopNews idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopNewsInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 资讯分类模块 (ShopNewsType)
// 默认排序
+ (ShopNewsType *)topShopNewsType {
    ShopNewsType *item = [ShopDataManager shopNewsTypeInsertWithId:[NSNumber numberWithInteger:TopShopNewsTypeID]];
    item.shopNewsTypeName = @"全部资讯";
    [CoreDataManager saveData];
    return item;
}
// 获取所有资讯分类
+ (NSArray *)shopNewsTypeList {
    NSArray *array = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopNewsTypeID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    array = [CoreDataManager objectsForEntity:ShopNewsTypeEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return array;
}
// 查找资讯分类
+ (ShopNewsType *)shopNewsTypeWithId:(NSNumber *)itemID {
    ShopNewsType *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shopNewsTypeID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:ShopNewsTypeEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加资讯分类
+ (ShopNewsType *)shopNewsTypeInsertWithId:(NSNumber *)itemID {
    ShopNewsType *item = [ShopDataManager shopNewsTypeWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopNewsTypeEntityName];
        item.shopNewsTypeID = itemID;
    }
    return item;
}
+ (ShopNewsType *)shopNewsTypeInsertWithDict:(NSDictionary *)dict {
    ShopNewsType *item = nil;
    NSNumber *itemId = [ShopNewsType idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopNewsTypeInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 资讯分类排行榜模块 (ShopNewsRank)
// 获取有排行榜的资讯类型
+ (NSArray *)shopNewsRankListHasRank {
    NSArray *items = [NSArray array];
    NSSortDescriptor *shopNewsTypeIdSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopNewsTypeID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:shopNewsTypeIdSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"any shopRanks.rankID > 0"];
    items = [CoreDataManager objectsForEntity:ShopNewsTypeEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    return items;
}
// 根据资讯类型获取所有排行榜分类
+ (NSArray *)shopNewsRankList:(NSNumber *)shopNewsTypeID {
    NSArray *items = [NSArray array];
    
    NSSortDescriptor *idSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"rankID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idSortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopNewsType.shopNewsTypeID == %@", shopNewsTypeID];
    items = [CoreDataManager objectsForEntity:ShopNewsRankEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
// 查找排行榜分类
+ (ShopNewsRank *)shopNewsRankWithId:(NSNumber *)itemID shopNewsTypeID:(NSNumber *)shopNewsTypeID {
    ShopNewsRank *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rankID == %@) and (shopNewsType.shopNewsTypeID == %@)", itemID, shopNewsTypeID];
    item = [[CoreDataManager objectsForEntity:ShopNewsRankEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加排行榜分类
+ (ShopNewsRank *)shopNewsRankInsertWithId:(NSNumber *)itemID shopNewsTypeID:(NSNumber *)shopNewsTypeID {
    ShopNewsRank *item = [ShopDataManager shopNewsRankWithId:itemID shopNewsTypeID:shopNewsTypeID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopNewsRankEntityName];
        item.rankID = itemID;
        
        ShopNewsType *shopNewsType = [ShopDataManager shopNewsTypeInsertWithId:shopNewsTypeID];
        item.shopNewsType = shopNewsType;
    }
    return item;
}
+ (ShopNewsRank *)shopNewsRankInsertWithDict:(NSDictionary *)dict shopNewsTypeID:(NSNumber *)shopNewsTypeID {
    ShopNewsRank *item = nil;
    NSNumber *itemId = [Rank idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopNewsRankInsertWithId:itemId shopNewsTypeID:shopNewsTypeID];
        [item updateWithDict:dict];
    }
    return item;
}
#pragma mark - 资讯图片模块 (ShopNewsPhoto)
// 查找资讯分类
+ (ShopNewsPhoto *)shopNewsPhotoWithShopNewsId:(NSNumber *)shopNewsID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user.userID == %@) and (shopNews.shopNewsID == %@)", [ShopDataManager userCurrent].userID, shopNewsID];
    ShopNewsPhoto *item = [[CoreDataManager objectsForEntity:ShopNewsPhotoEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加资讯分类
+ (ShopNewsPhoto *)shopNewsPhotoInsertWithTypeId:(NSNumber *)shopNewsID {
    ShopNewsPhoto *item = [ShopDataManager shopNewsPhotoWithShopNewsId:shopNewsID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopNewsPhotoEntityName];
        
        item.user = [ShopDataManager userCurrent];
        
        ShopNews *shopNews = [ShopDataManager shopNewsWithId:shopNewsID];
        item.shopNews = shopNews;
    }
    return item;
}
+ (ShopNewsPhoto *)shopNewsPhotoInsertWithDict:(NSDictionary *)dict shopNewsID:(NSNumber *)shopNewsID{
    ShopNewsPhoto *item = nil;
    item = [ShopDataManager shopNewsPhotoInsertWithTypeId:shopNewsID];
    [item updateWithDict:dict];
    return item;
}

#pragma mark - 我的券券模块 (ShopNews)
// 获取所有我的券券
+ (NSArray *)shopPersonalNewsList:(NSNumber *)status{
    NSArray *items = [NSArray array];
    NSMutableString *formatString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    if(status) {
        if(formatString.length > 0)
            [formatString appendString:@" and "];
        [formatString appendString:@"(status == %@)"];
        [valueArray addObject:status];
    }
    
    if(formatString.length > 0)
        [formatString appendString:@" and "];
    [formatString appendString:@"(user.userID == %@)"];
    [valueArray addObject:[ShopDataManager userCurrent].userID];
    
    NSPredicate *predicate = nil;
    if(formatString.length > 0) {
        predicate = [NSPredicate predicateWithFormat:formatString argumentArray:valueArray];
    }
    else {
        predicate = [NSPredicate predicateWithValue:YES];
    }
    
    NSSortDescriptor *idDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"shopNewsID" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    
    items = [CoreDataManager objectsForEntity:ShopPersonalNewsEntityName matchingPredicate:predicate sortDescriptors:sortDescriptors];
    
    return items;
}
// 查找我的券券
+ (ShopPersonalNews *)shopPersonalNewsWithId:(NSNumber *)itemID {
    ShopPersonalNews *item = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(myInfoID == %@)", itemID];
    item = [[CoreDataManager objectsForEntity:ShopPersonalNewsEntityName matchingPredicate:predicate] lastObject];
    return item;
}
// 添加我的券券
+ (ShopPersonalNews *)shopPersonalNewsInsertWithId:(NSNumber *)itemID {
    ShopPersonalNews *item = [ShopDataManager shopPersonalNewsWithId:itemID];
    if(!item) {
        item = [CoreDataManager insertNewObjectForEntityForName:ShopPersonalNewsEntityName];
        item.myInfoID = itemID;
    }
    return item;
}
+ (ShopPersonalNews *)shopPersonalNewsInsertWithDict:(NSDictionary *)dict {
    ShopPersonalNews *item = nil;
    NSNumber *itemId = [ShopPersonalNews idWithDict:dict];
    if(itemId) {
        item = [ShopDataManager shopPersonalNewsInsertWithId:itemId];
        [item updateWithDict:dict];
    }
    return item;
}
@end
