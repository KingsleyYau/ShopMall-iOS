//
//  Region.h
//  ShopMall
//
//  Created by KingsleyYau on 13-5-11.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Region, Shop;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSNumber * dsfShopCount;
@property (nonatomic, retain) NSNumber * hyfShopCount;
@property (nonatomic, retain) NSNumber * isAlreadyLoad;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * regionID;
@property (nonatomic, retain) NSString * regionName;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) Region *parent;
@property (nonatomic, retain) NSSet *shops;
@property (nonatomic, retain) NSSet *subs;
@property (nonatomic, retain) City *city;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addShopsObject:(Shop *)value;
- (void)removeShopsObject:(Shop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;
- (void)addSubsObject:(Region *)value;
- (void)removeSubsObject:(Region *)value;
- (void)addSubs:(NSSet *)values;
- (void)removeSubs:(NSSet *)values;
@end
