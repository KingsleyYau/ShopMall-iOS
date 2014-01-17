//
//  Credit.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Shop, ShopNews;

@interface Credit : NSManagedObject

@property (nonatomic, retain) NSNumber * creditID;
@property (nonatomic, retain) NSString * creditName;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *shop;
@property (nonatomic, retain) ShopNews *shopNews;
@end

@interface Credit (CoreDataGeneratedAccessors)

- (void)addShopObject:(Shop *)value;
- (void)removeShopObject:(Shop *)value;
- (void)addShop:(NSSet *)values;
- (void)removeShop:(NSSet *)values;
@end
