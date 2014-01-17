//
//  ShopNewsRank.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, ShopNews, ShopNewsType;

@interface ShopNewsRank : NSManagedObject

@property (nonatomic, retain) NSNumber * rankID;
@property (nonatomic, retain) NSString * rankName;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) ShopNewsType *shopNewsType;
@end

@interface ShopNewsRank (CoreDataGeneratedAccessors)

- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
@end
