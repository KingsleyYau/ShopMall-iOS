//
//  ShopNewsType.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, ShopNews, ShopNewsRank;

@interface ShopNewsType : NSManagedObject

@property (nonatomic, retain) NSNumber * shopNewsTypeID;
@property (nonatomic, retain) NSString * shopNewsTypeName;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) NSSet *shopRanks;
@end

@interface ShopNewsType (CoreDataGeneratedAccessors)

- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
- (void)addShopRanksObject:(ShopNewsRank *)value;
- (void)removeShopRanksObject:(ShopNewsRank *)value;
- (void)addShopRanks:(NSSet *)values;
- (void)removeShopRanks:(NSSet *)values;
@end
