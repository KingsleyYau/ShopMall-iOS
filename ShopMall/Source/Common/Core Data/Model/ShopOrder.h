//
//  ShopOrder.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shop, ShopSortType;

@interface ShopOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) ShopSortType *shopSortType;
@property (nonatomic, retain) Shop *shop;

@end
