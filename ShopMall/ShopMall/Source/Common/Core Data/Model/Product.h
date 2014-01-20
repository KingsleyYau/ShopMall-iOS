//
//  Product.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Shop;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) File *productImage;
@property (nonatomic, retain) Shop *shop;

@end
