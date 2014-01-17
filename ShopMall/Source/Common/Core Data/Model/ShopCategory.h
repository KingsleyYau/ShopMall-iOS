//
//  ShopCategory.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, File, Rank, Shop, ShopCategory, ShopNews;

@interface ShopCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * dsfShopCount;
@property (nonatomic, retain) NSNumber * hyfShopCount;
@property (nonatomic, retain) NSNumber * isAlreadyLoad;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) ShopCategory *categoryParent;
@property (nonatomic, retain) NSSet *categorySubs;
@property (nonatomic, retain) NSSet *city;
@property (nonatomic, retain) File *logoImage;
@property (nonatomic, retain) NSSet *ranks;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) NSSet *shops;
@end

@interface ShopCategory (CoreDataGeneratedAccessors)

- (void)addCategorySubsObject:(ShopCategory *)value;
- (void)removeCategorySubsObject:(ShopCategory *)value;
- (void)addCategorySubs:(NSSet *)values;
- (void)removeCategorySubs:(NSSet *)values;
- (void)addCityObject:(City *)value;
- (void)removeCityObject:(City *)value;
- (void)addCity:(NSSet *)values;
- (void)removeCity:(NSSet *)values;
- (void)addRanksObject:(Rank *)value;
- (void)removeRanksObject:(Rank *)value;
- (void)addRanks:(NSSet *)values;
- (void)removeRanks:(NSSet *)values;
- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
- (void)addShopsObject:(Shop *)value;
- (void)removeShopsObject:(Shop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;
@end
