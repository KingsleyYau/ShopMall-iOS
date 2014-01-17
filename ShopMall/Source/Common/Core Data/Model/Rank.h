//
//  Rank.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Shop, ShopCategory;

@interface Rank : NSManagedObject

@property (nonatomic, retain) NSNumber * rankID;
@property (nonatomic, retain) NSString * rankName;
@property (nonatomic, retain) ShopCategory *category;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *shops;
@end

@interface Rank (CoreDataGeneratedAccessors)

- (void)addShopsObject:(Shop *)value;
- (void)removeShopsObject:(Shop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;
@end
