//
//  ShopNewsRankCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopNewsRank.h"
@interface ShopNewsRank(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
