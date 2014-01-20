//
//  ShopSortTypeCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopSortType.h"
@interface ShopSortType(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
