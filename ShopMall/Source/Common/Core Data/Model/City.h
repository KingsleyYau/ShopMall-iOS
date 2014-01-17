//
//  City.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityRegion, CurrentInfo, Region, Shop, ShopCategory, ShopNews;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * cityCode;
@property (nonatomic, retain) NSNumber * cityID;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * firstChar;
@property (nonatomic, retain) NSNumber * isHot;
@property (nonatomic, retain) NSNumber * isPromo;
@property (nonatomic, retain) NSNumber * isTop;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSSet *category;
@property (nonatomic, retain) CityRegion *cityRegion;
@property (nonatomic, retain) NSSet *region;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) NSSet *shops;
@property (nonatomic, retain) CurrentInfo *currentInfoGps;
@property (nonatomic, retain) CurrentInfo *currentInfoCity;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(ShopCategory *)value;
- (void)removeCategoryObject:(ShopCategory *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;
- (void)addRegionObject:(Region *)value;
- (void)removeRegionObject:(Region *)value;
- (void)addRegion:(NSSet *)values;
- (void)removeRegion:(NSSet *)values;
- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
- (void)addShopsObject:(Shop *)value;
- (void)removeShopsObject:(Shop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;
@end
