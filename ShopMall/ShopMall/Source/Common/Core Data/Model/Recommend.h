//
//  Recommend.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Custom, Shop;

@interface Recommend : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * recommendID;
@property (nonatomic, retain) NSString * recommendTag;
@property (nonatomic, retain) Custom *custom;
@property (nonatomic, retain) Shop *shop;

@end
