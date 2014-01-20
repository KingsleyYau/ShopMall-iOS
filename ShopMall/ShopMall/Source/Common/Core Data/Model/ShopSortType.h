//
//  ShopSortType.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopSortType : NSManagedObject

@property (nonatomic, retain) NSNumber * sortID;
@property (nonatomic, retain) NSString * sortName;

@end
